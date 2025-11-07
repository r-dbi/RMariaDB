# Class MariaDBConnection.

`"MariaDBConnection"` objects are usually created by
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).
They represent a connection to a MariaDB or MySQL database.

## Usage

``` r
# S3 method for class 'MariaDBConnection'
format(x, ...)

# S4 method for class 'MariaDBConnection'
dbDisconnect(conn, ...)

# S4 method for class 'MariaDBConnection'
dbGetInfo(dbObj, what = "", ...)

# S4 method for class 'MariaDBConnection'
dbIsValid(dbObj, ...)

# S4 method for class 'MariaDBConnection'
show(object)
```

## Details

The `"MySQLConnection"` class is a subclass of `"MariaDBConnection"`.
Objects of that class are created by
`dbConnect(MariaDB(), ..., mysql = TRUE)` to indicate that the server is
a MySQL server. The RMariaDB package supports both MariaDB and MySQL
servers, but the SQL dialect and other details vary. The default is to
detect the server type based on the version number.

The older RMySQL package also implements the `"MySQLConnection"` class.
The S4 system is able to distinguish between RMariaDB and RMySQL objects
even if both packages are loaded.
