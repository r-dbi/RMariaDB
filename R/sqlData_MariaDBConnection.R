sqlData_MariaDBConnection <- function(con, value, row.names = FALSE, ...) {
  value <- sql_data(value, con, row.names)
  value <- quote_string(value, con)

  value
}

setMethod("sqlData", "MariaDBConnection", sqlData_MariaDBConnection)
