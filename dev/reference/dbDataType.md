# Determine the SQL Data Type of an S object

This method is a straight-forward implementation of the corresponding
generic function.

## Usage

``` r
# S4 method for class 'MariaDBConnection'
dbDataType(dbObj, obj, ...)

# S4 method for class 'MariaDBDriver'
dbDataType(dbObj, obj, ...)
```

## Arguments

- dbObj:

  A
  [MariaDBDriver](https://rmariadb.r-dbi.org/dev/reference/MariaDBDriver-class.md)
  or
  [MariaDBConnection](https://rmariadb.r-dbi.org/dev/reference/MariaDBConnection-class.md)
  object.

- obj:

  R/S-Plus object whose SQL type we want to determine.

- ...:

  any other parameters that individual methods may need.

## Examples

``` r
dbDataType(RMariaDB::MariaDB(), "a")
#> [1] "VARCHAR(1)"
dbDataType(RMariaDB::MariaDB(), 1:3)
#> [1] "INTEGER"
dbDataType(RMariaDB::MariaDB(), 2.5)
#> [1] "DOUBLE"
```
