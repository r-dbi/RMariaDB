# Database interface meta-data.

See documentation of generics for more details.

## Usage

``` r
# S4 method for class 'MariaDBResult'
dbColumnInfo(res, ...)

# S4 method for class 'MariaDBResult'
dbGetRowCount(res, ...)

# S4 method for class 'MariaDBResult'
dbGetRowsAffected(res, ...)

# S4 method for class 'MariaDBResult'
dbHasCompleted(res, ...)
```

## Arguments

- res:

  An object of class
  [MariaDBResult](https://rmariadb.r-dbi.org/dev/reference/MariaDBResult-class.md)

- ...:

  Ignored. Needed for compatibility with generic

## Examples

``` r
if (mariadbHasDefault()) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
  dbWriteTable(con, "t1", datasets::USArrests, temporary = TRUE)

  rs <- dbSendQuery(con, "SELECT * FROM t1 WHERE UrbanPop >= 80")
  rs

  dbGetStatement(rs)
  dbHasCompleted(rs)
  dbColumnInfo(rs)

  dbFetch(rs)
  rs

  dbClearResult(rs)
  dbDisconnect(con)
}
```
