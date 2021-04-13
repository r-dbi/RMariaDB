context("queries")

# Can't test this in a generic fashion
test_that("setting parameter query is always complete", {
  conn <- mariadbDefault()
  rs <- dbSendStatement(conn, 'SET time_zone = "+00:00"')

  expect_true(dbHasCompleted(rs))

  dbClearResult(rs)
  dbDisconnect(conn)
})

# Maybe also relevant for other backends? move to DBItest?
test_that("prepared statements and SHOW queries", {
  conn <- mariadbDefault()
  rs <- dbGetQuery(conn, "SHOW PLUGINS")

  expect_gte(nrow(rs), 1L)

  dbDisconnect(conn)
})

test_that("fractional seconds in datetime (#170)", {
  con <- mariadbDefault()

  dataframe <- data.frame(DateTime = Sys.time())

  dbWriteTable(
    con,
    "my_table",
    dataframe,
    overwrite = TRUE,
    temporary = TRUE,
    field.types = c(DateTime="datetime(6)"),
    row.names = FALSE
  )

  out <- dbReadTable(con, "my_table")
  expect_equal(round(as.numeric(out$DateTime) * 1e6), round(as.numeric(dataframe$DateTime) * 1e6))

  out <- dbGetQuery(con, "SELECT ADDTIME(NOW(), 0.5) AS DateTime")
  seconds <- as.numeric(out$DateTime)
  expect_equal(seconds - floor(seconds), 0.5)

  dbDisconnect(con)
})

test_that("timezone argument (#184)", {
  skip_on_cran()

  conn <- mariadb_default(timezone = "+02:00")
  tz <- dbGetQuery(conn, "SELECT @@session.time_zone")
  expect_equal(tz[[1]], "+02:00")
  dbDisconnect(conn)
})

test_that("bit(1) fields support NA values (#201)", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  dbWriteTable(con, "testbit1",
    data.frame(a = c(NA_integer_, 0:1), b = c(1, 2, 3)),
    field.types = c(a = "BIT(1)"), overwrite = TRUE
  )
  result <- dbGetQuery(con, "SELECT a FROM testbit1 ORDER BY b")$a
  expect_equal(result, c(NA, FALSE, TRUE))
})
