
# pkgmkr

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/sdhutchins/pkgmkr.svg?branch=master)](https://travis-ci.org/sdhutchins/pkgmkr)
<!-- badges: end -->

The goal of pkgmkr is to create an R package with one simple function.


## Installation

In the future,you will be able to install the released version of pkgmkr from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("pkgmkr")
```

Currently, `pkgmkr` can only be installed using devtools.

```r
install.packages("devtools")
```


## Example

This is a basic example of using this package.

``` r
library(pkgmkr)

au <- "Shaurita Hutchins"
email <- "sdh@gmail.com"

mk_pkg(pkg_name = "gghmm", author = au, email = email, git = FALSE, git_username, git_email, readme_md = TRUE, check_pkg_name = TRUE, license = "MIT", pkgdown = "TRUE")
```

