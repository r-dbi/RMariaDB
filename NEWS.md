<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# RMariaDB 1.3.0 (2023-10-08)

## Features

- Connections now inherit from `"MySQLConnection"` if a MySQL server is detected (server version \< 10.0 or server description contains `"MariaDB"`). The new `mysql` argument to `dbConnect()` allows overriding the autodetection (#303).
- Use string as default for JSON (#296) and all unknown column types (@LeeMendelowitz, #260).
- Support `TIME` columns with subsecond precision (@renkun-ken, #288, #289).

## Documentation

- Better `MAX_NO_FIELD_TYPES` error message.

## Chore

- Update Windows libs to new location (#301).
- Replace Rcpp by cpp11 (@Antonov548, #286).
- Add decor as a dependency.

## Testing

- Skip tests if packages are not available (#304).
- Use testthat edition 3 (#285).


# RMariaDB 1.2.2 (2022-06-19)

## Features 

- `dbAppendTable()` accepts `Id` (#262, @renkun-ken).

- `dbConnect()` gains `reconnect` argument that sets the `MYSQL_OPT_RECONNECT` option (#261, @renkun-ken).

## Bug fixes

- Actually enable `LOAD LOCAL INFILE` by setting the `MYSQL_OPT_LOCAL_INFILE` flag (#265, #267).


# RMariaDB 1.2.1 (2021-12-20)

## Features

- Upgrade to mariadb-connector-c 3.2.5 on Windows, with built-in support for the `caching_sha2_password` plugin (#134, #248, @jeroen).

## Internal

- Make method definition more similar to S3. All `setMethod()` calls refer to top-level functions (#250).


# RMariaDB 1.2.0 (2021-12-12)

## Features

- BLOBs are returned as `blob::blob()` objects (#126, #243).
- `dbWriteTable()` and `dbAppendTable()` are much faster thanks to `LOAD DATA LOCAL INFILE`. To activate this, `load_data_local_infile = TRUE` must be passed to `dbConnect()`. The readr package is required (#11, #223).

## Bug fixes

- Writing dates prior to 1970 no longer crashes on Windows (#232, #245).

## Internal

- Add test for reading and writing JSON data type as string (#127, #246).
- Update for compatibility with DBItest 1.7.2 (#228).


# RMariaDB 1.1.2 (2021-09-06)

## Licensing

- RMariaDB is now licensed under the MIT license (#213).

## Features

- `dbConnect()` normalizes all input paths (#197, @twentytitus).
- `dbDataType()` returns `TIME(6)` for `difftime`, and `DATETIME(6)` for `POSIXt` columns, to create columns with microsecond precision by default (#214).

## Documentation

- Now referring to the `libmariadb-dev` Debian/Ubuntu package in documentation and configuration scripts (#219).
- `?dbConnect` gains a section on secure passwords and the `.mylogin.cnf` file (#156).

## Internal

- Test MySQL and MariaDB Server and client libraries in all combinations on GitHub Actions (#224).

- The `configure` script now queries the `RMARIADB_FORCE_MARIADBCONFIG` and `RMARIADB_FORCE_MYSQLCONFIG` environment variables to force use of `mariadb_config` or `mysql_config`, respectively (#218).


# RMariaDB 1.1.1 (2021-04-12)

## Bug fixes

- `NULL` is mapped to `NA` for `bit(1)` columns (#201, @dirkschumacher).

## Internal

- Remove BH dependency by inlining the header files (#208).


# RMariaDB 1.1.0 (2021-01-05)

## Features

- `dbConnect()` now supports a `timezone_out` argument. Explicitly setting `timezone` to `NULL` tries to detect the database time zone (#116).
- `BIT(1)` columns are returned as `logical` (#84).
- `dbQuoteLiteral()` now correctly quotes difftime values (#188).

## Bug fixes

- Timestamp values are now written correctly if the database connection uses a time zone other than UTC. Deviations still might occur at DST boundaries, therefore it is still safer to use UTC as the database connection (#116).
- Timestamp roundtrip no longer fails on Windows i386 (#117).
- `dbBind()` also works for `"Date"` values that are stored as integers (#187).


# RMariaDB 1.0.11 (2020-12-16)

## Features

- Windows: update to libmariadbclient 3.1.11
- Add `timezone` argument to `dbConnect()` (#184, @ycphs).
- `dbWriteTable()` and `dbBind()` correctly interpret difftime values with units other than `"secs"`.

## Internal

- `./configure` no longer requires `bash` (@jeroen).
- Switch to GitHub Actions (#185, thanks @ankane).


# RMariaDB 1.0.10 (2020-08-26)

## Features

- `dbConnect()` gains a `timeout` argument, defaults to 10. Use `Inf` or a negative value for no timeout (#169).
- Support fractional seconds in datetime values for reading and writing (#157).


## Bug fixes

- `dbDataType()` returns `VARCHAR(1)` for length-0 character vectors.
- `dbDataType()` returns `VARCHAR()` for factors.
- `dbSendQuery()` and `dbSendStatement()` clear the result set if `dbBind()` throws an error.
- Check that input to `dbWriteTable()` is a data frame (#160, @rossholmberg).


# RMariaDB 1.0.9 (2020-07-03)

- Use `VARCHAR` as data type for string columns (#159).
- Encode column names as UTF-8 (#109).


# RMariaDB 1.0.8 (2019-12-17)

- Implement `dbGetInfo()` according to the specification.
- Include information about `libssl-dev` in `configure` and `DESCRIPTION` (#101).


# RMariaDB 1.0.7 (2019-12-02)

- Get rid of `auto_ptr`, which causes `R CMD check` warnings on R-devel.


# RMariaDB 1.0.6 (2018-05-05)

- Add support for `bigint` argument to `dbConnect()`, supported values are `"integer64"`, `"integer"`, `"numeric"` and `"character"`. Large integers are returned as values of that type (r-dbi/DBItest#133).
- Data frames resulting from a query always have unique non-empty column names (r-dbi/DBItest#137).
- New arguments `temporary` and `fail_if_missing` (default: `TRUE`) to `dbRemoveTable()` (r-dbi/DBI#141, r-dbi/DBI#197).
- Using `dbCreateTable()` and `dbAppendTable()` internally (r-dbi/DBI#74).
- Implement `format()` method for `MariaDBConnection` (r-dbi/DBI#163).
- Reexporting `Id()`, `DBI::dbIsReadOnly()` and `DBI::dbCanConnect()`.
- Now imports DBI 1.0.0.


# RMariaDB 1.0.5 (2018-04-02)

- `dbGetException()` is no longer reexported from DBI.
- `NaN` and `Inf` are converted to `NULL` when writing to the database (#77).
- Values of class `"integer64"` are now supported for `dbWriteTable()` and `dbBind()` (#87).
- Schema support, as specified by DBI: `dbListObjects()`, `dbUnquoteIdentifier()` and `Id()`.
- Names in the `x` argument to `dbQuoteIdentifier()` are preserved in the output (r-lib/DBI#173).
- Replace non-portable `timegm()` with private implementation (#78).
- Update libmariadbclient to version 2.3.5 on Windows (#92, @jeroen).


# RMariaDB 1.0-4 (2017-12-11)

- Attempt to fix Solaris builds by redefining `timegm` symbol if the macro `sun` is defined.
- Fix examples running on CRAN by using only temporary tables and `overwrite = TRUE`.
- Refactor connection and result handling to be more similar to other backends.
- Add support for R 3.1, but DBI >= 0.5 is required (#68).
- Queries that bypass the prepared statement framework (like `SHOW PLUGINS`) return data (#70, @nbenn).
- A temporary table can be created via `dbWriteTable()` if a table by the same name exists. If a temporary table of the same name exists, the error will be raised by the database itself, because this condition cannot be checked beforehand.


# RMariaDB 1.0-2 (2017-10-01)

Initial release, compliant to the DBI specification.

- Test almost all test cases of the DBI specification.
- Fully support parametrized queries (#22, #27, #39).
- Queries not supported by the prepared statement protocol still can be run via `dbExecute()` or `dbSendStatement()`, the function `mariadbExecQuery()` has been removed (#28).
- Spec-compliant transactions (#38, #49).
- 64-bit integers are now supported through the `bit64` package. Unfortunately, this also means that numeric literals (as in `SELECT 1`) are returned as 64-bit integers (#12).
- Correct handling of DATETIME and TIME columns (#52, @noahwilliamsson). Support timestamp values with sub-second precision on output, and with year beyond 2038 (#56).
- The connection now uses the "utf8mb4" charset by default (#7).
- New default `row.names = FALSE`.
- New SSL-related arguments to `dbConnect()`: `ssl.key`, `ssl.cert`, `ssl.ca`, `ssl.capath`, `ssl.cipher` (#131, #148, @adamchainz).
- CI for Linux, Windows, and OS X (#25).
- Support for Connector/C from both MariaDB and MySQL.


# RMariaDB 0.11-1 (2016-03-24)

 *  RMariaDB fully supports DATE and DATETIME columns. On output, DATE columns
    will be converted to vectors of `Date`s and DATETIME will be converted
    to `POSIXct`. To faciliate correct computation of time zone, RMariaDB
    always sets the session timezone to UTC.

 *  RMariaDB has been rewritten (essentially from scratch) in C++ with
    Rcpp. This has considerably reduced the amount of code, and allow us to
    take advantage of the more sophisticated memory management tools available in
    Rcpp. This rewrite should yield some minor performance improvements, but
    most importantly protect against memory leaks and crashes. It also provides
    a better base for future development.

 *  Support for prepared queries: create prepared query with `dbSendQuery()`
    and bind values with `dbBind()`. `dbSendQuery()` and `dbGetQuery()` also
    support inline parameterised queries, like
    `dbGetQuery(mariadbDefault(), "SELECT * FROM mtcars WHERE cyl = :cyl",
    params = list(cyl = 4))`. This has no performance benefits but protects you
    from SQL injection attacks.

 * `dbListFields()` has been removed. Please use `dbColumnInfo()` instead.

 * `dbGetInfo()` has been removed. Please use the individual metadata
    functions.

 *  Information formerly contain in `summary()` methods has now been integrated
    into `show()` methods.

 *  `make.db.names()` has been deprecated. Use `dbQuoteIdentifier()` instead.

 *  `isIdCurrent()` has been deprecated. Use `dbIsValid()` instead.

 *  `dbApply()`, `dbMoreResults()` and `dbNextResults()` have been removed.
    These were always flagged as experimental, and now the experiment is over.

 *  `dbEscapeStrings()` has been deprecated. Please use `dbQuoteStrings()`
    instead.

 *  dbObjectId compatibility shim removed

 *  Add SSL support on Windows.

 *  Fix repetition of strings in subsequent rows (@peternowee, #125).

 *  Always set connection character set to utf-8

 *  Backport build system improvements from stable branch

 *  Reenable Travis-CI, switch to R Travis, collect coverage
