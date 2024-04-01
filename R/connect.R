#' @include MariaDBConnection.R
NULL

check_tz <- function(timezone) {
  arg_name <- deparse(substitute(timezone))

  if (timezone == "+00:00") {
    timezone <- "UTC"
  }

  tryCatch(
    lubridate::force_tz(as.POSIXct("2021-03-01 10:40"), timezone),
    error = function(e) {
      warning(
        "Invalid time zone '", timezone, "', ",
        "falling back to local time.\n",
        "Set the `", arg_name, "` argument to a valid time zone.\n",
        conditionMessage(e),
        call. = FALSE
      )
      timezone <- ""
    }
  )

  timezone
}

#' @export
#' @import methods DBI
#' @importFrom hms hms
#' @importFrom bit64 integer64 is.integer64
#' @rdname dbConnect-MariaDBDriver-method
#' @examples
#' if (mariadbHasDefault()) {
#'   # connect to a database and load some data
#'   con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'   dbWriteTable(con, "USArrests", datasets::USArrests, temporary = TRUE)
#'
#'   # query
#'   rs <- dbSendQuery(con, "SELECT * FROM USArrests")
#'   d1 <- dbFetch(rs, n = 10)      # extract data in chunks of 10 rows
#'   dbHasCompleted(rs)
#'   d2 <- dbFetch(rs, n = -1)      # extract all remaining data
#'   dbHasCompleted(rs)
#'   dbClearResult(rs)
#'   dbListTables(con)
#'
#'   # clean up
#'   dbDisconnect(con)
#' }
MariaDB <- function() {
  new("MariaDBDriver")
}

#' Client flags
#'
#' Use for the `client.flag` argument to [dbConnect()], multiple flags can be
#' combined with `+` or [bitwOr()].
#' The flags are provided for completeness.
#'
#' @seealso
#' The `flags` argument at https://mariadb.com/kb/en/library/mysql_real_connect.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(RMariaDB)
#' con1 <- dbConnect(MariaDB(), client.flag = CLIENT_COMPRESS)
#' con2 <- dbConnect(
#'   MariaDB(),
#'   client.flag = bitwOr(CLIENT_COMPRESS, CLIENT_SECURE_CONNECTION)
#' )
#' }
#'
#' @aliases CLIENT_LONG_PASSWORD CLIENT_FOUND_ROWS CLIENT_LONG_FLAG
#' CLIENT_CONNECT_WITH_DB CLIENT_NO_SCHEMA CLIENT_COMPRESS CLIENT_ODBC
#' CLIENT_LOCAL_FILES CLIENT_IGNORE_SPACE CLIENT_PROTOCOL_41 CLIENT_INTERACTIVE
#' CLIENT_SSL CLIENT_IGNORE_SIGPIPE CLIENT_TRANSACTIONS CLIENT_RESERVED
#' CLIENT_SECURE_CONNECTION CLIENT_MULTI_STATEMENTS CLIENT_MULTI_RESULTS
#' @name Client-flags
NULL

## The following client flags were copied from mysql_com.h (version 4.1.13)
## but it may not make sense to set some of this from RMariaDB.
#' @export
CLIENT_LONG_PASSWORD <-   1
# new more secure passwords

#' @export
CLIENT_FOUND_ROWS    <-   2
# Found instead of affected rows

#' @export
CLIENT_LONG_FLAG     <-   4
# Get all column flags

#' @export
CLIENT_CONNECT_WITH_DB <- 8
# One can specify db on connect

#' @export
CLIENT_NO_SCHEMA     <-  16
# Don't allow database.table.column

#' @export
CLIENT_COMPRESS      <-  32
# Can use compression protocol

#' @export
CLIENT_ODBC          <-  64
# Odbc client

#' @export
CLIENT_LOCAL_FILES   <- 128
# Can use LOAD DATA LOCAL

#' @export
CLIENT_IGNORE_SPACE  <- 256
# Ignore spaces before '('

#' @export
CLIENT_PROTOCOL_41   <- 512
# New 4.1 protocol

#' @export
CLIENT_INTERACTIVE   <- 1024
# This is an interactive client

#' @export
CLIENT_SSL           <- 2048
# Switch to SSL after handshake

#' @export
CLIENT_IGNORE_SIGPIPE <- 4096
# IGNORE sigpipes

#' @export
CLIENT_TRANSACTIONS <- 8192
# Client knows about transactions

#' @export
CLIENT_RESERVED     <- 16384
# Old flag for 4.1 protocol

#' @export
CLIENT_SECURE_CONNECTION <- 32768
# New 4.1 authentication

#' @export
CLIENT_MULTI_STATEMENTS  <- 65536
# Enable/disable multi-stmt support

#' @export
CLIENT_MULTI_RESULTS     <- 131072
# Enable/disable multi-results
