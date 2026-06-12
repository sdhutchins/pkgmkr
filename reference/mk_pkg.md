# Make Package

Create a new R package with the specified parameters. This function
automates the process of creating an R package structure, including
DESCRIPTION file, README, license files, and optionally sets up Git,
GitHub, and pkgdown documentation.

## Usage

``` r
mk_pkg(
  path,
  author,
  email = NULL,
  git = TRUE,
  git_username = NULL,
  git_email = NULL,
  readme_md = TRUE,
  check_pkg_name = TRUE,
  license = "MIT",
  pkgdown = TRUE
)
```

## Arguments

- path:

  character. The path where the package will be created. Can be a simple
  package name (creates in current directory) or a full path. Package
  name must start with a letter and contain only letters, numbers, and
  dots.

- author:

  character. Full name of the package author (e.g., "Jane Doe"). Must
  include at least a first and last name separated by space.

- email:

  character. Email address of the author. Optional, but must be a valid
  email format if provided.

- git:

  logical. Whether to initialize a Git repository for the package.
  Default: TRUE.

- git_username:

  character. The username to use for Git configuration. Optional; only
  used if git = TRUE.

- git_email:

  character. The email to use for Git configuration. Optional; only used
  if git = TRUE.

- readme_md:

  logical. Whether to create a README.md file. Default: TRUE.

- check_pkg_name:

  logical. Whether to check that the package name is available on CRAN
  using the 'available' package. Default: TRUE.

- license:

  character. The license to use for the package. Must be either "MIT" or
  "GPL-3". Default: "MIT".

- pkgdown:

  logical. Whether to set up and build a pkgdown documentation site.
  Default: TRUE. Note: this can take some time to build.

## Value

Invisibly returns a list with three elements:

- `path`: Full path to the created package

- `package_name`: Name of the package

- `success`: TRUE if package was created successfully

## Details

The function includes comprehensive input validation to ensure:

- Package names follow R conventions (start with letter, contain only
  letters/numbers/dots)

- Email addresses are properly formatted

- Author names include at least first and last name

- The target directory doesn't already exist

If any operation fails (e.g., Git/GitHub setup), the function continues
and warns rather than failing completely, ensuring you still get a
usable package structure.

## Examples

``` r
# Create a simple package with MIT license
pkg_dir <- file.path(tempdir(), "mypackage")
mk_pkg(
  path = pkg_dir,
  author = "Jane Doe",
  email = "jane.doe@example.com",
  git = FALSE,
  check_pkg_name = FALSE,
  pkgdown = FALSE
)
#> Creating package structure...
#> ✔ Creating /tmp/RtmpwwActA/mypackage/.
#> ✔ Setting active project to "/tmp/RtmpwwActA/mypackage".
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
#> ✔ Setting active project to "<no active project>".
#> ✔ Setting active project to "/home/runner/work/pkgmkr/pkgmkr".
#> ✔ Setting active project to "/tmp/RtmpwwActA/mypackage".
#> Setting up DESCRIPTION file...
#> Creating README.md...
#> ✔ Setting active project to "/tmp/RtmpwwActA/mypackage".
#> ✔ Writing README.md.
#> ☐ Update README.md to include installation instructions.
#> ✔ Setting active project to "/tmp/RtmpwwActA/mypackage".
#> Setting up MIT license...
#> ✔ Adding "MIT + file LICENSE" to License.
#> ✔ Writing LICENSE.
#> ✔ Writing LICENSE.md.
#> ✔ Adding "^LICENSE\\.md$" to .Rbuildignore.
#> 
#> ============================================================
#> SUCCESS! Package 'mypackage' created at:
#> /tmp/RtmpwwActA/mypackage
#> ============================================================
#> ✔ Setting active project to "/home/runner/work/pkgmkr/pkgmkr".
unlink(pkg_dir, recursive = TRUE)

# Create a package with GPL-3 license
pkg_dir <- file.path(tempdir(), "analysisPkg")
mk_pkg(
  path = pkg_dir,
  author = "John Smith Wilson",
  email = "john@example.com",
  git = FALSE,
  check_pkg_name = FALSE,
  license = "GPL-3",
  pkgdown = FALSE
)
#> Creating package structure...
#> ✔ Creating /tmp/RtmpwwActA/analysisPkg/.
#> ✔ Setting active project to "/tmp/RtmpwwActA/analysisPkg".
#> ✔ Creating R/.
#> ✔ Writing DESCRIPTION.
#> Package: analysisPkg
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
#> ✔ Writing analysisPkg.Rproj.
#> ✔ Adding "^analysisPkg\\.Rproj$" to .Rbuildignore.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> ✔ Adding "^\\.Rproj\\.user$" to .Rbuildignore.
#> ✔ Setting active project to "/home/runner/work/pkgmkr/pkgmkr".
#> ✔ Setting active project to "/tmp/RtmpwwActA/analysisPkg".
#> Setting up DESCRIPTION file...
#> Creating README.md...
#> ✔ Setting active project to "/tmp/RtmpwwActA/analysisPkg".
#> ✔ Writing README.md.
#> ☐ Update README.md to include installation instructions.
#> ✔ Setting active project to "/tmp/RtmpwwActA/analysisPkg".
#> Setting up GPL-3 license...
#> ✔ Adding "GPL (>= 3)" to License.
#> ✔ Writing LICENSE.md.
#> ✔ Adding "^LICENSE\\.md$" to .Rbuildignore.
#> 
#> ============================================================
#> SUCCESS! Package 'analysisPkg' created at:
#> /tmp/RtmpwwActA/analysisPkg
#> ============================================================
#> ✔ Setting active project to "/home/runner/work/pkgmkr/pkgmkr".
unlink(pkg_dir, recursive = TRUE)
```
