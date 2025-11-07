# Read and write MariaDB tables.

These methods read or write entire tables from a MariaDB database.

## Usage

``` r
# S4 method for class 'MariaDBConnection'
dbAppendTable(conn, name, value, ..., row.names = NULL)

# S4 method for class 'MariaDBConnection,character'
dbExistsTable(conn, name, ...)

# S4 method for class 'MariaDBConnection'
dbListObjects(conn, prefix = NULL, ...)

# S4 method for class 'MariaDBConnection'
dbListTables(conn, ...)

# S4 method for class 'MariaDBConnection,character'
dbReadTable(conn, name, ..., row.names = FALSE, check.names = TRUE)

# S4 method for class 'MariaDBConnection,character'
dbRemoveTable(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE)

# S4 method for class 'MariaDBConnection,character,character'
dbWriteTable(
  conn,
  name,
  value,
  field.types = NULL,
  overwrite = FALSE,
  append = FALSE,
  header = TRUE,
  row.names = FALSE,
  nrows = 50,
  sep = ",",
  eol = "\n",
  skip = 0,
  quote = "\"",
  temporary = FALSE,
  ...
)

# S4 method for class 'MariaDBConnection,character,data.frame'
dbWriteTable(
  conn,
  name,
  value,
  field.types = NULL,
  row.names = FALSE,
  overwrite = FALSE,
  append = FALSE,
  ...,
  temporary = FALSE
)
```

## Arguments

- conn:

  a
  [MariaDBConnection](https://rmariadb.r-dbi.org/dev/reference/MariaDBConnection-class.md)
  object, produced by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- name:

  a character string specifying a table name.

- value:

  A data frame.

- ...:

  Unused, needed for compatibility with generic.

- row.names:

  Either `TRUE`, `FALSE`, `NA` or a string.

  If `TRUE`, always translate row names to a column called "row_names".
  If `FALSE`, never translate row names. If `NA`, translate rownames
  only if they're a character vector.

  A string is equivalent to `TRUE`, but allows you to override the
  default name.

  For backward compatibility, `NULL` is equivalent to `FALSE`.

- prefix:

  A fully qualified path in the database's namespace, or `NULL`. This
  argument will be processed with
  [`dbUnquoteIdentifier()`](https://dbi.r-dbi.org/reference/dbUnquoteIdentifier.html).
  If given the method will return all objects accessible through this
  prefix.

- check.names:

  If `TRUE`, the default, column names will be converted to valid R
  identifiers.

- temporary:

  If `TRUE`, creates a temporary table that expires when the connection
  is closed. For
  [`dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html),
  only temporary tables are considered if this argument is set to
  `TRUE`.

- fail_if_missing:

  If `FALSE`,
  [`dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html)
  succeeds if the table doesn't exist.

- field.types:

  Optional, overrides default choices of field types, derived from the
  classes of the columns in the data frame.

- overwrite:

  a logical specifying whether to overwrite an existing table or not.
  Its default is `FALSE`.

- append:

  a logical specifying whether to append to an existing table in the
  DBMS. If appending, then the table (or temporary table) must exist,
  otherwise an error is reported. Its default is `FALSE`.

- header:

  logical, does the input file have a header line? Default is the same
  heuristic used by
  [`read.table()`](https://rdrr.io/r/utils/read.table.html), i.e.,
  `TRUE` if the first line has one fewer column that the second line.

- nrows:

  number of lines to rows to import using `read.table` from the input
  file to create the proper table definition. Default is 50.

- sep:

  field separator character

- eol:

  End-of-line separator

- skip:

  number of lines to skip before reading data in the input file.

- quote:

  the quote character used in the input file (defaults to `\"`.)

## Value

A data.frame in the case of
[`dbReadTable()`](https://dbi.r-dbi.org/reference/dbReadTable.html);
otherwise a logical indicating whether the operation was successful.

## Details

When using `load_data_local_infile = TRUE` in
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html),
pass `safe = FALSE` to
[`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
to avoid transactions. Because `LOAD DATA INFILE` is used internally,
this means that rows violating primary key constraints are now silently
ignored.

## Note

The data.frame returned by
[`dbReadTable()`](https://dbi.r-dbi.org/reference/dbReadTable.html) only
has primitive data, e.g., it does not coerce character data to factors.
Temporary tables are ignored for
[`dbExistsTable()`](https://dbi.r-dbi.org/reference/dbExistsTable.html)
and
[`dbListTables()`](https://dbi.r-dbi.org/reference/dbListTables.html)
due to limitations of the underlying C API. For this reason, a prior
existence check is performed only before creating a regular persistent
table; an attempt to create a temporary table with an already existing
name will fail with a message from the database driver.

## Examples

``` r
if (mariadbHasDefault()) {
  con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")

  # By default, row names are written in a column to row_names, and
  # automatically read back into the row.names()
  dbWriteTable(con, "mtcars", mtcars[1:5, ], temporary = TRUE)
  dbReadTable(con, "mtcars")
  dbReadTable(con, "mtcars", row.names = FALSE)
}
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> 2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> 3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> 4 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> 5 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
```
