
# pkgmkr

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/sdhutchins/pkgmkr.svg?branch=master)](https://travis-ci.org/sdhutchins/pkgmkr)
<!-- badges: end -->

`pkgmkr` aims to simplify the process of creating R packages by providing a single, straightforward function. It is designed to be user-friendly and to handle various package configurations, including optional Git integration, license selection, and more.

## Features

- Easy-to-use function for package creation
- Optional Git repository initialization
- Customizable package metadata
- License selection (MIT or GPL-3)
- README and `pkgdown` site generation
- Configuration file support (YAML/JSON)
- Comprehensive input validation and error handling


## Installation

In the future, you will be able to install the released version of pkgmkr from [CRAN](https://CRAN.R-project.org) with:

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


## Usage

### Basic Example

Create a new R package with essential features:

``` r
library(pkgmkr)

# Create a simple package
mk_pkg(
  path = "mypackage",
  author = "Jane Doe",
  email = "jane.doe@example.com",
  git = FALSE,
  readme_md = TRUE,
  check_pkg_name = TRUE,
  license = "MIT",
  pkgdown = FALSE
)
```

### Full Example with Git and GitHub

Create a package with Git repository and GitHub integration:

``` r
library(pkgmkr)

mk_pkg(
  path = "~/projects/myawesomepackage",
  author = "John Smith",
  email = "john.smith@example.com",
  git = TRUE,
  git_username = "johnsmith",
  git_email = "john.smith@example.com",
  readme_md = TRUE,
  check_pkg_name = TRUE,
  license = "GPL-3",
  pkgdown = TRUE
)
```

### Using a Configuration File

You can also create packages from a YAML or JSON configuration file:

``` r
library(pkgmkr)

# Create a configuration file
config <- list(
  pkg_name = "mypackage",
  first_name = "Jane",
  last_name = "Doe",
  email = "jane.doe@example.com",
  readme_md = TRUE,
  git = FALSE,
  check_pkg_name = TRUE,
  license = "MIT",
  pkgdown = FALSE
)

# Write the configuration
write_config("my_package_config.yaml", config)

# Create package from configuration
mk_pkg_from_config("my_package_config.yaml", file_type = "yaml")
```

## Parameters

- `path`: Path where the package will be created (can be just a package name or full path) **[required]**
- `author`: Full name of the package author (e.g., "Jane Doe") **[required]**
- `email`: Email address of the author **[optional]** - if not provided, DESCRIPTION will not include maintainer email
- `git`: Logical; whether to initialize a Git repository (default: `TRUE`)
- `git_username`: Git username for repository configuration
- `git_email`: Git email for repository configuration
- `readme_md`: Logical; whether to create a README.md file (default: `TRUE`)
- `check_pkg_name`: Logical; whether to check package name availability on CRAN (default: `TRUE`)
- `license`: License type - either "MIT" or "GPL-3" (default: "MIT")
- `pkgdown`: Logical; whether to set up and build pkgdown documentation site (default: `TRUE`)

## Input Validation

`pkgmkr` includes comprehensive input validation to help you avoid common mistakes:

- Package names must start with a letter and contain only letters, numbers, and dots
- Email addresses must be properly formatted
- Author names must include at least a first and last name
- The package directory must not already exist
- License must be either "MIT" or "GPL-3"

All validation errors provide clear, helpful messages to guide you in fixing the issue.

## Contributing

Contributions are welcome! Please read the CONTRIBUTING.md for guidelines on how to contribute to this project.
