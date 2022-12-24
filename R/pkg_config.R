#' @title Package Config
#'
#' @description Import configuration data from a file.
#'
#' @param path character. The path to the configuration file.
#' @param file_type character. The file type of the configuration file (either "yaml" or "json").
#' @importFrom configr read.config
#' @importFrom available available
#' @return A list containing the configuration data.
#' @export
import_config <- function(path, file_type = "yaml") {
  # Use the configr::read.config function to read the configuration data from the file
  config_data <- configr::read.config(file = path, file.type = file_type)

  return(config_data)
}

#' @title Write Config
#'
#' @description Write configuration data to a file.
#'
#' @param path character. The path to write the configuration file to.
#' @param config_data list. The configuration data to write to the file.
#' @importFrom configr write.config
#' @importFrom available available
#' @return NULL
#' @export
write_config <- function(path, config_data) {
  # Use the configr::write.config function to write the configuration data to the file
  configr::write.config(config.dat = config_data, file.path = path, write.type = "yaml", indent = 4)
}
