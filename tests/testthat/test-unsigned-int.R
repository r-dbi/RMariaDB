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

test_that("unsigned_int = 'numeric' returns doubles", {
  skip_if_not(mariadbHasDefault())
  con <- dbConnect(
    MariaDB(),
    default.file = "~/.my.cnf",
    group = "rs-dbi",
    dbname = "test",
    unsigned_int = "numeric"
  )
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t_uint_num (x INT UNSIGNED)")
  dbExecute(con, "INSERT INTO t_uint_num VALUES (0), (2147483648), (4294967295)")

  out <- dbGetQuery(con, "SELECT x FROM t_uint_num ORDER BY x")

  expect_type(out$x, "double")
  expect_false(inherits(out$x, "integer64"))
  expect_equal(out$x, c(0, 2147483648, 4294967295))
})

test_that("unsigned_int = 'integer' overflows values above 2^31 to NA", {
  skip_if_not(mariadbHasDefault())
  con <- dbConnect(
    MariaDB(),
    default.file = "~/.my.cnf",
    group = "rs-dbi",
    dbname = "test",
    unsigned_int = "integer"
  )
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t_uint_int (x INT UNSIGNED)")
  dbExecute(con, "INSERT INTO t_uint_int VALUES (0), (2147483647), (2147483648), (4294967295)")

  out <- dbGetQuery(con, "SELECT x FROM t_uint_int ORDER BY x")

  expect_type(out$x, "integer")
  expect_equal(out$x, c(0L, 2147483647L, NA_integer_, NA_integer_))
})

test_that("unsigned_int = 'character' returns string representation", {
  skip_if_not(mariadbHasDefault())
  con <- dbConnect(
    MariaDB(),
    default.file = "~/.my.cnf",
    group = "rs-dbi",
    dbname = "test",
    unsigned_int = "character"
  )
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t_uint_chr (x INT UNSIGNED)")
  dbExecute(con, "INSERT INTO t_uint_chr VALUES (0), (4294967295)")

  out <- dbGetQuery(con, "SELECT x FROM t_uint_chr ORDER BY x")

  expect_type(out$x, "character")
  expect_equal(out$x, c("0", "4294967295"))
})

test_that("bigint and unsigned_int are honored independently", {
  skip_if_not(mariadbHasDefault())
  con <- dbConnect(
    MariaDB(),
    default.file = "~/.my.cnf",
    group = "rs-dbi",
    dbname = "test",
    bigint = "integer",
    unsigned_int = "numeric"
  )
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t_mixed (big BIGINT, uns INT UNSIGNED)")
  dbExecute(con, "INSERT INTO t_mixed VALUES (100, 4294967295)")

  out <- dbGetQuery(con, "SELECT big, uns FROM t_mixed")

  expect_type(out$big, "integer")
  expect_equal(out$big, 100L)

  expect_type(out$uns, "double")
  expect_false(inherits(out$uns, "integer64"))
  expect_equal(out$uns, 4294967295)
})

test_that("signed INT is unaffected by unsigned_int setting", {
  skip_if_not(mariadbHasDefault())
  con <- dbConnect(
    MariaDB(),
    default.file = "~/.my.cnf",
    group = "rs-dbi",
    dbname = "test",
    unsigned_int = "character"
  )
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t_sint (x INT)")
  dbExecute(con, "INSERT INTO t_sint VALUES (0), (-1), (2147483647), (-2147483647)")

  out <- dbGetQuery(con, "SELECT x FROM t_sint ORDER BY x")

  expect_type(out$x, "integer")
  expect_equal(out$x, c(-.Machine$integer.max, -1L, 0L, .Machine$integer.max))
})
