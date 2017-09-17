#' @include MariaDBConnection.R
NULL

#' DBMS Transaction Management
#'
#' Commits or roll backs the current transaction in an MariaDB connection.
#' Note that in MariaDB DDL statements (e.g. \code{CREATE TABLE}) can not
#' be rolled back.
#'
#' @param conn a \code{MariaDBConnection} object, as produced by
#'  \code{\link{dbConnect}}.
#' @param ... Unused.
#' @examples
#' if (mariadbHasDefault()) {
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#' df <- data.frame(id = 1:5)
#'
#' dbWriteTable(con, "df", df)
#' dbBegin(con)
#' dbExecute(con, "UPDATE df SET id = id * 10")
#' dbGetQuery(con, "SELECT id FROM df")
#' dbRollback(con)
#'
#' dbGetQuery(con, "SELECT id FROM df")
#'
#' dbRemoveTable(con, "df")
#' dbDisconnect(con)
#' }
#' @name transactions
NULL

#' @export
#' @rdname transactions
setMethod("dbBegin", "MariaDBConnection", function(conn, ...) {
  connection_begin_transaction(conn@ptr)
  invisible(TRUE)
})

#' @export
#' @rdname transactions
setMethod("dbCommit", "MariaDBConnection", function(conn, ...) {
  connection_commit(conn@ptr)
  invisible(TRUE)
})

#' @export
#' @rdname transactions
setMethod("dbRollback", "MariaDBConnection", function(conn, ...) {
  connection_rollback(conn@ptr)
  invisible(TRUE)
})
