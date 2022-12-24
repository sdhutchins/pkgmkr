#' @title Make Package
#'
#' @description Create a new R package with the specified parameters
#'
#' @param path character. The path to create the package at.
#' @param author character. The name of the package author.
#' @param git_username character. The username to use for Git and GitHub.
#' @param email character. The email to use for Git and GitHub.
#' @param readme_md logical. Whether to create a README file in markdown format.
#' @param git logical. Whether to initialize a Git repository for the package.
#' @param check_pkg_name logical. Whether to check that the package name is available on CRAN.
#' @param license character. The license to use for the package (either "MIT" or "GPL-3").
#' @param pkgdown logical. Whether to create a pkgdown site for the package.
#' @import usethis
#' @importFrom available available
#' @return NULL
#' @export

mk_pkg <- function(path, author, email, git = TRUE, git_username = NULL, git_email = NULL, readme_md = TRUE, check_pkg_name = TRUE, license = "MIT", pkgdown = TRUE) {
  # Use the usethis::create_package function to create the package
  usethis::create_package(path = path, rstudio = TRUE, open = FALSE)

  # Split the author's name into first and last name
  names <- as.list(strsplit(author, split = " ")[[1]])

  # Set the working directory to the package's path
  setwd(path)

  # Use the usethis::use_description function to set the package's Authors@R field
  usethis::use_description(fields = list(
    `Authors@R` = paste0('person("', names[1], '", "', names[2], '", email = "', email, '", role = c("aut", "cre"))')
  ))

  # If check_pkg_name is TRUE, check if the package name is available on CRAN
  if (check_pkg_name) {
    print(path)
    available::available(name = path, browse = FALSE)
  }

  # If readme_md is TRUE, use the usethis::use_readme_md function to create a README file in markdown format
  if (readme_md) {
    usethis::use_readme_md()
  }

  # If license is "MIT", use the usethis::use_mit_license function to set the package's license to MIT
  if (license == "MIT") {
    usethis::use_mit_license(copyright_holder = author)
  }


  # If git is TRUE, use the usethis::use_git function to initialize a Git repository for the package, then use the use_git_config function to set the user name and email for Git and GitHub.
  if (git) {
    usethis::use_git()
    usethis::use_git_config(scope = "project", user.name = git_username, user.email = git_email)
    usethis::use_github()
  }

  # If pkgdown is TRUE, use the usethis::use_pkgdown function to set up pkgdown for the package, then use the pkgdown::build_site function to build the pkgdown site.
  if (pkgdown) {
    usethis::use_pkgdown()
    pkgdown::build_site()
  }
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
