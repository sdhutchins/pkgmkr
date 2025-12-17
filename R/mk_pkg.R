# Internal helper functions

#' Validate input parameters for package creation
#' @param path character. Package path
#' @param author character. Author name
#' @param email character. Email address
#' @param license character. License type
#' @noRd
validate_inputs <- function(path, author, email, license) {
  # Validate path is provided
  if (missing(path) || is.null(path) || path == "") {
    stop("'path' must be provided and cannot be empty.", call. = FALSE)
  }
  
  # Validate author is provided
  if (missing(author) || is.null(author) || author == "") {
    stop("'author' must be provided and cannot be empty.", call. = FALSE)
  }
  
  # Validate email is provided and properly formatted
  if (missing(email) || is.null(email) || email == "") {
    stop("'email' must be provided and cannot be empty.", call. = FALSE)
  }
  
  if (!grepl("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", email)) {
    stop("'email' must be a valid email address (e.g., user@example.com).", call. = FALSE)
  }
  
  # Validate package name format
  pkg_name <- basename(path)
  if (!grepl("^[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]$", pkg_name)) {
    stop(
      "Invalid package name '", pkg_name, "'. ",
      "Package names must start with a letter, contain only letters, numbers, and dots, ",
      "and cannot end with a dot.",
      call. = FALSE
    )
  }
  
  # Validate license
  supported_licenses <- c("MIT", "GPL-3")
  if (!license %in% supported_licenses) {
    stop(
      "'license' must be one of: ", paste(supported_licenses, collapse = ", "),
      call. = FALSE
    )
  }
  
  invisible(TRUE)
}

#' Parse author name into first and last name
#' @param author character. Full author name
#' @return list with 'first' and 'last' components
#' @noRd
parse_author_name <- function(author) {
  # Split the name by spaces
  parts <- strsplit(trimws(author), "\\s+")[[1]]
  
  if (length(parts) < 2) {
    stop(
      "Author name must include at least a first and last name separated by a space. ",
      "Received: '", author, "'",
      call. = FALSE
    )
  }
  
  # First part is the first name, everything else is the last name
  list(
    first = parts[1],
    last = paste(parts[-1], collapse = " ")
  )
}

#' Set up license for the package
#' @param license character. License type
#' @param author character. Copyright holder name
#' @noRd
setup_license <- function(license, author) {
  message("Setting up ", license, " license...")
  
  if (license == "MIT") {
    usethis::use_mit_license(copyright_holder = author)
  } else if (license == "GPL-3") {
    usethis::use_gpl3_license()
  } else {
    warning("Unsupported license: ", license, ". Skipping license setup.", call. = FALSE)
  }
  
  invisible(NULL)
}

#' @title Make Package
#'
#' @description Create a new R package with the specified parameters
#'
#' @param path character. The path to create the package at.
#' @param author character. The name of the package author.
#' @param email character. The email to use for Git and GitHub.
#' @param git logical. Whether to initialize a Git repository for the package.
#' @param git_username character. The username to use for Git and GitHub.
#' @param git_email character. The email to use for Git and GitHub.
#' @param readme_md logical. Whether to create a README file in markdown format.
#' @param check_pkg_name logical. Whether to check that the package name is available on CRAN.
#' @param license character. The license to use for the package (either "MIT" or "GPL-3").
#' @param pkgdown logical. Whether to create a pkgdown site for the package.
#' @import usethis
#' @importFrom available available
#' @importFrom withr local_dir
#' @return Invisibly returns a list with package information
#' @export

mk_pkg <- function(path, author, email, git = TRUE, git_username = NULL, git_email = NULL, readme_md = TRUE, check_pkg_name = TRUE, license = "MIT", pkgdown = TRUE) {
  
  # Input validation
  validate_inputs(path, author, email, license)
  
  # Extract package name from path
  pkg_name <- basename(path)
  
  # Check if directory already exists
  if (dir.exists(path)) {
    stop("Directory '", path, "' already exists. Please choose a different path.", call. = FALSE)
  }
  
  # Check package name availability if requested
  if (check_pkg_name) {
    message("Checking package name availability on CRAN...")
    tryCatch(
      available::available(name = pkg_name, browse = FALSE),
      error = function(e) {
        warning("Could not check package name availability: ", e$message, call. = FALSE)
      }
    )
  }
  
  # Track whether package directory was created for cleanup on error
  pkg_created <- FALSE
  
  tryCatch({
    # Use the usethis::create_package function to create the package
    message("Creating package structure...")
    usethis::create_package(path = path, rstudio = TRUE, open = FALSE)
    pkg_created <- TRUE

    # Parse the author's name into first and last name
    author_parts <- parse_author_name(author)

    # Use withr::local_dir instead of setwd to avoid changing user's working directory
    withr::local_dir(path)

    # Use the usethis::use_description function to set the package's Authors@R field
    message("Setting up DESCRIPTION file...")
    usethis::use_description(fields = list(
      `Authors@R` = paste0(
        'person("', author_parts$first, '", "', author_parts$last, 
        '", email = "', email, '", role = c("aut", "cre"))'
      )
    ))

    # If readme_md is TRUE, use the usethis::use_readme_md function to create a README file
    if (readme_md) {
      message("Creating README.md...")
      tryCatch(
        usethis::use_readme_md(),
        error = function(e) {
          warning("Failed to create README.md: ", e$message, call. = FALSE)
        }
      )
    }

    # Set up license
    tryCatch(
      setup_license(license, author),
      error = function(e) {
        warning("Failed to set up license: ", e$message, call. = FALSE)
      }
    )

    # If git is TRUE, initialize Git repository
    if (git) {
      message("Initializing Git repository...")
      tryCatch({
        usethis::use_git()
        
        if (!is.null(git_username) && !is.null(git_email)) {
          usethis::use_git_config(scope = "project", user.name = git_username, user.email = git_email)
        }
        
        # Only attempt GitHub setup if credentials are available
        tryCatch(
          usethis::use_github(),
          error = function(e) {
            warning(
              "Could not create GitHub repository. ",
              "You may need to set up GitHub credentials. ",
              "Error: ", e$message,
              call. = FALSE
            )
          }
        )
      }, error = function(e) {
        warning("Failed to initialize Git repository: ", e$message, call. = FALSE)
      })
    }

    # If pkgdown is TRUE, set up pkgdown site
    if (pkgdown) {
      message("Setting up pkgdown site...")
      tryCatch({
        usethis::use_pkgdown()
        pkgdown::build_site()
      }, error = function(e) {
        warning("Failed to build pkgdown site: ", e$message, call. = FALSE)
      })
    }
    
    message("\n", strrep("=", 60))
    message("SUCCESS! Package '", pkg_name, "' created at:")
    message(path)
    message(strrep("=", 60), "\n")
    
    # Return package information invisibly
    invisible(list(
      path = path,
      package_name = pkg_name,
      success = TRUE
    ))
    
  }, error = function(e) {
    # If package creation failed, provide helpful error message
    error_msg <- paste0(
      "Failed to create package '", pkg_name, "': ", e$message,
      "\n\nIf a partial package directory was created, you may need to delete it manually."
    )
    
    stop(error_msg, call. = FALSE)
  })
}

#' @title Make Package from Config
#'
#' @description Create a package based on a configuration file.
#'
#' @param config_path character. The path to the configuration file.
#' @param file_type character. The file type of the configuration file (either "yaml" or "json").
#' @return NULL
#' @export
mk_pkg_from_config <- function(config_path, file_type = "yaml") {
  # Use the import_config function to import the configuration data
  config_data <- pkgmkr::import_config(config_path, file_type)

  # Extract the configuration data from the config_data list
  pkg_name <- config_data$pkg_name
  first_name <- config_data$first_name
  last_name <- config_data$last_name
  readme_md <- config_data$readme_md
  git <- config_data$git
  check_pkg_name <- config_data$check_pkg_name
  license <- config_data$license
  pkgdown <- config_data$pkgdown

  # Concatenate the first_name and last_name into a single string for the author argument
  author <- paste(first_name, last_name, sep = " ")

  # Call the mk_package function with the appropriate arguments
  mk_pkg(path = pkg_name, author = author, email = NULL, readme_md = readme_md, git = git, check_pkg_name = check_pkg_name, license = license, pkgdown = pkgdown)
}
