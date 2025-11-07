# Class MariaDBDriver with constructor MariaDB.

An MariaDB driver implementing the R database (DBI) API. This class
should always be initialized with the
[`MariaDB()`](https://rmariadb.r-dbi.org/dev/reference/dbConnect-MariaDBDriver-method.md)
function. It returns a singleton that allows you to connect to MariaDB.

## Usage

``` r
# S4 method for class 'MariaDBDriver'
dbGetInfo(dbObj, ...)

# S4 method for class 'MariaDBDriver'
dbIsValid(dbObj, ...)

# S4 method for class 'MariaDBDriver'
dbUnloadDriver(drv, ...)
```
