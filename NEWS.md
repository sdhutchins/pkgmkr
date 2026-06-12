# pkgmkr 0.2.0

Maintenance release focused on package infrastructure, documentation, and site
publishing.

## Infrastructure and Release Prep

- Added GitHub Actions workflows for `R CMD check` and pkgdown deployment.
- Moved the contributor guide to `.github/CONTRIBUTING.md` so GitHub can use it
  directly while keeping it out of built package contents.
- Ignored assistant-specific local metadata and removed an unused local
  `air.toml` file from the repository.

## Documentation and Website

- Refreshed the pkgdown brand configuration and removed the older custom SCSS
  override in favor of the new brand-driven theme setup.
- Rewrote the getting-started article to better explain the one-call and
  config-file workflows.
- Rebuilt the pkgdown site to publish the updated article, contributing guide,
  and changelog pages.

# pkgmkr 0.1.0

Initial release of `pkgmkr`.

## New Features

- Added `mk_pkg()` to create an R package from a single function call, including
  package structure, metadata, licensing, README creation, optional Git setup,
  and optional pkgdown setup.
- Added support for MIT and GPL-3 license setup.
- Added optional package-name availability checks through the `available`
  package.
- Added `mk_pkg_from_config()` for creating packages from YAML or JSON
  configuration files.
- Added `import_config()` and `write_config()` helpers for reading and writing
  reusable package-creation configuration files.
- Added optional author email handling for generated package metadata.

## Validation and Reliability

- Added input validation for package names, author names, email addresses,
  license choices, configuration files, and existing output directories.
- Improved error handling around package creation steps so optional setup
  failures produce warnings where possible.
- Added tests for package creation, configuration import/export, validation
  failures, licensing, and author-name parsing.

## Documentation and Website

- Expanded README examples and package documentation.
- Added roxygen documentation and regenerated manual pages for exported
  functions.
- Added a pkgdown site configuration, article, and theme overrides.
- Updated package metadata in `DESCRIPTION`, `NAMESPACE`, and related
  development files.
