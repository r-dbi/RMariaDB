#' @rdname mariadb-tables
#' @param fail_if_missing If `FALSE`, `dbRemoveTable()` succeeds if the
#'   table doesn't exist.
#' @usage NULL
dbRemoveTable_MariaDBConnection_character <- function(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE) {
  extra <- list(...)

  name <- dbQuoteIdentifier(conn, name)
  dbExecute(
    conn,
    paste0(
      "DROP ",
      if (temporary) "TEMPORARY ",
      "TABLE ",
      if (!fail_if_missing) "IF EXISTS ",
      name
    )
  )
  invisible(TRUE)
}

#' @rdname mariadb-tables
#' @export
setMethod("dbRemoveTable", c("MariaDBConnection", "character"), dbRemoveTable_MariaDBConnection_character)
