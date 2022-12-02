#' Connect/disconnect to a MariaDB DBMS
#'
#' These methods are straight-forward implementations of the corresponding
#' generic functions.
#'
#' @section Time zones:
#' MySQL and MariaDB support named time zones,
#' they must be installed on the server.
#' See <https://dev.mysql.com/doc/mysql-g11n-excerpt/8.0/en/time-zone-support.html>
#' for more details.
#' Without installation, time zone support is restricted to UTC offset,
#' which cannot take into account DST offsets.
#'
#' @section Secure passwords:
#' Avoid storing passwords hard-coded in the code, use e.g. the \pkg{keyring}
#' package to store and retrieve passwords in a secure way.
#'
#' The MySQL client library (but not MariaDB) supports a `.mylogin.cnf` file
#' that can be passed in the `default.file` argument.
#' This file can contain an obfuscated password, which is not a secure way
#' to store passwords but may be acceptable if the user is aware of the
#' restrictions.
#' The availability of this feature depends on the client library used
#' for compiling the \pkg{RMariaDB} package.
#' Windows and macOS binaries on CRAN are compiled against the MariaDB Connector/C
#' client library which do not support this feature.
#'
#' @param drv an object of class [MariaDBDriver-class] or
#'   [MariaDBConnection-class].
#' @param username,password Username and password. If username omitted,
#'   defaults to the current user. If password is omitted, only users
#'   without a password can log in.
#' @param dbname string with the database name or NULL. If not NULL, the
#'   connection sets the default database to this value.
#' @param host string identifying the host machine running the MariaDB server or
#'   NULL. If NULL or the string `"localhost"`, a connection to the local
#'   host is assumed.
#' @param unix.socket (optional) string of the unix socket or named pipe.
#' @param port (optional) integer of the TCP/IP default port.
#' @param client.flag (optional) integer setting various MariaDB client flags,
#'   see [Client-flags] for details.
#' @param groups string identifying a section in the `default.file` to use
#'   for setting authentication parameters (see [MariaDB()]).
#' @param default.file string of the filename with MariaDB client options,
#'   only relevant if `groups` is given. The default value depends on the
#'   operating system (see references), on Linux and OS X the files
#'   `~/.my.cnf` and `~/.mylogin.cnf` are used. Expanded with [normalizePath()].
#' @param ssl.key (optional) string of the filename of the SSL key file to use.
#'   Expanded with [normalizePath()].
#' @param ssl.cert (optional) string of the filename of the SSL certificate to
#'   use. Expanded with [normalizePath()].
#' @param ssl.ca (optional) string of the filename of an SSL certificate
#'   authority file to use. Expanded with [normalizePath()].
#' @param ssl.capath (optional) string of the path to a directory containing
#'   the trusted SSL CA certificates in PEM format. Expanded with
#'   [normalizePath()].
#' @param ssl.cipher (optional) string list of permitted ciphers to use for SSL
#'   encryption.
#' @param ... Unused, needed for compatibility with generic.
#' @param load_data_local_infile Set to `TRUE` to use `LOAD DATA LOCAL INFILE`
#'   in [dbWriteTable()] and [dbAppendTable()] by default.
#'   This capability is disabled by default on the server side
#'   for recent versions of MySQL Server.
#' @param bigint The R type that 64-bit integer types should be mapped to,
#'   default is [bit64::integer64], which allows the full range of 64 bit
#'   integers.
#' @param timeout Connection timeout, in seconds. Use `Inf` or a negative value
#'   for no timeout.
#' @param timezone (optional) time zone for the connection,
#'   the default corresponds to UTC.
#'   Set this argument if your server or database is configured with a different
#'   time zone than UTC.
#'   Set to `NULL` to automatically determine the server time zone.
#' @param timezone_out The time zone returned to R.
#'   The default is to use the value of the `timezone` argument,
#'   `"+00:00"` is converted to `"UTC"`
#'   If you want to display datetime values in the local timezone,
#'   set to [Sys.timezone()] or `""`.
#'   This setting does not change the time values returned, only their display.
#' @param reconnect (experimental) Set to `TRUE` to use `MYSQL_OPT_RECONNECT` to enable
#'   automatic reconnection. This is experimental and could be dangerous if the connection
#'   is lost in the middle of a transaction.
#' @references
#' Configuration files: https://mariadb.com/kb/en/library/configuring-mariadb-with-mycnf/
#' @examples
#' \dontrun{
#' # Connect to a MariaDB database running locally
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "mydb")
#' # Connect to a remote database with username and password
#' con <- dbConnect(RMariaDB::MariaDB(),
#'   host = "mydb.mycompany.com",
#'   user = "abc", password = "def"
#' )
#' # But instead of supplying the username and password in code, it's usually
#' # better to set up a group in your .my.cnf (usually located in your home
#' # directory). Then it's less likely you'll inadvertently share them.
#' con <- dbConnect(RMariaDB::MariaDB(), group = "test")
#'
#' # Always cleanup by disconnecting the database
#' dbDisconnect(con)
#' }
#'
#' # All examples use the rs-dbi group by default.
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'   con
#'   dbDisconnect(con)
#' }
#' @usage NULL
#' @rdname dbConnect-MariaDBDriver-method
dbConnect_MariaDBDriver <- function(drv, dbname = NULL, username = NULL, password = NULL, host = NULL,
                                    unix.socket = NULL, port = 0, client.flag = 0,
                                    groups = "rs-dbi", default.file = NULL, ssl.key = NULL, ssl.cert = NULL,
                                    ssl.ca = NULL, ssl.capath = NULL, ssl.cipher = NULL, ...,
                                    load_data_local_infile = FALSE,
                                    bigint = c("integer64", "integer", "numeric", "character"),
                                    timeout = 10, timezone = "+00:00", timezone_out = NULL, reconnect = FALSE) {
  bigint <- match.arg(bigint)

  if (is.infinite(timeout)) {
    timeout <- -1L
  } else {
    timeout <- as.integer(timeout)
  }

  # Make sure that `~` is resolved correctly:
  if (!is.null(default.file)) {
    default.file <- normalizePath(default.file)
  }
  if (!is.null(ssl.key)) {
    ssl.key <- normalizePath(ssl.key)
  }
  if (!is.null(ssl.cert)) {
    ssl.cert <- normalizePath(ssl.cert)
  }
  if (!is.null(ssl.ca)) {
    ssl.ca <- normalizePath(ssl.ca)
  }
  if (!is.null(ssl.capath)) {
    ssl.capath <- normalizePath(ssl.capath)
  }

  if (isTRUE(load_data_local_infile)) {
    if (!rlang::is_installed("readr")) {
      stopc("`load_data_local_infile = TRUE` requires the readr package.")
    }
  }

  reconnect <- isTRUE(reconnect)

  ptr <- connection_create(
    host, username, password, dbname, as.integer(port), unix.socket,
    as.integer(client.flag), groups, default.file,
    ssl.key, ssl.cert, ssl.ca, ssl.capath, ssl.cipher,
    timeout, reconnect
  )

  info <- connection_info(ptr)

  conn <- new("MariaDBConnection",
    ptr = ptr,
    host = info$host,
    db = info$dbname,
    load_data_local_infile = isTRUE(load_data_local_infile),
    bigint = bigint
  )

  on.exit(dbDisconnect(conn))

  if (!is.null(timezone)) {
    # Side effect: check if time zone valid
    dbExecute(conn, paste0("SET time_zone = ", dbQuoteString(conn, timezone)))
  } else {
    timezone <- dbGetQuery(conn, "SELECT @@SESSION.time_zone")[[1]]
  }

  # Check if this is a valid time zone in R:
  timezone <- check_tz(timezone)

  if (is.null(timezone_out)) {
    timezone_out <- timezone
  } else {
    timezone_out <- check_tz(timezone_out)
  }

  conn@timezone <- timezone
  conn@timezone_out <- timezone_out

  dbExecute(conn, "SET autocommit = 0")
  on.exit(NULL)

  conn
}

#' @rdname dbConnect-MariaDBDriver-method
#' @export
setMethod("dbConnect", "MariaDBDriver", dbConnect_MariaDBDriver)
