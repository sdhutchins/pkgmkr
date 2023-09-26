
# pkgmkr

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/sdhutchins/pkgmkr.svg?branch=master)](https://travis-ci.org/sdhutchins/pkgmkr)
<!-- badges: end -->

`pkgmkr` aims to simplify the process of creating R packages by providing a single, straightforward function. It is designed to be user-friendly and to handle various package configurations, including optional Git integration, license selection, and more.

## Features

- Easy-to-use function for package creation
- Optional Git repository initialization
- Customizable package metadata
- License selection
- README and `pkgdown` site generation
.


## Installation

In the future,you will be able to install the released version of pkgmkr from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("pkgmkr")
```

Currently, `pkgmkr` can only be installed using devtools.

```r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install pkgmkr from GitHub
devtools::install_github("sdhutchins/pkgmkr")
```


## Example

This is a basic example of using this package.

``` r
# Load the pkgmkr library
library(pkgmkr)

# Define package metadata
au <- "Shaurita Hutchins"
email <- "sdh@gmail.com"

# Create the package
mk_pkg(
  pkg_name = "gghmm",
  author = au,
  email = email,
  git = FALSE,
  git_username = NULL,
  git_email = NULL,
  readme_md = TRUE,
  check_pkg_name = TRUE,
  license = "MIT",
  pkgdown = "TRUE"
)
```

## Contributing

Contributions are welcome! Please read the CONTRIBUTING.md for guidelines on how to contribute to this project.



