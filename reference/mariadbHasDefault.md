# Check if default database is available.

RMariaDB examples and tests connect to a database defined by the
`rs-dbi` group in `~/.my.cnf`. This function checks if that database is
available, and if not, displays an informative message.
`mariadbDefault()` works similarly but throws a testthat skip condition
on failure, making it suitable for use in tests.

## Usage

``` r
mariadbHasDefault()

mariadbDefault()
```

## Examples

``` r
if (mariadbHasDefault()) {
  db <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
  dbListTables(db)
  dbDisconnect(db)
}
```
