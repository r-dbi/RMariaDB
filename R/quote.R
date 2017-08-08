#' @include MariaDBConnection.R
NULL

#' Quote MariaDB strings and identifiers.
#'
#' In MariaDB, identifiers are enclosed in backticks, e.g. \code{`x`}.
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

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
    x <- gsub('`', '``', x, fixed = TRUE)
    SQL(paste('`', x, '`', sep = ""))
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
    SQL(connection_quote_string(conn@ptr, enc2utf8(x)))
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "SQL"),
  function(conn, x, ...) {
    x
  }
)
