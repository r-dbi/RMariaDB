test_that("dbDataType() maps integer64 columns in data frames to BIGINT", {
  types <- dbDataType(
    RMariaDB::MariaDB(),
    data.frame(
      id = bit64::as.integer64(1L),
      stringsAsFactors = FALSE
    )
  )

  expect_equal(types, c(id = "BIGINT"))
})
