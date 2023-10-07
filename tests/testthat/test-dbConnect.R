test_that("Connecting with mysql = FALSE", {
  con <- mariadbForceDefault()
  on.exit(dbDisconnect(con))

  expect_s4_class(con, "MariaDBConnection")
  expect_false(is(con, "MySQLConnection"))
})

test_that("Connecting with mysql = TRUE", {
  con <- mysqlDefault()
  on.exit(dbDisconnect(con))

  expect_s4_class(con, "MariaDBConnection")
  expect_s4_class(con, "MySQLConnection")
})

test_that("Connecting with mysql unset", {
  con <- mariadbDefault()
  on.exit(dbDisconnect(con))

  expect_s4_class(con, "MariaDBConnection")
})
