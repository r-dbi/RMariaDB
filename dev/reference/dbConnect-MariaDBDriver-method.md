# Connect/disconnect to a MariaDB DBMS

These methods are straight-forward implementations of the corresponding
generic functions.

## Usage

``` r
MariaDB()

# S4 method for class 'MariaDBDriver'
dbConnect(
  drv,
  dbname = NULL,
  username = NULL,
  password = NULL,
  host = NULL,
  unix.socket = NULL,
  port = 0,
  client.flag = 0,
  group = "rs-dbi",
  default.file = NULL,
  ssl.key = NULL,
  ssl.cert = NULL,
  ssl.ca = NULL,
  ssl.capath = NULL,
  ssl.cipher = NULL,
  ...,
  groups = NULL,
  load_data_local_infile = FALSE,
  bigint = c("integer64", "integer", "numeric", "character"),
  timeout = 10,
  timezone = "+00:00",
  timezone_out = NULL,
  reconnect = FALSE,
  mysql = NULL
)
```

## Arguments

- drv:

  an object of class
  [MariaDBDriver](https://rmariadb.r-dbi.org/dev/reference/MariaDBDriver-class.md)
  or
  [MariaDBConnection](https://rmariadb.r-dbi.org/dev/reference/MariaDBConnection-class.md).

- dbname:

  string with the database name or NULL. If not NULL, the connection
  sets the default database to this value.

- username, password:

  Username and password. If username omitted, defaults to the current
  user. If password is omitted, only users without a password can log
  in.

- host:

  string identifying the host machine running the MariaDB server or
  NULL. If NULL or the string `"localhost"`, a connection to the local
  host is assumed.

- unix.socket:

  (optional) string of the unix socket or named pipe.

- port:

  (optional) integer of the TCP/IP default port.

- client.flag:

  (optional) integer setting various MariaDB client flags, see
  [Client-flags](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  for details.

- group:

  string identifying a section in the `default.file` to use for setting
  authentication parameters (see `MariaDB()`).

- default.file:

  string of the filename with MariaDB client options, only relevant if
  `groups` is given. The default value depends on the operating system
  (see references), on Linux and OS X the files `~/.my.cnf` and
  `~/.mylogin.cnf` are used. Expanded with
  [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html).

- ssl.key:

  (optional) string of the filename of the SSL key file to use. Expanded
  with [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html).

- ssl.cert:

  (optional) string of the filename of the SSL certificate to use.
  Expanded with
  [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html).

- ssl.ca:

  (optional) string of the filename of an SSL certificate authority file
  to use. Expanded with
  [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html).

- ssl.capath:

  (optional) string of the path to a directory containing the trusted
  SSL CA certificates in PEM format. Expanded with
  [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html).

- ssl.cipher:

  (optional) string list of permitted ciphers to use for SSL encryption.

- ...:

  Unused, needed for compatibility with generic.

- groups:

  deprecated, use `group` instead.

- load_data_local_infile:

  Set to `TRUE` to use `LOAD DATA LOCAL INFILE` in
  [`DBI::dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  and
  [`DBI::dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  by default. This capability is disabled by default on the server side
  for recent versions of MySQL Server.

- bigint:

  The R type that 64-bit integer types should be mapped to, default is
  [bit64::integer64](https://rdrr.io/pkg/bit64/man/bit64-package.html),
  which allows the full range of 64 bit integers.

- timeout:

  Connection timeout, in seconds. Use `Inf` or a negative value for no
  timeout.

- timezone:

  (optional) time zone for the connection, the default corresponds to
  UTC. Set this argument if your server or database is configured with a
  different time zone than UTC. Set to `NULL` to automatically determine
  the server time zone.

- timezone_out:

  The time zone returned to R. The default is to use the value of the
  `timezone` argument, `"+00:00"` is converted to `"UTC"` If you want to
  display datetime values in the local timezone, set to
  [`Sys.timezone()`](https://rdrr.io/r/base/timezones.html) or `""`.
  This setting does not change the time values returned, only their
  display.

- reconnect:

  (experimental) Set to `TRUE` to use `MYSQL_OPT_RECONNECT` to enable
  automatic reconnection. This is experimental and could be dangerous if
  the connection is lost in the middle of a transaction.

- mysql:

  Set to `TRUE`/`FALSE` to connect to a MySQL server or to a MariaDB
  server, respectively. The RMariaDB package supports both MariaDB and
  MySQL servers, but the SQL dialect and other details vary. The default
  is to assume MariaDB if the version is \>= 10.0.0, and MySQL
  otherwise.

## Time zones

MySQL and MariaDB support named time zones, they must be installed on
the server. See
<https://dev.mysql.com/doc/mysql-g11n-excerpt/8.0/en/time-zone-support.html>
for more details. Without installation, time zone support is restricted
to UTC offset, which cannot take into account DST offsets.

## Secure passwords

Avoid storing passwords hard-coded in the code, use e.g. the keyring
package to store and retrieve passwords in a secure way.

The MySQL client library (but not MariaDB) supports a `.mylogin.cnf`
file that can be passed in the `default.file` argument. This file can
contain an obfuscated password, which is not a secure way to store
passwords but may be acceptable if the user is aware of the
restrictions. The availability of this feature depends on the client
library used for compiling the RMariaDB package. Windows and macOS
binaries on CRAN are compiled against the MariaDB Connector/C client
library which do not support this feature.

## References

Configuration files:
https://mariadb.com/kb/en/library/configuring-mariadb-with-mycnf/

## Examples
