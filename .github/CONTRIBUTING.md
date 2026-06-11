# Contributing

Thank you for your interest in contributing to pkgmkr. This guide describes the
expected workflow for reporting issues and submitting changes to this R package.

## Reporting Bugs

Before opening an issue, please check whether the behavior is already documented
or reported in the issue tracker. A useful bug report should include:

- Your operating system and R version, from `sessionInfo()`.
- The installed pkgmkr version.
- The smallest reproducible example that triggers the problem.
- The full error, warning, or unexpected output.
- Any relevant package-development context, such as whether you were working in
  RStudio, a temporary directory, or an existing package project.

Small reproducible examples are especially valuable because pkgmkr creates
package structures on disk. Please use `tempdir()` or another disposable path
when possible.

## Development Setup

Clone the repository, then install the package dependencies from R:

```r
install.packages(c(
  "available",
  "configr",
  "desc",
  "fs",
  "pkgdown",
  "roxygen2",
  "testthat",
  "usethis",
  "withr"
))
```

Install the local package in development mode with:

```r
pak::pak(".")
```

If `pak` is not available, `devtools::install()` is also fine.

## Making Changes

Please keep changes focused. A pull request that fixes one behavior, updates the
matching tests, and refreshes the relevant documentation is easier to review than
one that mixes unrelated cleanup with functional changes.

For exported functions:

- Update roxygen comments in `R/`.
- Run `roxygen2::roxygenise()` to refresh `NAMESPACE` and files in `man/`.
- Add or update examples when they can run safely in a temporary directory.
- Add focused tests under `tests/testthat/`.

When changing behavior that creates files or directories, prefer tests that use
`withr::local_tempdir()`. This keeps checks isolated and avoids leaving package
artifacts in a contributor's working directory.

## Checking

Before submitting a pull request, run:

```r
devtools::test()
devtools::check()
```

The package should pass `R CMD check` without errors, warnings, or unexpected
notes. If a note is unavoidable, describe why in the pull request.

## Documentation

Documentation changes should be made in the source files where possible:

- Function documentation belongs in roxygen comments under `R/`.
- Package articles belong under `vignettes/` or the pkgdown article directory
  already used by the project.
- User-facing changes should be reflected in `README.md` when appropriate.
- Release-facing changes should be noted in `NEWS.md`.

## Pull Requests

Open a pull request from a topic branch and include:

- A short summary of the change.
- The issue number, if the pull request fixes an existing issue.
- The checks you ran.
- Any intentional limitations or follow-up work.

By contributing, you agree that your contributions will be licensed under the
same license as pkgmkr.
