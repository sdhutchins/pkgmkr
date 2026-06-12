# Import Package Configuration

Import package configuration data from a YAML or JSON file.

## Usage

``` r
import_config(path, file_type = "yaml")
```

## Arguments

- path:

  character. Path to the configuration file. Must be a valid file path
  to an existing file.

- file_type:

  character. The file type - must be either "yaml" or "json". Default:
  "yaml".

## Value

A list containing the configuration data from the file.

## Details

This function reads and validates a configuration file. The file must
exist and contain valid YAML or JSON. If the file is malformed, a
helpful error message will indicate the parsing issue.

## See also

[`write_config`](https://shauritahutchins.com/pkgmkr/reference/write_config.md),
[`mk_pkg_from_config`](https://shauritahutchins.com/pkgmkr/reference/mk_pkg_from_config.md)

## Examples

``` r
# Write a temporary YAML config, then import it
config_path <- tempfile(fileext = ".yml")
writeLines("pkg_name: demopkg\nfirst_name: Jane\nlast_name: Doe", config_path)
config <- import_config(config_path, "yaml")
print(config$pkg_name)
#> [1] "demopkg"
unlink(config_path)
```
