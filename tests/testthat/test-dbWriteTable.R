# test_that("can't override existing table with default options", {
#   con <- mariadbDefault()
#
#   x <- data.frame(col1 = 1:10, col2 = letters[1:10])
#   dbWriteTable(con, "t1", x, temporary = TRUE)
#   expect_error(dbWriteTable(con, "t1", x), "exists in database")
#   dbDisconnect(con)
# })

# Not generic enough for DBItest
test_that("dbWriteTable() throws error if constraint violated", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  x <- data.frame(col1 = 1:10, col2 = letters[1:10])

  dbWriteTable(con, "t1", x[1:3, ], overwrite = TRUE)
  dbExecute(con, "CREATE UNIQUE INDEX t1_c1_c2_idx ON t1(col1, col2(1))")
  expect_error(dbWriteTable(con, "t1", x, append = TRUE), "added 7 rows|Duplicate entry")
})

test_that("dbAppendTable() throws error if constraint violated", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  x <- data.frame(col1 = 1:10, col2 = letters[1:10])

  dbWriteTable(con, "t1", x[1:3, ], overwrite = TRUE)
  dbExecute(con, "CREATE UNIQUE INDEX t1_c1_c2_idx ON t1(col1, col2(1))")
  expect_error(dbAppendTable(con, "t1", x), "added 7 rows|Duplicate entry")
})

test_that("dbAppendTable() works with Id", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  dbExecute(con, "CREATE TEMPORARY TABLE t1(n integer)")
  expect_equal(dbAppendTable(con, Id(table = "t1"), data.frame(n = 1:10)), 10)
})

# Available only in MariaDB
test_that("can read file from disk", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  if (dbGetQuery(con, "SHOW VARIABLES LIKE 'local_infile'")$Value == "OFF") {
    skip("local_infile is set to OFF, can't test LOAD DATA INFILE")
  }

  expected <- data.frame(
    a = c(1:3, NA),
    b = c("x", "y", "z", "E"),
    stringsAsFactors = FALSE
  )

  dbWriteTable(con, "dat", "dat-n.bin", sep = "|", eol = "\n",
    temporary = TRUE, overwrite = TRUE)
  expect_equal(dbReadTable(con, "dat"), expected)
})

test_that("converts NaN and Inf to NULL", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  x <- data.frame(col1 = c(-Inf, NA, 0, NaN, Inf))

  dbWriteTable(con, "t1", x, overwrite = TRUE, temporary = TRUE)
  expect_equal(dbReadTable(con, "t1"), data.frame(col1 = c(NA, NA, 0, NA, NA)))
})

test_that("write dates prior to 1970 (#232)", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  x <- data.frame(col1 = as.Date("1970-01-01") + 2:-2)

  dbWriteTable(con, "t1", x, overwrite = TRUE, temporary = TRUE)
  expect_equal(dbReadTable(con, "t1"), x)
})

test_that("writing and reading JSON (#127)", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  x <- data.frame(col1 = "[1,2,3]", stringsAsFactors = FALSE)

  dbWriteTable(con, "t1", x, field.types = c(col1 = "json"), overwrite = TRUE, temporary = TRUE)

  suppressWarnings(d <- dbReadTable(con, "t1"))

  # MySQL 8 returns "[1, 2, 3]", while MariaDB returns "[1,2,3]"
  d$col1 <- gsub('\\s', '', d$col1)

  expect_equal(d, x)
})
