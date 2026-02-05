# Client flags

Use for the `client.flag` argument to
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html),
multiple flags can be combined with `+` or
[`bitwOr()`](https://rdrr.io/r/base/bitwise.html). The flags are
provided for completeness. To enforce SSL for the DB connection, add the
flag `CLIENT_SSL`.

## See also

The `flags` argument at
https://mariadb.com/kb/en/library/mysql_real_connect.

## Examples

``` r
if (FALSE) { # \dontrun{
library(DBI)
library(RMariaDB)
con1 <- dbConnect(MariaDB(), client.flag = CLIENT_COMPRESS)
con2 <- dbConnect(
  MariaDB(),
  client.flag = bitwOr(CLIENT_COMPRESS, CLIENT_SSL)
)
} # }
```
