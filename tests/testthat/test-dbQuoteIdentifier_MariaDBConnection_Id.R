test_that("dbQuoteIdentifier() and def", {
  skip_if_not(mariadbHasDefault())

  conn <- withr::local_db_connection(mariadbDefault())

  expect_equal(dbQuoteIdentifier(conn, Id("def", "a", "b")), SQL("`a`.`b`"))
  expect_equal(dbQuoteIdentifier(conn, Id("a", "b")), SQL("`a`.`b`"))
  expect_equal(dbQuoteIdentifier(conn, Id("def", "a")), SQL("`def`.`a`"))
})
