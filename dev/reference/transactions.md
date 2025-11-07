# DBMS Transaction Management

Commits or roll backs the current transaction in an MariaDB connection.
Note that in MariaDB DDL statements (e.g. `CREATE TABLE`) cannot be
rolled back.

## Usage

``` r
# S4 method for class 'MariaDBConnection'
dbBegin(conn, ...)

# S4 method for class 'MariaDBConnection'
dbCommit(conn, ...)

# S4 method for class 'MariaDBConnection'
dbRollback(conn, ...)
```

## Arguments

- conn:

  a
  [MariaDBConnection](https://rmariadb.r-dbi.org/dev/reference/MariaDBConnection-class.md)
  object, as produced by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- ...:

  Unused.

## Examples

``` r
if (mariadbHasDefault()) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
  df <- data.frame(id = 1:5)

  dbWriteTable(con, "df", df, temporary = TRUE)
  dbBegin(con)
  dbExecute(con, "UPDATE df SET id = id * 10")
  dbGetQuery(con, "SELECT id FROM df")
  dbRollback(con)

  dbGetQuery(con, "SELECT id FROM df")

  dbDisconnect(con)
}
```
