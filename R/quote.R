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

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
    if (any(is.na(x))) {
      stop("Cannot pass NA to dbQuoteIdentifier()", call. = FALSE)
    }
    x <- gsub("`", "``", x, fixed = TRUE)
    if (length(x) == 0L) {
      SQL(character())
    } else {
      # Not calling encodeString() here to keep things simple
      SQL(paste("`", x, "`", sep = ""))
    }
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "SQL"),
  function(conn, x, ...) {
    x
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
