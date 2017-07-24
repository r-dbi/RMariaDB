context("astyle")

test_that("source code formatting", {
  skip_on_cran()
  expect_warning(astyle("--dry-run"), NA)
})
