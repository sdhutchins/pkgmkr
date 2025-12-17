library(testthat)

# Test import_config function
test_that("import_config reads valid YAML config file", {
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "test_config.yaml")
  
  # Create a simple config file
  config_content <- "
pkg_name: testpkg
first_name: John
last_name: Doe
email: john@example.com
license: MIT
"
  writeLines(config_content, config_path)
  
  # Import the config
  config_data <- import_config(config_path, "yaml")
  
  expect_type(config_data, "list")
  expect_equal(config_data$pkg_name, "testpkg")
  expect_equal(config_data$first_name, "John")
  expect_equal(config_data$last_name, "Doe")
})

# Test import_config with non-existent file
test_that("import_config fails with non-existent file", {
  expect_error(
    import_config("/path/that/does/not/exist.yaml", "yaml"),
    "not found"
  )
})

# Test import_config with invalid file type
test_that("import_config validates file_type parameter", {
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "test_config.yaml")
  writeLines("pkg_name: test", config_path)
  
  expect_error(
    import_config(config_path, "xml"),
    "must be either 'yaml' or 'json'"
  )
})

# Test import_config with empty path
test_that("import_config validates path parameter", {
  expect_error(
    import_config("", "yaml"),
    "path.*cannot be empty"
  )
  
  expect_error(
    import_config(NULL, "yaml"),
    "path.*provided"
  )
})

# Test write_config function
test_that("write_config creates valid YAML config file", {
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "output_config.yaml")
  
  config_data <- list(
    pkg_name = "mypkg",
    first_name = "Jane",
    last_name = "Smith",
    email = "jane@example.com",
    license = "GPL-3"
  )
  
  result <- write_config(config_path, config_data)
  
  expect_true(result)
  expect_true(file.exists(config_path))
  
  # Verify we can read it back
  read_back <- import_config(config_path, "yaml")
  expect_equal(read_back$pkg_name, "mypkg")
  expect_equal(read_back$first_name, "Jane")
})

# Test write_config creates directories if needed
test_that("write_config creates parent directories", {
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "nested", "dir", "config.yaml")
  
  config_data <- list(pkg_name = "test")
  
  result <- write_config(config_path, config_data)
  
  expect_true(result)
  expect_true(file.exists(config_path))
})

# Test write_config validation
test_that("write_config validates inputs", {
  expect_error(
    write_config("", list(pkg_name = "test")),
    "path.*cannot be empty"
  )
  
  expect_error(
    write_config("/tmp/test.yaml", NULL),
    "config_data.*cannot be NULL"
  )
  
  expect_error(
    write_config("/tmp/test.yaml", "not a list"),
    "config_data.*must be a list"
  )
})

# Test mk_pkg_from_config
test_that("mk_pkg_from_config creates package from valid config", {
  skip_on_cran()
  
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "pkg_config.yaml")
  
  # Create config file
  config_content <- "
pkg_name: configpkg
first_name: Alice
last_name: Johnson
email: alice@example.com
readme_md: true
git: false
check_pkg_name: false
license: MIT
pkgdown: false
"
  writeLines(config_content, config_path)
  
  # Change to temp dir so package is created there
  withr::local_dir(tmp_dir)
  
  result <- mk_pkg_from_config(config_path, "yaml")
  
  expect_true(result$success)
  expect_equal(result$package_name, "configpkg")
  expect_true(dir.exists(file.path(tmp_dir, "configpkg")))
})

# Test mk_pkg_from_config with missing required fields
test_that("mk_pkg_from_config validates required config fields", {
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "incomplete_config.yaml")
  
  # Config missing last_name
  config_content <- "
pkg_name: testpkg
first_name: Bob
"
  writeLines(config_content, config_path)
  
  expect_error(
    mk_pkg_from_config(config_path, "yaml"),
    "missing required field"
  )
})

# Test mk_pkg_from_config with non-existent file
test_that("mk_pkg_from_config fails with non-existent file", {
  expect_error(
    mk_pkg_from_config("/path/that/does/not/exist.yaml", "yaml"),
    "not found"
  )
})

# Test mk_pkg_from_config with defaults
test_that("mk_pkg_from_config uses defaults for optional fields", {
  skip_on_cran()
  
  tmp_dir <- withr::local_tempdir()
  config_path <- file.path(tmp_dir, "minimal_config.yaml")
  
  # Minimal config with only required fields
  config_content <- "
pkg_name: minimalpkg
first_name: Charlie
last_name: Brown
"
  writeLines(config_content, config_path)
  
  withr::local_dir(tmp_dir)
  
  # Should use defaults: readme_md=TRUE, git=FALSE, license=MIT, etc.
  result <- mk_pkg_from_config(config_path, "yaml")
  
  expect_true(result$success)
  
  # Check that README was created (default readme_md=TRUE)
  expect_true(file.exists(file.path(tmp_dir, "minimalpkg", "README.md")))
})
