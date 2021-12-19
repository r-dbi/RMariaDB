#' @inheritParams DBI::dbListObjects
#' @rdname mariadb-tables
#' @usage NULL
dbListObjects_MariaDBConnection_ANY <- function(conn, prefix = NULL, ...) {
  query <- NULL
  if (is.null(prefix)) {
    # DATABASE(): https://stackoverflow.com/a/8096574/946850
    query <- paste0(
      "SELECT NULL AS `schema`, table_name AS `table` FROM INFORMATION_SCHEMA.tables\n",
      "WHERE table_schema = DATABASE()\n",
      "UNION ALL\n",
      "SELECT DISTINCT table_schema AS `schema`, NULL AS `table` FROM INFORMATION_SCHEMA.tables"
    )
  } else {
    unquoted <- dbUnquoteIdentifier(conn, prefix)
    is_prefix <- vlapply(unquoted, function(x) {
      "schema" %in% names(x@name) && !("table" %in% names(x@name))
    })
    schemas <- vcapply(unquoted[is_prefix], function(x) x@name[["schema"]])
    if (length(schemas) > 0) {
      schema_strings <- dbQuoteString(conn, schemas)
      query <- paste0(
        "SELECT table_schema AS `schema`, table_name AS `table` FROM INFORMATION_SCHEMA.tables\n",
        "WHERE ",
        "(table_schema IN (", paste(schema_strings, collapse = ", "), "))"
      )
    }
  }

  if (is.null(query)) {
    res <- data.frame(schema = character(), table = character(), stringsAsFactors = FALSE)
  } else {
    res <- dbGetQuery(conn, query)
  }

  is_prefix <- !is.na(res$schema) & is.na(res$table)
  tables <- Map(res$schema, res$table, f = as_table)

  ret <- data.frame(
    table = I(unname(tables)),
    is_prefix = is_prefix,
    stringsAsFactors = FALSE
  )
  ret
}

#' @rdname mariadb-tables
#' @export
setMethod("dbListObjects", c("MariaDBConnection", "ANY"), dbListObjects_MariaDBConnection_ANY)
