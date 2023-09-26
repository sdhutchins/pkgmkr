library(testthat)

test_that("mk_pkg creates a new package with the expected properties", {
  # Set up test inputs
  setwd(fs::path_home())
  dir.create("testdir")
  setwd("testdir")
  pkg_name <- "testdirxyz"
  author <- "Jane Doe"
  email <- "jane@example.com"
  git_username <- NULL
  git_email <- NULL
  readme_md <- TRUE
  git <- FALSE
  check_pkg_name <- TRUE
  license <- "MIT"
  pkgdown <- TRUE

  # Call the mk_pkg function
  mk_pkg(pkg_name, author, email, git = FALSE, git_username, git_email, readme_md = TRUE, check_pkg_name = TRUE, license = "MIT", pkgdown = "TRUE")

  path <- getwd()
  # Check that the package was created
  expect_true(file.exists(path))

  # Check that the package has a DESCRIPTION file
  expect_true(file.exists(file.path(path, "DESCRIPTION")))

  # Check that the package has a README file
  expect_true(file.exists(file.path(path, "README.md")))

  # Check that the package does not have .gitignore file
  expect_true(file.exists(file.path(path, ".gitignore")))

  # Check that the package has a LICENSE file
  expect_true(file.exists(file.path(path, "LICENSE")))

  # Check that the package has a docs/ directory
  expect_true(file.exists(file.path(path, "docs")))

  # Check that the package has a pkgdown.yml file
  expect_true(file.exists(file.path(path, "_pkgdown.yml")))

  p <- paste0(fs::path_home(), "/testdir")
  unlink(p, recursive = TRUE)
  })
