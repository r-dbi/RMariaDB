#' @include MariaDBConnection.R
NULL

#' DBMS Transaction Management
#'
#' Commits or roll backs the current transaction in an MariaDB connection.
#' Note that in MariaDB DDL statements (e.g. `CREATE TABLE`) cannot
#' be rolled back.
#'
#' @param conn a [MariaDBConnection-class] object, as produced by
#'   [DBI::dbConnect()].
#' @param ... Unused.
#' @examples
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'   df <- data.frame(id = 1:5)
#'
#'   dbWriteTable(con, "df", df, temporary = TRUE)
#'   dbBegin(con)
#'   dbExecute(con, "UPDATE df SET id = id * 10")
#'   dbGetQuery(con, "SELECT id FROM df")
#'   dbRollback(con)
#'
#'   dbGetQuery(con, "SELECT id FROM df")
#'
#'   dbDisconnect(con)
#' }
#' @name transactions
NULL
