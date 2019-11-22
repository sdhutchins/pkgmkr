## usethis policy re: preparation of user-provided path to a resource on user's
## file system
user_path_prep <- function(path) {
    ## usethis uses fs's notion of home directory
    ## this ensures we are consistent about that
    fs::path_expand(path)
}
