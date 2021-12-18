#' @rdname mariadb-tables
#' @usage NULL
dbListTables_MariaDBConnection <- function(conn, ...) {
  # DATABASE(): https://stackoverflow.com/a/8096574/946850
  dbGetQuery(
    conn,
    paste0(
      "SELECT table_name FROM INFORMATION_SCHEMA.tables\n",
      "WHERE table_schema = DATABASE()"
    )
  )[[1]]
}

#' @rdname mariadb-tables
#' @export
setMethod("dbListTables", "MariaDBConnection", dbListTables_MariaDBConnection)
