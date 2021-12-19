#' @name mariadb-tables
#' @details
#' When using `load_data_local_infile = TRUE` in [dbConnect()],
#' pass `safe = FALSE` to `dbAppendTable()` to avoid transactions.
#' Because `LOAD DATA INFILE` is used internally, this means that
#' rows violating primary key constraints are now silently ignored.
#' @importFrom utils write.table
#' @usage NULL
dbAppendTable_MariaDBConnection <- function(conn, name, value, ..., row.names = NULL) {
  if (!is.null(row.names)) {
    stop("Can't pass `row.names` to `dbAppendTable()`", call. = FALSE)
  }
  stopifnot(is.character(name), length(name) == 1)
  stopifnot(is.data.frame(value))

  if (!conn@load_data_local_infile) {
    return(callNextMethod())
  }

  db_append_table(conn, name, value, ..., warn_factor = TRUE, transact = TRUE)
}

#' @rdname mariadb-tables
#' @export
setMethod("dbAppendTable", "MariaDBConnection", dbAppendTable_MariaDBConnection)
