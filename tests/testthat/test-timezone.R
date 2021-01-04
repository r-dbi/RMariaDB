skip_on_cran()

test_that("timestamp without time zone is returned correctly for TZ set (#190)", {
  withr::local_timezone("America/Chicago")

  query <- "SELECT CAST('2018-01-01 12:30:00' AS DATETIME) AS a, @@SESSION.time_zone AS b"

  db <- mariadb_default(timezone = NULL)
  res <- dbGetQuery(db, query)
  expect_equal(res[[1]], as.POSIXct("2018-01-01 12:30:00", tz = res[[2]]))
  dbDisconnect(db)

  db <- mariadb_default(timezone = "UTC")
  expect_equal(
    dbGetQuery(db, query)[[1]],
    as.POSIXct("2018-01-01 12:30:00", tz = "UTC")
  )
  dbDisconnect(db)

  db <- mariadb_default(timezone = "America/Chicago")
  expect_equal(
    dbGetQuery(db, query)[[1]],
    as.POSIXct("2018-01-01 12:30:00", tz = "America/Chicago")
  )
  dbDisconnect(db)

  db <- mariadb_default(timezone = "America/New_York")
  expect_equal(
    dbGetQuery(db, query)[[1]],
    as.POSIXct("2018-01-01 12:30:00", tz = "America/New_York")
  )
  dbDisconnect(db)

  db <- mariadb_default(timezone = "Europe/London")
  expect_equal(
    dbGetQuery(db, query)[[1]],
    as.POSIXct("2018-01-01 12:30:00", tz = "Europe/London")
  )
  dbDisconnect(db)

  db <- mariadb_default(timezone = "Europe/Zurich")
  expect_equal(
    dbGetQuery(db, query)[[1]],
    as.POSIXct("2018-01-01 12:30:00", tz = "Europe/Zurich")
  )
  dbDisconnect(db)
})

test_that("timestamp with time zone is returned correctly (#205)", {
  con <- mariadb_default()
  on.exit(dbDisconnect(con))

  withr::local_timezone("America/New_York")

  con <- mariadb_default(timezone = "America/Chicago")

  query <- "CREATE TEMPORARY TABLE junk AS
            (SELECT CAST('2020-05-04' AS DATETIME) AS ts)"
  res <- dbExecute(con, query)

  res <- dbGetQuery(con, "SELECT * FROM junk")
  expect_equal(res[[1]], as.POSIXct("2020-05-04", tz = "America/Chicago"))
})

test_that("timestamp without time zone is returned correctly (#221)", {
  con <- mariadb_default()
  on.exit(dbDisconnect(con))

  out <- dbGetQuery(con, "SELECT CAST('1960-01-01 12:00:00' AS DATETIME) AS before_epoch")
  expect_equal(as.Date(out[[1]]), as.Date("1960-01-01"))
})

test_that("timezone is passed on to the connection (#229)", {
  my_tz <- "US/Alaska"

  con <- mariadb_default(timezone = my_tz)
  on.exit(dbDisconnect(con))

  example <- data.frame(val = 0:71)
  example$ts <-
    lubridate::ymd_hms("2019-04-30 00:00:00", tz = my_tz) +
    lubridate::hours(example$val)

  dbWriteTable(
    con, "example", example, temporary = TRUE,
    overwrite = TRUE, append = FALSE
  )
  res <- dbReadTable(con, "example")
  expect_equal(res, example)

  query <- '
    SELECT date(ts) AS dte, MIN(val) AS min_val, MAX(val) AS max_val
    FROM example
    GROUP BY dte
    ORDER BY dte'
  expected <- data.frame(
    dte = as.Date("2019-04-30") + 0:2,
    min_val = 0:2 * 24,
    max_val = 0:2 * 24 + 23
  )

  res <- dbGetQuery(con, query)
  expect_equal(res, expected)
})

test_that("warning if time zone not interpretable", {
  skip_on_cran()

  expect_warning(con <- mariadb_default(timezone = "+01:00"))
  dbDisconnect(con)
  expect_warning(con <- mariadb_default(timezone_out = "+01:00"))
  dbDisconnect(con)
})
