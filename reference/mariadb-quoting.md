# Quote MariaDB strings and identifiers.

In MariaDB, identifiers are enclosed in backticks, e.g. `` `x` ``.

## Usage

``` r
# S4 method for class 'MariaDBConnection,Id'
dbQuoteIdentifier(conn, x, ...)

# S4 method for class 'MariaDBConnection,SQL'
dbQuoteIdentifier(conn, x, ...)

# S4 method for class 'MariaDBConnection,character'
dbQuoteIdentifier(conn, x, ...)

# S4 method for class 'MariaDBConnection'
dbQuoteLiteral(conn, x, ...)

# S4 method for class 'MariaDBConnection,SQL'
dbQuoteString(conn, x, ...)

# S4 method for class 'MariaDBConnection,character'
dbQuoteString(conn, x, ...)

# S4 method for class 'MariaDBConnection,SQL'
dbUnquoteIdentifier(conn, x, ...)
```

## Examples

``` r
if (mariadbHasDefault()) {
  con <- dbConnect(RMariaDB::MariaDB())
  dbQuoteIdentifier(con, c("a b", "a`b"))
  dbQuoteString(con, c("a b", "a'b"))
  dbDisconnect(con)
}
```
