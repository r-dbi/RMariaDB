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
