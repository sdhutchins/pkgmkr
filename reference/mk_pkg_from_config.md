# Make Package from Config

Create a package based on a YAML or JSON configuration file. This
provides a convenient way to store and reuse package creation settings.

## Usage

``` r
mk_pkg_from_config(config_path, file_type = "yaml")
```

## Arguments

- config_path:

  character. Path to the configuration file. File must exist.

- file_type:

  character. The file type of the configuration file. Must be either
  "yaml" or "json". Default: "yaml".

## Value

Invisibly returns a list with package information (see
[`mk_pkg`](https://shauritahutchins.com/pkgmkr/reference/mk_pkg.md)).

## Details

The configuration file must contain at minimum:

- `pkg_name`: Package name

- `first_name`: Author's first name

- `last_name`: Author's last name

Optional fields include: `email`, `readme_md`, `git`, `git_username`,
`git_email`, `check_pkg_name`, `license`, and `pkgdown`.

## See also

[`mk_pkg`](https://shauritahutchins.com/pkgmkr/reference/mk_pkg.md),
[`import_config`](https://shauritahutchins.com/pkgmkr/reference/import_config.md),
[`write_config`](https://shauritahutchins.com/pkgmkr/reference/write_config.md)

## Examples

``` r
# Create a config file
config_path <- file.path(tempdir(), "pkg_config.yml")
config <- list(
  pkg_name = "mypackage",
  first_name = "Jane",
  last_name = "Doe",
  email = "jane@example.com",
  license = "MIT",
  git = FALSE,
  check_pkg_name = FALSE,
  pkgdown = FALSE
)
write_config(config_path, config)
#> Configuration written successfully to: /tmp/RtmpZbjEDK/pkg_config.yml

# Create package from config
withr::with_dir(tempdir(), mk_pkg_from_config(config_path, file_type = "yaml"))
#> Creating package from config file: /tmp/RtmpZbjEDK/pkg_config.yml
#> Creating package structure...
#> ✔ Creating /tmp/RtmpZbjEDK/mypackage/.
#> ✔ Setting active project to "/tmp/RtmpZbjEDK/mypackage".
#> ✔ Creating R/.
#> ✔ Writing DESCRIPTION.
#> Package: mypackage
#> Title: What the Package Does (One Line, Title Case)
#> Version: 0.0.0.9000
#> Authors@R (parsed):
#>     * First Last <first.last@example.com> [aut, cre]
#> Description: What the package does (one paragraph).
#> License: `use_mit_license()`, `use_gpl3_license()` or friends to
#>     pick a license
#> Encoding: UTF-8
#> Roxygen: list(markdown = TRUE)
#> RoxygenNote: 7.0.0
#> ✔ Writing NAMESPACE.
#> ✔ Writing mypackage.Rproj.
#> ✔ Adding "^mypackage\\.Rproj$" to .Rbuildignore.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> ✔ Adding "^\\.Rproj\\.user$" to .Rbuildignore.
#> ✔ Setting active project to "/home/runner/work/pkgmkr/pkgmkr".
#> ✔ Setting active project to "/tmp/RtmpZbjEDK/mypackage".
#> Setting up DESCRIPTION file...
#> Creating README.md...
#> ✔ Setting active project to "/tmp/RtmpZbjEDK/mypackage".
#> ✔ Writing README.md.
#> ☐ Update README.md to include installation instructions.
#> ✔ Setting active project to "/tmp/RtmpZbjEDK/mypackage".
#> Setting up MIT license...
#> ✔ Adding "MIT + file LICENSE" to License.
#> ✔ Writing LICENSE.
#> ✔ Writing LICENSE.md.
#> ✔ Adding "^LICENSE\\.md$" to .Rbuildignore.
#> 
#> ============================================================
#> SUCCESS! Package 'mypackage' created at:
#> /tmp/RtmpZbjEDK/mypackage
#> ============================================================
#> ✔ Setting active project to "/home/runner/work/pkgmkr/pkgmkr".
unlink(file.path(tempdir(), "mypackage"), recursive = TRUE)
unlink(config_path)
```
