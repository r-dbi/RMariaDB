# Execute a SQL statement on a database connection.

To retrieve results a chunk at a time, use
[`DBI::dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html),
[`DBI::dbFetch()`](https://dbi.r-dbi.org/reference/dbFetch.html), then
[`DBI::dbClearResult()`](https://dbi.r-dbi.org/reference/dbClearResult.html).
Alternatively, if you want all the results (and they'll fit in memory)
use
[`DBI::dbGetQuery()`](https://dbi.r-dbi.org/reference/dbGetQuery.html)
which sends, fetches and clears for you. For data manipulation queries
(i.e. queries that do not return data, such as `UPDATE`, `DELETE`,
etc.),
[`DBI::dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html)
serves as a counterpart to
[`DBI::dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html),
while
[`DBI::dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html)
corresponds to
[`DBI::dbGetQuery()`](https://dbi.r-dbi.org/reference/dbGetQuery.html).

## Usage

``` r
# S4 method for class 'MariaDBResult'
dbBind(res, params, ...)

# S4 method for class 'MariaDBResult'
dbClearResult(res, ...)

# S4 method for class 'MariaDBResult'
dbFetch(res, n = -1, ..., row.names = FALSE)

# S4 method for class 'MariaDBResult'
dbGetStatement(res, ...)

# S4 method for class 'MariaDBConnection,character'
dbSendQuery(conn, statement, params = NULL, ..., immediate = FALSE)

# S4 method for class 'MariaDBConnection,character'
dbSendStatement(conn, statement, params = NULL, ..., immediate = FALSE)
```

## Arguments

- res:

  A
  [MariaDBResult](https://rmariadb.r-dbi.org/dev/reference/MariaDBResult-class.md)
  object.

- params:

  A list of query parameters to be substituted into a parameterised
  query.

- ...:

  Unused. Needed for compatibility with generic.

- n:

  Number of rows to retrieve. Use -1 to retrieve all rows.

- row.names:

  Either `TRUE`, `FALSE`, `NA` or a string.

  If `TRUE`, always translate row names to a column called "row_names".
  If `FALSE`, never translate row names. If `NA`, translate rownames
  only if they're a character vector.

  A string is equivalent to `TRUE`, but allows you to override the
  default name.

  For backward compatibility, `NULL` is equivalent to `FALSE`.

- conn:

  A
  [MariaDBConnection](https://rmariadb.r-dbi.org/dev/reference/MariaDBConnection-class.md)
  object.

- statement:

  A character vector of length one specifying the SQL statement that
  should be executed. Only a single SQL statement should be provided.

- immediate:

  If TRUE, uses the `mysql_real_query()` API instead of
  `mysql_stmt_init()`. This allows passing multiple statements (with
  [CLIENT_MULTI_STATEMENTS](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md))
  and turns off the ability to pass parameters.

## Examples

``` r
if (mariadbHasDefault()) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
  dbWriteTable(con, "arrests", datasets::USArrests, temporary = TRUE)

  # Run query to get results as dataframe
  dbGetQuery(con, "SELECT * FROM arrests limit 3")

  # Send query to pull requests in batches
  res <- dbSendQuery(con, "SELECT * FROM arrests")
  data <- dbFetch(res, n = 2)
  data
  dbHasCompleted(res)

  dbClearResult(res)
  dbDisconnect(con)
}
```
