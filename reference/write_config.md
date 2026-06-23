# Write Package Configuration

Write package configuration data to a YAML file for later use with
[`mk_pkg_from_config`](https://shauritahutchins.com/pkgmkr/reference/mk_pkg_from_config.md).

## Usage

``` r
write_config(path, config_data)
```

## Arguments

- path:

  character. Path where the configuration file will be written. Parent
  directories will be created if they don't exist.

- config_data:

  list. The configuration data to write. Must be a named list containing
  package configuration parameters.

## Value

Invisibly returns TRUE on success.

## Details

This function creates a YAML configuration file that can be used to
create packages with consistent settings. If the parent directory
doesn't exist, it will be created automatically.

## See also

[`import_config`](https://shauritahutchins.com/pkgmkr/reference/import_config.md),
[`mk_pkg_from_config`](https://shauritahutchins.com/pkgmkr/reference/mk_pkg_from_config.md)

## Examples

``` r
# Create a configuration and write it to a temp file
config <- list(
  pkg_name = "mypackage",
  first_name = "Jane",
  last_name = "Doe",
  email = "jane@example.com",
  readme_md = TRUE,
  git = FALSE,
  license = "MIT"
)
config_path <- tempfile(fileext = ".yml")
write_config(config_path, config)
#> Configuration written successfully to: /tmp/RtmpwnvMdm/file1a213ba08d99.yml

# Verify the file was created
import_config(config_path, "yaml")
#> $pkg_name
#> [1] "mypackage"
#> 
#> $first_name
#> [1] "Jane"
#> 
#> $last_name
#> [1] "Doe"
#> 
#> $email
#> [1] "jane@example.com"
#> 
#> $readme_md
#> [1] TRUE
#> 
#> $git
#> [1] FALSE
#> 
#> $license
#> [1] "MIT"
#> 
unlink(config_path)
```
