#' @title Package Config
#'
#' @description FUNCTION_DESCRIPTION
#'
#' @param path DESCRIPTION.
#' @param file_type DESCRIPTION.
#' @importFrom configr read.config
#' @importFrom available available
import_config <- function(file = NULL, file_type = "yaml") {
    if (is.null(file)){
    cfg <- configr::read.config(file = 'extdata/template.yaml', file.type = file_type)
    }
}

#' @title Write Config
#'
#' @description Write configuration data to a file.
#'
#' @param path DESCRIPTION.
#' @param config_data DESCRIPTION.
#' @importFrom configr write.config
#' @importFrom available available
write_config <- function(path, config_data) {
    configr::write.config(config.dat = config_data, file.path = path, write.type = "yaml", indent = 4)
}
