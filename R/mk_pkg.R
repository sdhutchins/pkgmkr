#' @title Make Package
#'
#' @description FUNCTION_DESCRIPTION
#'
#' @param path DESCRIPTION.
#' @param author DESCRIPTION.
#' @param git_username DESCRIPTION.
#' @param email DESCRIPTION.
#' @param readme_md DESCRIPTION.
#' @param git DESCRIPTION.
#' @param check_pkg_name DESCRIPTION.
#' @param ci DESCRIPTION.
#' @param license DESCRIPTION.
#' @param pkgdown DESCRIPTION.
#' @import usethis
#' @importFrom available available
#' @return RETURN_DESCRIPTION
#' @export
mk_package <- function(path, author, email, git_username = NULL, git_email = NULL, readme_md = TRUE, git = TRUE, check_pkg_name=TRUE, ci="travis", license="MIT",
                       pkgdown=TRUE) {
    p <- user_path_prep(path)
    usethis::create_package(path=path, open = FALSE)
    names <- as.list(strsplit(author, split = " ")[[1]])
    usethis::use_description(fields = list(
        `Authors@R` = paste0('person("Jane", "Doe", email = "jane@example.com", role = c("aut", "cre"))')))
    setwd(p)
    if (check_pkg_name) {
        available::available(name=p, browse = FALSE)
    }

    if (readme_md) {
        usethis::use_readme_md()
    }
    if (license == "mit") {
        usethis::use_mit_license(name=name)
    }
    if (ci == "travis") {
        usethis::use_travis()
    }
    if (git) {
        usethis::use_git()
        use_git_config(scope = "project", user.name = git_username, user.email = git_email)
        usethis::use_github()
    }
    if (pkgdown) {
        usethis::use_pkgdown()
        pkgdown::build_site()
    }

}
