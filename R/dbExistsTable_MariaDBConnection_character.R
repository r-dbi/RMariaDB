#' @rdname mariadb-tables
#' @usage NULL
dbExistsTable_MariaDBConnection_character <- function(conn, name, ...) {
  stopifnot(length(name) == 1L)
  if (!dbIsValid(conn)) {
    stopc("Invalid connection")
  }
  tryCatch(
    {
      dbGetQuery(conn, paste0(
        "SELECT NULL FROM ", dbQuoteIdentifier(conn, name), " WHERE FALSE"
      ))
      TRUE
    },
    error = function(...) {
      FALSE
    }
  )
}

#' @rdname mariadb-tables
#' @export
setMethod("dbExistsTable", c("MariaDBConnection", "character"), dbExistsTable_MariaDBConnection_character)
