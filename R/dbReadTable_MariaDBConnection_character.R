#' @rdname mariadb-tables
#' @usage NULL
dbReadTable_MariaDBConnection_character <- function(conn, name, ..., row.names = FALSE, check.names = TRUE) {
  row.names <- compatRowNames(row.names)

  if ((!is.logical(row.names) && !is.character(row.names)) || length(row.names) != 1L) {
    stopc("`row.names` must be a logical scalar or a string")
  }

  if (!is.logical(check.names) || length(check.names) != 1L) {
    stopc("`check.names` must be a logical scalar")
  }

  name <- dbQuoteIdentifier(conn, name)
  out <- dbGetQuery(conn, paste("SELECT * FROM ", name),
    row.names = row.names
  )

  if (check.names) {
    names(out) <- make.names(names(out), unique = TRUE)
  }

  out
}

#' @rdname mariadb-tables
#' @export
setMethod("dbReadTable", c("MariaDBConnection", "character"), dbReadTable_MariaDBConnection_character)
