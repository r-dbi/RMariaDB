#' @include MariaDBConnection.R
NULL

#' Quote MariaDB strings and identifiers.
#'
#' In MariaDB, identifiers are enclosed in backticks, e.g. `` `x` ``.
#'
#' @keywords internal
#' @name mariadb-quoting
#' @examples
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB())
#'   dbQuoteIdentifier(con, c("a b", "a`b"))
#'   dbQuoteString(con, c("a b", "a'b"))
#'   dbDisconnect(con)
#' }
NULL

as_table <- function(schema, table) {
  args <- c(schema = schema, table = table)
  # Also omits NA args
  args <- args[!is.na(args) & args != ""]
  do.call(Id, as.list(args))
}

cast_difftime <- function(x) {
  SQL(paste0("CAST(", x, " AS time)"))
}
