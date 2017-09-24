context("queries")

# Can't test this in a generic fashion
test_that("setting parameter query is always complete", {
  conn <- mariadbDefault()
  rs <- dbSendStatement(conn, 'SET time_zone = "+00:00"')

  expect_true(dbHasCompleted(rs))

  dbClearResult(rs)
  dbDisconnect(conn)
})
