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

  # Validate package name format early (before other validations)
  pkg_name <- basename(path)
  if (!grepl("^[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]$", pkg_name)) {
    stop(
      "Invalid package name '",
      pkg_name,
      "'. ",
      "Package names must start with a letter, contain only letters, numbers, and dots, ",
      "and cannot end with a dot.",
      call. = FALSE
    )
  }

  # Validate license early (required parameter with fixed values)
  supported_licenses <- c("MIT", "GPL-3")
  if (!license %in% supported_licenses) {
    stop(
      "'license' must be one of: ",
      paste(supported_licenses, collapse = ", "),
      call. = FALSE
    )
  }

  # Validate author is provided
  if (missing(author) || is.null(author) || author == "") {
    stop("'author' must be provided and cannot be empty.", call. = FALSE)
  }

  # Validate author has at least first and last name
  author_parts <- strsplit(trimws(author), "\\s+")[[1]]
  if (length(author_parts) < 2) {
    stop(
      "Author name must include at least a first and last name separated by a space. ",
      "Received: '",
      author,
      "'",
      call. = FALSE
    )
  }

  # Validate email format if provided (optional parameter, validate last)
  if (!missing(email) && !is.null(email) && email != "") {
    if (!grepl("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", email)) {
      stop(
        "'email' must be a valid email address (e.g., user@example.com).",
        call. = FALSE
      )
    }
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
      "Received: '",
      author,
      "'",
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
    warning(
      "Unsupported license: ",
      license,
      ". Skipping license setup.",
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' @title Make Package
#'
#' @description Create a new R package with the specified parameters. This function
#' automates the process of creating an R package structure, including DESCRIPTION file,
#' README, license files, and optionally sets up Git, GitHub, and pkgdown documentation.
#'
#' @details
#' The function includes comprehensive input validation to ensure:
#' \itemize{
#'   \item Package names follow R conventions (start with letter, contain only letters/numbers/dots)
#'   \item Email addresses are properly formatted
#'   \item Author names include at least first and last name
#'   \item The target directory doesn't already exist
#' }
#'
#' If any operation fails (e.g., Git/GitHub setup), the function continues and warns
#' rather than failing completely, ensuring you still get a usable package structure.
#'
#' @param path character. The path where the package will be created. Can be a simple
#'   package name (creates in current directory) or a full path. Package name must start
#'   with a letter and contain only letters, numbers, and dots.
#' @param author character. Full name of the package author (e.g., "Jane Doe"). Must
#'   include at least a first and last name separated by space.
#' @param email character. Email address of the author. Optional, but must be a valid
#'   email format if provided.
#' @param git logical. Whether to initialize a Git repository for the package. Default: TRUE.
#' @param git_username character. The username to use for Git configuration. Optional;
#'   only used if git = TRUE.
#' @param git_email character. The email to use for Git configuration. Optional;
#'   only used if git = TRUE.
#' @param readme_md logical. Whether to create a README.md file. Default: TRUE.
#' @param check_pkg_name logical. Whether to check that the package name is available
#'   on CRAN using the 'available' package. Default: TRUE.
#' @param license character. The license to use for the package. Must be either "MIT"
#'   or "GPL-3". Default: "MIT".
#' @param pkgdown logical. Whether to set up and build a pkgdown documentation site.
#'   Default: TRUE. Note: this can take some time to build.
#'
#' @return Invisibly returns a list with three elements:
#'   \itemize{
#'     \item \code{path}: Full path to the created package
#'     \item \code{package_name}: Name of the package
#'     \item \code{success}: TRUE if package was created successfully
#'   }
#'
#' @examples
#' \dontrun{
#' # Create a simple package with MIT license
#' mk_pkg(
#'   path = "mypackage",
#'   author = "Jane Doe",
#'   email = "jane.doe@example.com",
#'   git = FALSE,
#'   pkgdown = FALSE
#' )
#'
#' # Create a package without email
#' mk_pkg(
#'   path = "simplepackage",
#'   author = "Jane Doe",
#'   git = FALSE,
#'   pkgdown = FALSE
#' )
#'
#' # Create a package with Git and GPL-3 license
#' mk_pkg(
#'   path = "~/projects/analysisPkg",
#'   author = "John Smith Wilson",
#'   email = "john@example.com",
#'   git = TRUE,
#'   git_username = "jsmith",
#'   git_email = "john@example.com",
#'   license = "GPL-3"
#' )
#' }
#'
#' @import usethis
#' @importFrom available available
#' @importFrom desc desc
#' @importFrom withr defer
#' @export

mk_pkg <- function(
  path,
  author,
  email = NULL,
  git = TRUE,
  git_username = NULL,
  git_email = NULL,
  readme_md = TRUE,
  check_pkg_name = TRUE,
  license = "MIT",
  pkgdown = TRUE
) {
  # Validate path is provided before normalizePath (which will error on NULL)
  if (missing(path) || is.null(path) || path == "") {
    stop("'path' must be provided and cannot be empty.", call. = FALSE)
  }

  # Convert to absolute path early for consistency
  path <- normalizePath(path, mustWork = FALSE)

  # Check if directory already exists (do this early)
  if (dir.exists(path)) {
    stop(
      "Directory '",
      path,
      "' already exists. Please choose a different path.",
      call. = FALSE
    )
  }

  # Input validation
  validate_inputs(path, author, email, license)

  # Extract package name from path
  pkg_name <- basename(path)

  # Check package name availability if requested
  if (check_pkg_name) {
    message("Checking package name availability on CRAN...")
    tryCatch(
      available::available(name = pkg_name, browse = FALSE),
      error = function(e) {
        warning(
          "Could not check package name availability: ",
          e$message,
          call. = FALSE
        )
      }
    )
  }

  tryCatch(
    {
      # Use the usethis::create_package function to create the package
      message("Creating package structure...")
      usethis::create_package(path = path, rstudio = TRUE, open = FALSE)

      # Parse the author's name into first and last name
      author_parts <- parse_author_name(author)

      # Set the active project for usethis functions
      # Use withr::defer to ensure project is reset even if function exits early
      old_project <- tryCatch(usethis::proj_get(), error = function(e) NULL)
      withr::defer({
        if (!is.null(old_project)) {
          usethis::proj_set(old_project, force = TRUE)
        }
      })
      usethis::proj_set(path, force = TRUE)

      # Update the DESCRIPTION file with author information using desc package
      message("Setting up DESCRIPTION file...")
      desc_obj <- desc::desc(file.path(path, "DESCRIPTION"))

      # Set the author using person object
      # Only include email if provided
      if (!is.null(email) && email != "") {
        desc_obj$set_authors(
          person(
            given = author_parts$first,
            family = author_parts$last,
            email = email,
            role = c("aut", "cre")
          )
        )
      } else {
        desc_obj$set_authors(
          person(
            given = author_parts$first,
            family = author_parts$last,
            role = c("aut", "cre")
          )
        )
      }

      # Write the updated DESCRIPTION file
      desc_obj$write()

      # If readme_md is TRUE, use the usethis::use_readme_md function to create a README file
      if (readme_md) {
        message("Creating README.md...")
        tryCatch(
          usethis::use_readme_md(open = FALSE),
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
        tryCatch(
          {
            usethis::use_git(message = "Initial commit")

            if (!is.null(git_username) && !is.null(git_email)) {
              usethis::use_git_config(
                scope = "project",
                user.name = git_username,
                user.email = git_email
              )
            }

            # Only attempt GitHub setup if credentials are available
            tryCatch(
              usethis::use_github(),
              error = function(e) {
                warning(
                  "Could not create GitHub repository. ",
                  "You may need to set up GitHub credentials. ",
                  "Error: ",
                  e$message,
                  call. = FALSE
                )
              }
            )
          },
          error = function(e) {
            warning(
              "Failed to initialize Git repository: ",
              e$message,
              call. = FALSE
            )
          }
        )
      }

      # If pkgdown is TRUE, set up pkgdown site
      if (pkgdown) {
        message("Setting up pkgdown site...")
        tryCatch(
          {
            usethis::use_pkgdown()
            pkgdown::build_site()
          },
          error = function(e) {
            warning("Failed to build pkgdown site: ", e$message, call. = FALSE)
          }
        )
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
    },
    error = function(e) {
      # If package creation failed, provide helpful error message
      error_msg <- paste0(
        "Failed to create package '",
        pkg_name,
        "': ",
        e$message,
        "\n\nIf a partial package directory was created, you may need to delete it manually."
      )

      stop(error_msg, call. = FALSE)
    }
  )
}

#' @title Make Package from Config
#'
#' @description Create a package based on a YAML or JSON configuration file. This provides
#' a convenient way to store and reuse package creation settings.
#'
#' @details
#' The configuration file must contain at minimum:
#' \itemize{
#'   \item \code{pkg_name}: Package name
#'   \item \code{first_name}: Author's first name
#'   \item \code{last_name}: Author's last name
#' }
#'
#' Optional fields include: \code{email}, \code{readme_md}, \code{git}, \code{git_username},
#' \code{git_email}, \code{check_pkg_name}, \code{license}, and \code{pkgdown}.
#'
#' @param config_path character. Path to the configuration file. File must exist.
#' @param file_type character. The file type of the configuration file. Must be either
#'   "yaml" or "json". Default: "yaml".
#'
#' @return Invisibly returns a list with package information (see \code{\link{mk_pkg}}).
#'
#' @examples
#' \dontrun{
#' # Create a config file
#' config <- list(
#'   pkg_name = "mypackage",
#'   first_name = "Jane",
#'   last_name = "Doe",
#'   email = "jane@example.com",
#'   license = "MIT"
#' )
#' write_config("pkg_config.yaml", config)
#'
#' # Create package from config
#' mk_pkg_from_config("pkg_config.yaml", file_type = "yaml")
#' }
#'
#' @seealso \code{\link{mk_pkg}}, \code{\link{import_config}}, \code{\link{write_config}}
#' @export
mk_pkg_from_config <- function(config_path, file_type = "yaml") {
  # Validate config file exists
  if (!file.exists(config_path)) {
    stop("Configuration file not found: ", config_path, call. = FALSE)
  }

  # Validate file_type
  if (!file_type %in% c("yaml", "json")) {
    stop("file_type must be either 'yaml' or 'json'", call. = FALSE)
  }

  # Import configuration data with error handling
  config_data <- tryCatch(
    pkgmkr::import_config(config_path, file_type),
    error = function(e) {
      stop(
        "Failed to read configuration file '",
        config_path,
        "': ",
        e$message,
        call. = FALSE
      )
    }
  )

  # Define required fields
  required_fields <- c("pkg_name", "first_name", "last_name")
  missing_fields <- setdiff(required_fields, names(config_data))

  if (length(missing_fields) > 0) {
    stop(
      "Configuration file is missing required field(s): ",
      paste(missing_fields, collapse = ", "),
      call. = FALSE
    )
  }

  # Extract configuration data with defaults
  pkg_name <- config_data$pkg_name
  first_name <- config_data$first_name
  last_name <- config_data$last_name
  email <- config_data$email %||% NULL
  readme_md <- config_data$readme_md %||% TRUE
  git <- config_data$git %||% FALSE
  git_username <- config_data$git_username %||% NULL
  git_email <- config_data$git_email %||% NULL
  check_pkg_name <- config_data$check_pkg_name %||% TRUE
  license <- config_data$license %||% "MIT"
  pkgdown <- config_data$pkgdown %||% FALSE

  # Validate extracted values
  if (is.null(pkg_name) || pkg_name == "") {
    stop("pkg_name in config file cannot be empty", call. = FALSE)
  }

  if (
    is.null(first_name) ||
      first_name == "" ||
      is.null(last_name) ||
      last_name == ""
  ) {
    stop(
      "first_name and last_name in config file cannot be empty",
      call. = FALSE
    )
  }

  # Concatenate first_name and last_name into author
  author <- paste(first_name, last_name, sep = " ")

  # Call mk_pkg with the configuration
  message("Creating package from config file: ", config_path)
  mk_pkg(
    path = pkg_name,
    author = author,
    email = email,
    git = git,
    git_username = git_username,
    git_email = git_email,
    readme_md = readme_md,
    check_pkg_name = check_pkg_name,
    license = license,
    pkgdown = pkgdown
  )
}

# Helper function for NULL-coalescing
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
