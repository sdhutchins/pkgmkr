library(testthat)

# Test successful package creation
test_that("mk_pkg creates a new package with the expected properties", {
  skip_on_cran()
  
  # Create temporary directory for testing
  tmp_dir <- withr::local_tempdir()
  pkg_path <- file.path(tmp_dir, "testpkg")
  
  # Call mk_pkg with minimal options (no git, no pkgdown to speed up test)
  result <- mk_pkg(
    path = pkg_path,
    author = "Jane Doe",
    email = "jane@example.com",
    git = FALSE,
    readme_md = TRUE,
    check_pkg_name = FALSE,  # Skip CRAN check for speed
    license = "MIT",
    pkgdown = FALSE
  )
  
  # Check return value
  expect_type(result, "list")
  expect_equal(result$package_name, "testpkg")
  expect_true(result$success)
  
  # Check that the package directory was created
  expect_true(dir.exists(pkg_path))
  
  # Check that essential files exist
  expect_true(file.exists(file.path(pkg_path, "DESCRIPTION")))
  expect_true(file.exists(file.path(pkg_path, "README.md")))
  expect_true(file.exists(file.path(pkg_path, "LICENSE")))
  expect_true(file.exists(file.path(pkg_path, "LICENSE.md")))
  expect_true(file.exists(file.path(pkg_path, "NAMESPACE")))
  
  # Check R/ directory exists
  expect_true(dir.exists(file.path(pkg_path, "R")))
})

# Test GPL-3 license
test_that("mk_pkg creates package with GPL-3 license", {
  skip_on_cran()
  
  tmp_dir <- withr::local_tempdir()
  pkg_path <- file.path(tmp_dir, "testgpl")
  
  result <- mk_pkg(
    path = pkg_path,
    author = "John Smith",
    email = "john@example.com",
    git = FALSE,
    readme_md = FALSE,
    check_pkg_name = FALSE,
    license = "GPL-3",
    pkgdown = FALSE
  )
  
  expect_true(result$success)
  expect_true(file.exists(file.path(pkg_path, "LICENSE.md")))
})

# Test author name parsing with multiple last names
test_that("mk_pkg handles author names with multiple parts", {
  skip_on_cran()
  
  tmp_dir <- withr::local_tempdir()
  pkg_path <- file.path(tmp_dir, "testmulti")
  
  result <- mk_pkg(
    path = pkg_path,
    author = "Mary Jane Smith Wilson",
    email = "mary@example.com",
    git = FALSE,
    readme_md = FALSE,
    check_pkg_name = FALSE,
    license = "MIT",
    pkgdown = FALSE
  )
  
  expect_true(result$success)
  
  # Read DESCRIPTION and check author field
  desc_path <- file.path(pkg_path, "DESCRIPTION")
  desc_content <- readLines(desc_path)
  author_line <- grep("Authors@R:", desc_content, value = TRUE)
  
  expect_match(author_line, "Mary")
  expect_match(author_line, "Jane Smith Wilson")
})

# Test input validation - empty path
test_that("mk_pkg validates path input", {
  expect_error(
    mk_pkg(
      path = "",
      author = "Test Author",
      email = "test@example.com"
    ),
    "path.*cannot be empty"
  )
  
  expect_error(
    mk_pkg(
      path = NULL,
      author = "Test Author",
      email = "test@example.com"
    ),
    "path.*provided"
  )
})

# Test input validation - empty author
test_that("mk_pkg validates author input", {
  expect_error(
    mk_pkg(
      path = "testpkg",
      author = "",
      email = "test@example.com"
    ),
    "author.*cannot be empty"
  )
  
  expect_error(
    mk_pkg(
      path = "testpkg",
      author = "SingleName",
      email = "test@example.com"
    ),
    "at least.*first and last name"
  )
})

# Test input validation - invalid email
test_that("mk_pkg validates email format", {
  expect_error(
    mk_pkg(
      path = "testpkg",
      author = "Test Author",
      email = "not-an-email"
    ),
    "valid email address"
  )
  
  expect_error(
    mk_pkg(
      path = "testpkg",
      author = "Test Author",
      email = "@example.com"
    ),
    "valid email address"
  )
  
  expect_error(
    mk_pkg(
      path = "testpkg",
      author = "Test Author",
      email = ""
    ),
    "email.*cannot be empty"
  )
})

# Test input validation - invalid package name
test_that("mk_pkg validates package name format", {
  tmp_dir <- withr::local_tempdir()
  
  expect_error(
    mk_pkg(
      path = file.path(tmp_dir, "123invalid"),
      author = "Test Author",
      email = "test@example.com"
    ),
    "Invalid package name"
  )
  
  expect_error(
    mk_pkg(
      path = file.path(tmp_dir, "invalid-name"),
      author = "Test Author",
      email = "test@example.com"
    ),
    "Invalid package name"
  )
})

# Test input validation - invalid license
test_that("mk_pkg validates license parameter", {
  tmp_dir <- withr::local_tempdir()
  
  expect_error(
    mk_pkg(
      path = file.path(tmp_dir, "testpkg"),
      author = "Test Author",
      email = "test@example.com",
      license = "Apache-2.0"
    ),
    "license.*must be one of"
  )
})

# Test error when directory already exists
test_that("mk_pkg fails if directory already exists", {
  tmp_dir <- withr::local_tempdir()
  pkg_path <- file.path(tmp_dir, "existingpkg")
  
  # Create the directory first
  dir.create(pkg_path)
  
  expect_error(
    mk_pkg(
      path = pkg_path,
      author = "Test Author",
      email = "test@example.com"
    ),
    "already exists"
  )
})
