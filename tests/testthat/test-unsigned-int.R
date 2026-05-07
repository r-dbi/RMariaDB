test_that("unsigned_int defaults to integer64 and preserves values above 2^31", {
  skip_if_not(mariadbHasDefault())
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t_uint (x INT UNSIGNED)")
  dbExecute(con, "INSERT INTO t_uint VALUES (0), (1), (2147483647), (2147483648), (4294967295), (NULL)")

  out <- dbGetQuery(con, "SELECT x FROM t_uint ORDER BY x IS NULL DESC, x")

  expect_s3_class(out$x, "integer64")
  expect_equal(
    as.character(out$x),
    c(NA, "0", "1", "2147483647", "2147483648", "4294967295")
  )
})
