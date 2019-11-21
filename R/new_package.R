#' @title Make Package
#' @param melted_df A "melted" dataframe from the metacoder object's data.
#' @param tax_level The taxonomic level, Default: 'Phylum'
#' @importFrom usethis
#' @importFrom available available
mk_package <- function(path, name, readme_md=TRUE, git=TRUE, check_pkg_name=TRUE, travisci=TRUE, license="mit") {
    usethis::create_package(path=path)
    if (isTRUE(check_pkg_name)) {
        available::available(name=path, browse = FALSE)
    }
    if (isTRUE(readme_md)) {
        usethis::use_readme_md()
    }
    if (isTRUE(git)) {
        usethis::use_git()
    }
    if (license == "mit") {
        usethis::use_mit_license(name=name)
    }
    if (isTRUE(travisci)) {
        usethis::use_travis()
    }

}
