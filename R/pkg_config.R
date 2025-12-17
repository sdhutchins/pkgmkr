#' @title Import Package Configuration
#'
#' @description Import package configuration data from a YAML or JSON file.
#'
#' @details
#' This function reads and validates a configuration file. The file must exist and
#' contain valid YAML or JSON. If the file is malformed, a helpful error message
#' will indicate the parsing issue.
#'
#' @param path character. Path to the configuration file. Must be a valid file path
#'   to an existing file.
#' @param file_type character. The file type - must be either "yaml" or "json".
#'   Default: "yaml".
#'
#' @return A list containing the configuration data from the file.
#'
#' @examples
#' \dontrun{
#' # Import a YAML config
#' config <- import_config("my_config.yaml", "yaml")
#' print(config$pkg_name)
#'
#' # Import a JSON config
#' config <- import_config("my_config.json", "json")
#' }
#'
#' @seealso \code{\link{write_config}}, \code{\link{mk_pkg_from_config}}
#' @importFrom configr read.config
#' @export
import_config <- function(path, file_type = "yaml") {
  
  # Validate inputs
  if (missing(path) || is.null(path) || path == "") {
    stop("'path' must be provided and cannot be empty", call. = FALSE)
  }
  
  if (!file.exists(path)) {
    stop("Configuration file not found: ", path, call. = FALSE)
  }
  
  if (!file_type %in% c("yaml", "json")) {
    stop("'file_type' must be either 'yaml' or 'json'", call. = FALSE)
  }
  
  # Read configuration data with error handling
  config_data <- tryCatch(
    configr::read.config(file = path, file.type = file_type),
    error = function(e) {
      stop(
        "Failed to parse configuration file '", path, "': ",
        e$message,
        "\nPlease check that the file is valid ", toupper(file_type), ".",
        call. = FALSE
      )
    }
  )
  
  # Validate that we got data back
  if (is.null(config_data) || length(config_data) == 0) {
    stop("Configuration file '", path, "' appears to be empty", call. = FALSE)
  }

  return(config_data)
}

#' @title Write Package Configuration
#'
#' @description Write package configuration data to a YAML file for later use with
#' \code{\link{mk_pkg_from_config}}.
#'
#' @details
#' This function creates a YAML configuration file that can be used to create packages
#' with consistent settings. If the parent directory doesn't exist, it will be created
#' automatically.
#'
#' @param path character. Path where the configuration file will be written. Parent
#'   directories will be created if they don't exist.
#' @param config_data list. The configuration data to write. Must be a named list
#'   containing package configuration parameters.
#'
#' @return Invisibly returns TRUE on success.
#'
#' @examples
#' \dontrun{
#' # Create a configuration
#' config <- list(
#'   pkg_name = "mypackage",
#'   first_name = "Jane",
#'   last_name = "Doe",
#'   email = "jane@example.com",
#'   readme_md = TRUE,
#'   git = FALSE,
#'   license = "MIT"
#' )
#'
#' # Write to file
#' write_config("configs/my_package.yaml", config)
#'
#' # Later, create package from this config
#' mk_pkg_from_config("configs/my_package.yaml")
#' }
#'
#' @seealso \code{\link{import_config}}, \code{\link{mk_pkg_from_config}}
#' @importFrom configr write.config
#' @export
write_config <- function(path, config_data) {
  
  # Validate inputs
  if (missing(path) || is.null(path) || path == "") {
    stop("'path' must be provided and cannot be empty", call. = FALSE)
  }
  
  if (missing(config_data) || is.null(config_data)) {
    stop("'config_data' must be provided and cannot be NULL", call. = FALSE)
  }
  
  if (!is.list(config_data)) {
    stop("'config_data' must be a list", call. = FALSE)
  }
  
  # Check if directory exists, create if needed
  config_dir <- dirname(path)
  if (!dir.exists(config_dir)) {
    message("Creating directory: ", config_dir)
    tryCatch(
      dir.create(config_dir, recursive = TRUE),
      error = function(e) {
        stop("Failed to create directory '", config_dir, "': ", e$message, call. = FALSE)
      }
    )
  }
  
  # Write configuration data with error handling
  tryCatch({
    configr::write.config(
      config.dat = config_data,
      file.path = path,
      write.type = "yaml",
      indent = 4
    )
    message("Configuration written successfully to: ", path)
    invisible(TRUE)
  }, error = function(e) {
    stop(
      "Failed to write configuration file '", path, "': ",
      e$message,
      call. = FALSE
    )
  })
}
