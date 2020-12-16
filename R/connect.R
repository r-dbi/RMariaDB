#' @include MariaDBConnection.R
NULL

#' Connect/disconnect to a MariaDB DBMS
#'
#' These methods are straight-forward implementations of the corresponding
#' generic functions.
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
#'   `~/.my.cnf` and `~/.mylogin.cnf` are used.
#' @param ssl.key (optional) string of the filename of the SSL key file to use.
#' @param ssl.cert (optional) string of the filename of the SSL certificate to
#'   use.
#' @param ssl.ca (optional) string of the filename of an SSL certificate
#'   authority file to use.
#' @param ssl.capath (optional) string of the path to a directory containing
#'   the trusted SSL CA certificates in PEM format.
#' @param ssl.cipher (optional) string list of permitted ciphers to use for SSL
#'   encryption.
#' @param ... Unused, needed for compatibility with generic.
#' @param bigint The R type that 64-bit integer types should be mapped to,
#'   default is [bit64::integer64], which allows the full range of 64 bit
#'   integers.
#' @param timeout Connection timeout, in seconds. Use `Inf` or a negative value
#'   for no timeout.
#' @param timezone (optional) time zone for the connection,
#'   the default corresponds to UTC.
#'   Set this argument if your server or database is configured with a different
#'   time zone than UTC.
#' @references
#' Configuration files: https://mariadb.com/kb/en/library/configuring-mariadb-with-mycnf/
#' @export
#' @examples
#' \dontrun{
#' # Connect to a MariaDB database running locally
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "mydb")
#' # Connect to a remote database with username and password
#' con <- dbConnect(RMariaDB::MariaDB(), host = "mydb.mycompany.com",
#'   user = "abc", password = "def")
#' # But instead of supplying the username and password in code, it's usually
#' # better to set up a group in your .my.cnf (usually located in your home
#' directory). Then it's less likely you'll inadvertently share them.
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
#' @export
setMethod("dbConnect", "MariaDBDriver",
  function(drv, dbname = NULL, username = NULL, password = NULL, host = NULL,
    unix.socket = NULL, port = 0, client.flag = 0,
    groups = "rs-dbi", default.file = NULL, ssl.key = NULL, ssl.cert = NULL,
    ssl.ca = NULL, ssl.capath = NULL, ssl.cipher = NULL, ...,
    bigint = c("integer64", "integer", "numeric", "character"),
    timeout = 10, timezone = "+00:00") {

    bigint <- match.arg(bigint)

    if (is.infinite(timeout)) {
      timeout <- -1L
    } else {
      timeout <- as.integer(timeout)
    }

    ptr <- connection_create(
      host, username, password, dbname, as.integer(port), unix.socket,
      as.integer(client.flag), groups, default.file,
      ssl.key, ssl.cert, ssl.ca, ssl.capath, ssl.cipher,
      timeout
    )

    info <- connection_info(ptr)

    conn <- new("MariaDBConnection",
      ptr = ptr,
      host = info$host,
      db = info$dbname,
      bigint = bigint
    )

    on.exit(dbDisconnect(conn))

    dbExecute(conn, paste0("SET time_zone = ", dbQuoteString(conn, timezone)))
    dbExecute(conn, "SET autocommit = 0")
    on.exit(NULL)

    conn
  }
)

#' @export
#' @import methods DBI
#' @importFrom hms hms
#' @importFrom bit64 integer64
#' @rdname dbConnect-MariaDBDriver-method
#' @examples
#' if (mariadbHasDefault()) {
#' # connect to a database and load some data
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#' dbWriteTable(con, "USArrests", datasets::USArrests, temporary = TRUE)
#'
#' # query
#' rs <- dbSendQuery(con, "SELECT * FROM USArrests")
#' d1 <- dbFetch(rs, n = 10)      # extract data in chunks of 10 rows
#' dbHasCompleted(rs)
#' d2 <- dbFetch(rs, n = -1)      # extract all remaining data
#' dbHasCompleted(rs)
#' dbClearResult(rs)
#' dbListTables(con)
#'
#' # clean up
#' dbDisconnect(con)
#' }
MariaDB <- function() {
  new("MariaDBDriver")
}

#' Client flags
#'
#' Use for the `client.flag` argument to [dbConnect()], multiple flags can be
#' combined with a bitwise or (see [Logic]).  The flags are provided for
#' completeness.
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
#'   client.flag = CLIENT_COMPRESS | CLIENT_SECURE_CONNECTION
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
CLIENT_LONG_PASSWORD <-   1    # new more secure passwords
#' @export
CLIENT_FOUND_ROWS    <-   2    # Found instead of affected rows
#' @export
CLIENT_LONG_FLAG     <-   4    # Get all column flags
#' @export
CLIENT_CONNECT_WITH_DB <- 8    # One can specify db on connect
#' @export
CLIENT_NO_SCHEMA     <-  16    # Don't allow database.table.column
#' @export
CLIENT_COMPRESS      <-  32    # Can use compression protocol
#' @export
CLIENT_ODBC          <-  64    # Odbc client
#' @export
CLIENT_LOCAL_FILES   <- 128    # Can use LOAD DATA LOCAL
#' @export
CLIENT_IGNORE_SPACE  <- 256    # Ignore spaces before '('
#' @export
CLIENT_PROTOCOL_41   <- 512    # New 4.1 protocol
#' @export
CLIENT_INTERACTIVE   <- 1024   # This is an interactive client
#' @export
CLIENT_SSL           <- 2048   # Switch to SSL after handshake
#' @export
CLIENT_IGNORE_SIGPIPE <- 4096  # IGNORE sigpipes
#' @export
CLIENT_TRANSACTIONS <- 8192    # Client knows about transactions
#' @export
CLIENT_RESERVED     <- 16384   # Old flag for 4.1 protocol
#' @export
CLIENT_SECURE_CONNECTION <- 32768 # New 4.1 authentication
#' @export
CLIENT_MULTI_STATEMENTS  <- 65536 # Enable/disable multi-stmt support
#' @export
CLIENT_MULTI_RESULTS     <- 131072 # Enable/disable multi-results
