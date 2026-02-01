# Changelog

## RMariaDB 1.3.4.9006 (2026-01-14)

### Continuous integration

- Fix comment ([\#424](https://github.com/r-dbi/RMariaDB/issues/424)).

- Tweaks ([\#423](https://github.com/r-dbi/RMariaDB/issues/423)).

- Test all R versions on branches that start with cran-
  ([\#422](https://github.com/r-dbi/RMariaDB/issues/422)).

## RMariaDB 1.3.4.9005 (2025-11-17)

### Continuous integration

- Install binaries from r-universe for dev workflow
  ([\#419](https://github.com/r-dbi/RMariaDB/issues/419)).

## RMariaDB 1.3.4.9004 (2025-11-12)

### Continuous integration

- Fix reviewdog and add commenting workflow
  ([\#417](https://github.com/r-dbi/RMariaDB/issues/417)).

## RMariaDB 1.3.4.9003 (2025-11-10)

### Chore

- Auto-update from GitHub Actions
  ([\#411](https://github.com/r-dbi/RMariaDB/issues/411)).

### Continuous integration

- Use workflows for fledge
  ([\#415](https://github.com/r-dbi/RMariaDB/issues/415)).

- Sync ([\#414](https://github.com/r-dbi/RMariaDB/issues/414)).

- Cleanup and fix macOS
  ([\#410](https://github.com/r-dbi/RMariaDB/issues/410)).

- Format with air, check detritus, better handling of `extra-packages`
  ([\#409](https://github.com/r-dbi/RMariaDB/issues/409)).

## RMariaDB 1.3.4.9002 (2025-05-04)

### Continuous integration

- Enhance permissions for workflow
  ([\#406](https://github.com/r-dbi/RMariaDB/issues/406)).

## RMariaDB 1.3.4.9001 (2025-04-30)

### Continuous integration

- Permissions, better tests for missing suggests, lints
  ([\#404](https://github.com/r-dbi/RMariaDB/issues/404)).

- Only fail covr builds if token is given
  ([\#401](https://github.com/r-dbi/RMariaDB/issues/401)).

- Always use `_R_CHECK_FORCE_SUGGESTS_=false`
  ([\#400](https://github.com/r-dbi/RMariaDB/issues/400)).

- Correct installation of xml2
  ([\#397](https://github.com/r-dbi/RMariaDB/issues/397)).

- Explain ([\#395](https://github.com/r-dbi/RMariaDB/issues/395)).

- Add xml2 for covr, print testthat results
  ([\#394](https://github.com/r-dbi/RMariaDB/issues/394)).

- Sync ([\#393](https://github.com/r-dbi/RMariaDB/issues/393)).

## RMariaDB 1.3.4.9000 (2025-02-25)

- Switching to development version.

## RMariaDB 1.3.4 (2025-02-24)

### Windows

- Use mariadbclient from Rtools if available
  ([\#383](https://github.com/r-dbi/RMariaDB/issues/383)).

### Bug fixes

- Adjust datetime format in
  [`dbQuoteLiteral()`](https://dbi.r-dbi.org/reference/dbQuoteLiteral.html)
  for `MySQLConnection` ([@jjaeschke](https://github.com/jjaeschke),
  [\#353](https://github.com/r-dbi/RMariaDB/issues/353)).

## RMariaDB 1.3.3 (2024-11-18)

### Bug fixes

- [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html)
  removes the `def` catalog component again, regression introduced in
  RMariaDB 1.3.1 ([\#337](https://github.com/r-dbi/RMariaDB/issues/337),
  [\#339](https://github.com/r-dbi/RMariaDB/issues/339)).

### Features

- Add back SSL support for MariaDB 5.5.68
  ([@d-hansen](https://github.com/d-hansen),
  [\#336](https://github.com/r-dbi/RMariaDB/issues/336),
  [\#338](https://github.com/r-dbi/RMariaDB/issues/338)).

## RMariaDB 1.3.2 (2024-05-26)

### Features

- Improve enforcement of SSL for
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) and
  the output when printing connections
  ([@d-hansen](https://github.com/d-hansen),
  [\#328](https://github.com/r-dbi/RMariaDB/issues/328)).
- Breaking change: Avoid appending a numeric suffix to duplicate column
  names ([\#321](https://github.com/r-dbi/RMariaDB/issues/321),
  [\#327](https://github.com/r-dbi/RMariaDB/issues/327)).
- Breaking change: Deprecate `dbConnect(groups = )` in favor of
  `dbConnect(group = )`, with a warning and compatibility code
  ([@rorynolan](https://github.com/rorynolan),
  [\#258](https://github.com/r-dbi/RMariaDB/issues/258)).

### Bug fixes

- [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  and
  [`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  on a connection with `load_data_local_infile = TRUE` uses the
  `utf8mb4` instead of the more restricted `utf8mb3` encoding
  ([@ecoffingould](https://github.com/ecoffingould),
  [\#332](https://github.com/r-dbi/RMariaDB/issues/332),
  [\#333](https://github.com/r-dbi/RMariaDB/issues/333)).
- [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) can
  enable SSL based on `client_flag` again
  ([@d-hansen](https://github.com/d-hansen),
  [\#322](https://github.com/r-dbi/RMariaDB/issues/322)).
- Fix
  [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html)
  for [`Id()`](https://dbi.r-dbi.org/reference/Id.html) objects
  ([\#323](https://github.com/r-dbi/RMariaDB/issues/323)).

### Chore

- Improve
  [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html)
  for [`Id()`](https://dbi.r-dbi.org/reference/Id.html) objects
  ([\#324](https://github.com/r-dbi/RMariaDB/issues/324)).
- Avoid deprecated `mysql_ssl_set()`
  ([\#319](https://github.com/r-dbi/RMariaDB/issues/319)).

### Continuous integration

- Turn off Windows for now
  ([\#326](https://github.com/r-dbi/RMariaDB/issues/326)).

### Documentation

- Use dbitemplate ([@maelle](https://github.com/maelle),
  [\#320](https://github.com/r-dbi/RMariaDB/issues/320)).

### Testing

- Test for quoting columns with
  [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html)
  ([@dpprdan](https://github.com/dpprdan),
  [\#254](https://github.com/r-dbi/RMariaDB/issues/254),
  [\#255](https://github.com/r-dbi/RMariaDB/issues/255)).

## RMariaDB 1.3.1 (2023-10-26)

### Features

- Support `dbSendStatement(immediate = TRUE)` and
  `dbExecute(immediate = TRUE)`, needs `CLIENT_MULTI_STATEMENTS`
  ([\#147](https://github.com/r-dbi/RMariaDB/issues/147),
  [\#312](https://github.com/r-dbi/RMariaDB/issues/312)).

### Bug fixes

- Fix memory leak
  ([\#309](https://github.com/r-dbi/RMariaDB/issues/309),
  [\#311](https://github.com/r-dbi/RMariaDB/issues/311)).
- Fix compilation on CentOS 7
  ([\#310](https://github.com/r-dbi/RMariaDB/issues/310)).
- `dbConnection(groups = )` works as documented again, regression
  introduced in RMariaDB 1.3.0 ([@pekkarr](https://github.com/pekkarr),
  [\#306](https://github.com/r-dbi/RMariaDB/issues/306)).

### Documentation

- Update docs for client flags
  ([\#313](https://github.com/r-dbi/RMariaDB/issues/313)).

## RMariaDB 1.3.0 (2023-10-08)

### Features

- Connections now inherit from `"MySQLConnection"` if a MySQL server is
  detected (server version \< 10.0 or server description contains
  `"MariaDB"`). The new `mysql` argument to
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) allows
  overriding the autodetection
  ([\#303](https://github.com/r-dbi/RMariaDB/issues/303)).
- Use string as default for JSON
  ([\#296](https://github.com/r-dbi/RMariaDB/issues/296)) and all
  unknown column types
  ([@LeeMendelowitz](https://github.com/LeeMendelowitz),
  [\#260](https://github.com/r-dbi/RMariaDB/issues/260)).
- Support `TIME` columns with subsecond precision
  ([@renkun-ken](https://github.com/renkun-ken),
  [\#288](https://github.com/r-dbi/RMariaDB/issues/288),
  [\#289](https://github.com/r-dbi/RMariaDB/issues/289)).

### Documentation

- Better `MAX_NO_FIELD_TYPES` error message.

### Chore

- Update Windows libs to new location
  ([\#301](https://github.com/r-dbi/RMariaDB/issues/301)).
- Replace Rcpp by cpp11 ([@Antonov548](https://github.com/Antonov548),
  [\#286](https://github.com/r-dbi/RMariaDB/issues/286)).
- Add decor as a dependency.

### Testing

- Skip tests if packages are not available
  ([\#304](https://github.com/r-dbi/RMariaDB/issues/304)).
- Use testthat edition 3
  ([\#285](https://github.com/r-dbi/RMariaDB/issues/285)).

## RMariaDB 1.2.2 (2022-06-19)

### Features

- [`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  accepts `Id` ([\#262](https://github.com/r-dbi/RMariaDB/issues/262),
  [@renkun-ken](https://github.com/renkun-ken)).

- [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) gains
  `reconnect` argument that sets the `MYSQL_OPT_RECONNECT` option
  ([\#261](https://github.com/r-dbi/RMariaDB/issues/261),
  [@renkun-ken](https://github.com/renkun-ken)).

### Bug fixes

- Actually enable `LOAD LOCAL INFILE` by setting the
  `MYSQL_OPT_LOCAL_INFILE` flag
  ([\#265](https://github.com/r-dbi/RMariaDB/issues/265),
  [\#267](https://github.com/r-dbi/RMariaDB/issues/267)).

## RMariaDB 1.2.1 (2021-12-20)

### Features

- Upgrade to mariadb-connector-c 3.2.5 on Windows, with built-in support
  for the `caching_sha2_password` plugin
  ([\#134](https://github.com/r-dbi/RMariaDB/issues/134),
  [\#248](https://github.com/r-dbi/RMariaDB/issues/248),
  [@jeroen](https://github.com/jeroen)).

### Internal

- Make method definition more similar to S3. All
  [`setMethod()`](https://rdrr.io/r/methods/setMethod.html) calls refer
  to top-level functions
  ([\#250](https://github.com/r-dbi/RMariaDB/issues/250)).

## RMariaDB 1.2.0 (2021-12-12)

### Features

- BLOBs are returned as
  [`blob::blob()`](https://blob.tidyverse.org/reference/blob.html)
  objects ([\#126](https://github.com/r-dbi/RMariaDB/issues/126),
  [\#243](https://github.com/r-dbi/RMariaDB/issues/243)).
- [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  and
  [`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  are much faster thanks to `LOAD DATA LOCAL INFILE`. To activate this,
  `load_data_local_infile = TRUE` must be passed to
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html). The
  readr package is required
  ([\#11](https://github.com/r-dbi/RMariaDB/issues/11),
  [\#223](https://github.com/r-dbi/RMariaDB/issues/223)).

### Bug fixes

- Writing dates prior to 1970 no longer crashes on Windows
  ([\#232](https://github.com/r-dbi/RMariaDB/issues/232),
  [\#245](https://github.com/r-dbi/RMariaDB/issues/245)).

### Internal

- Add test for reading and writing JSON data type as string
  ([\#127](https://github.com/r-dbi/RMariaDB/issues/127),
  [\#246](https://github.com/r-dbi/RMariaDB/issues/246)).
- Update for compatibility with DBItest 1.7.2
  ([\#228](https://github.com/r-dbi/RMariaDB/issues/228)).

## RMariaDB 1.1.2 (2021-09-06)

### Licensing

- RMariaDB is now licensed under the MIT license
  ([\#213](https://github.com/r-dbi/RMariaDB/issues/213)).

### Features

- [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)
  normalizes all input paths
  ([\#197](https://github.com/r-dbi/RMariaDB/issues/197),
  [@twentytitus](https://github.com/twentytitus)).
- [`dbDataType()`](https://rmariadb.r-dbi.org/dev/reference/dbDataType.md)
  returns `TIME(6)` for `difftime`, and `DATETIME(6)` for `POSIXt`
  columns, to create columns with microsecond precision by default
  ([\#214](https://github.com/r-dbi/RMariaDB/issues/214)).

### Documentation

- Now referring to the `libmariadb-dev` Debian/Ubuntu package in
  documentation and configuration scripts
  ([\#219](https://github.com/r-dbi/RMariaDB/issues/219)).
- [`?dbConnect`](https://dbi.r-dbi.org/reference/dbConnect.html) gains a
  section on secure passwords and the `.mylogin.cnf` file
  ([\#156](https://github.com/r-dbi/RMariaDB/issues/156)).

### Internal

- Test MySQL and MariaDB Server and client libraries in all combinations
  on GitHub Actions
  ([\#224](https://github.com/r-dbi/RMariaDB/issues/224)).

- The `configure` script now queries the `RMARIADB_FORCE_MARIADBCONFIG`
  and `RMARIADB_FORCE_MYSQLCONFIG` environment variables to force use of
  `mariadb_config` or `mysql_config`, respectively
  ([\#218](https://github.com/r-dbi/RMariaDB/issues/218)).

## RMariaDB 1.1.1 (2021-04-12)

### Bug fixes

- `NULL` is mapped to `NA` for `bit(1)` columns
  ([\#201](https://github.com/r-dbi/RMariaDB/issues/201),
  [@dirkschumacher](https://github.com/dirkschumacher)).

### Internal

- Remove BH dependency by inlining the header files
  ([\#208](https://github.com/r-dbi/RMariaDB/issues/208)).

## RMariaDB 1.1.0 (2021-01-05)

### Features

- [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) now
  supports a `timezone_out` argument. Explicitly setting `timezone` to
  `NULL` tries to detect the database time zone
  ([\#116](https://github.com/r-dbi/RMariaDB/issues/116)).
- `BIT(1)` columns are returned as `logical`
  ([\#84](https://github.com/r-dbi/RMariaDB/issues/84)).
- [`dbQuoteLiteral()`](https://dbi.r-dbi.org/reference/dbQuoteLiteral.html)
  now correctly quotes difftime values
  ([\#188](https://github.com/r-dbi/RMariaDB/issues/188)).

### Bug fixes

- Timestamp values are now written correctly if the database connection
  uses a time zone other than UTC. Deviations still might occur at DST
  boundaries, therefore it is still safer to use UTC as the database
  connection ([\#116](https://github.com/r-dbi/RMariaDB/issues/116)).
- Timestamp roundtrip no longer fails on Windows i386
  ([\#117](https://github.com/r-dbi/RMariaDB/issues/117)).
- [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html) also works
  for `"Date"` values that are stored as integers
  ([\#187](https://github.com/r-dbi/RMariaDB/issues/187)).

## RMariaDB 1.0.11 (2020-12-16)

### Features

- Windows: update to libmariadbclient 3.1.11
- Add `timezone` argument to
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)
  ([\#184](https://github.com/r-dbi/RMariaDB/issues/184),
  [@ycphs](https://github.com/ycphs)).
- [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  and [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html)
  correctly interpret difftime values with units other than `"secs"`.

### Internal

- `./configure` no longer requires `bash`
  ([@jeroen](https://github.com/jeroen)).
- Switch to GitHub Actions
  ([\#185](https://github.com/r-dbi/RMariaDB/issues/185), thanks
  [@ankane](https://github.com/ankane)).

## RMariaDB 1.0.10 (2020-08-26)

### Features

- [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) gains
  a `timeout` argument, defaults to 10. Use `Inf` or a negative value
  for no timeout
  ([\#169](https://github.com/r-dbi/RMariaDB/issues/169)).
- Support fractional seconds in datetime values for reading and writing
  ([\#157](https://github.com/r-dbi/RMariaDB/issues/157)).

### Bug fixes

- [`dbDataType()`](https://rmariadb.r-dbi.org/dev/reference/dbDataType.md)
  returns `VARCHAR(1)` for length-0 character vectors.
- [`dbDataType()`](https://rmariadb.r-dbi.org/dev/reference/dbDataType.md)
  returns `VARCHAR()` for factors.
- [`dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html)
  and
  [`dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html)
  clear the result set if
  [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html) throws an
  error.
- Check that input to
  [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  is a data frame
  ([\#160](https://github.com/r-dbi/RMariaDB/issues/160),
  [@rossholmberg](https://github.com/rossholmberg)).

## RMariaDB 1.0.9 (2020-07-03)

- Use `VARCHAR` as data type for string columns
  ([\#159](https://github.com/r-dbi/RMariaDB/issues/159)).
- Encode column names as UTF-8
  ([\#109](https://github.com/r-dbi/RMariaDB/issues/109)).

## RMariaDB 1.0.8 (2019-12-17)

- Implement
  [`dbGetInfo()`](https://dbi.r-dbi.org/reference/dbGetInfo.html)
  according to the specification.
- Include information about `libssl-dev` in `configure` and
  `DESCRIPTION` ([\#101](https://github.com/r-dbi/RMariaDB/issues/101)).

## RMariaDB 1.0.7 (2019-12-02)

- Get rid of `auto_ptr`, which causes `R CMD check` warnings on R-devel.

## RMariaDB 1.0.6 (2018-05-05)

- Add support for `bigint` argument to
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html),
  supported values are `"integer64"`, `"integer"`, `"numeric"` and
  `"character"`. Large integers are returned as values of that type
  (r-dbi/DBItest#133).
- Data frames resulting from a query always have unique non-empty column
  names (r-dbi/DBItest#137).
- New arguments `temporary` and `fail_if_missing` (default: `TRUE`) to
  [`dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html)
  (r-dbi/DBI#141, r-dbi/DBI#197).
- Using
  [`dbCreateTable()`](https://dbi.r-dbi.org/reference/dbCreateTable.html)
  and
  [`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  internally (r-dbi/DBI#74).
- Implement [`format()`](https://rdrr.io/r/base/format.html) method for
  `MariaDBConnection` (r-dbi/DBI#163).
- Reexporting [`Id()`](https://dbi.r-dbi.org/reference/Id.html),
  [`DBI::dbIsReadOnly()`](https://dbi.r-dbi.org/reference/dbIsReadOnly.html)
  and
  [`DBI::dbCanConnect()`](https://dbi.r-dbi.org/reference/dbCanConnect.html).
- Now imports DBI 1.0.0.

## RMariaDB 1.0.5 (2018-04-02)

- [`dbGetException()`](https://dbi.r-dbi.org/reference/dbGetException.html)
  is no longer reexported from DBI.
- `NaN` and `Inf` are converted to `NULL` when writing to the database
  ([\#77](https://github.com/r-dbi/RMariaDB/issues/77)).
- Values of class `"integer64"` are now supported for
  [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  and [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html)
  ([\#87](https://github.com/r-dbi/RMariaDB/issues/87)).
- Schema support, as specified by DBI:
  [`dbListObjects()`](https://dbi.r-dbi.org/reference/dbListObjects.html),
  [`dbUnquoteIdentifier()`](https://dbi.r-dbi.org/reference/dbUnquoteIdentifier.html)
  and [`Id()`](https://dbi.r-dbi.org/reference/Id.html).
- Names in the `x` argument to
  [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html)
  are preserved in the output (r-lib/DBI#173).
- Replace non-portable `timegm()` with private implementation
  ([\#78](https://github.com/r-dbi/RMariaDB/issues/78)).
- Update libmariadbclient to version 2.3.5 on Windows
  ([\#92](https://github.com/r-dbi/RMariaDB/issues/92),
  [@jeroen](https://github.com/jeroen)).

## RMariaDB 1.0-4 (2017-12-11)

- Attempt to fix Solaris builds by redefining `timegm` symbol if the
  macro `sun` is defined.
- Fix examples running on CRAN by using only temporary tables and
  `overwrite = TRUE`.
- Refactor connection and result handling to be more similar to other
  backends.
- Add support for R 3.1, but DBI \>= 0.5 is required
  ([\#68](https://github.com/r-dbi/RMariaDB/issues/68)).
- Queries that bypass the prepared statement framework (like
  `SHOW PLUGINS`) return data
  ([\#70](https://github.com/r-dbi/RMariaDB/issues/70),
  [@nbenn](https://github.com/nbenn)).
- A temporary table can be created via
  [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  if a table by the same name exists. If a temporary table of the same
  name exists, the error will be raised by the database itself, because
  this condition cannot be checked beforehand.

## RMariaDB 1.0-2 (2017-10-01)

Initial release, compliant to the DBI specification.

- Test almost all test cases of the DBI specification.
- Fully support parametrized queries
  ([\#22](https://github.com/r-dbi/RMariaDB/issues/22),
  [\#27](https://github.com/r-dbi/RMariaDB/issues/27),
  [\#39](https://github.com/r-dbi/RMariaDB/issues/39)).
- Queries not supported by the prepared statement protocol still can be
  run via
  [`dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html) or
  [`dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html),
  the function `mariadbExecQuery()` has been removed
  ([\#28](https://github.com/r-dbi/RMariaDB/issues/28)).
- Spec-compliant transactions
  ([\#38](https://github.com/r-dbi/RMariaDB/issues/38),
  [\#49](https://github.com/r-dbi/RMariaDB/issues/49)).
- 64-bit integers are now supported through the `bit64` package.
  Unfortunately, this also means that numeric literals (as in
  `SELECT 1`) are returned as 64-bit integers
  ([\#12](https://github.com/r-dbi/RMariaDB/issues/12)).
- Correct handling of DATETIME and TIME columns
  ([\#52](https://github.com/r-dbi/RMariaDB/issues/52),
  [@noahwilliamsson](https://github.com/noahwilliamsson)). Support
  timestamp values with sub-second precision on output, and with year
  beyond 2038 ([\#56](https://github.com/r-dbi/RMariaDB/issues/56)).
- The connection now uses the “utf8mb4” charset by default
  ([\#7](https://github.com/r-dbi/RMariaDB/issues/7)).
- New default `row.names = FALSE`.
- New SSL-related arguments to
  [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html):
  `ssl.key`, `ssl.cert`, `ssl.ca`, `ssl.capath`, `ssl.cipher`
  ([\#131](https://github.com/r-dbi/RMariaDB/issues/131),
  [\#148](https://github.com/r-dbi/RMariaDB/issues/148),
  [@adamchainz](https://github.com/adamchainz)).
- CI for Linux, Windows, and OS X
  ([\#25](https://github.com/r-dbi/RMariaDB/issues/25)).
- Support for Connector/C from both MariaDB and MySQL.

## RMariaDB 0.11-1 (2016-03-24)

- RMariaDB fully supports DATE and DATETIME columns. On output, DATE
  columns will be converted to vectors of `Date`s and DATETIME will be
  converted to `POSIXct`. To faciliate correct computation of time zone,
  RMariaDB always sets the session timezone to UTC.

- RMariaDB has been rewritten (essentially from scratch) in C++ with
  Rcpp. This has considerably reduced the amount of code, and allow us
  to take advantage of the more sophisticated memory management tools
  available in Rcpp. This rewrite should yield some minor performance
  improvements, but most importantly protect against memory leaks and
  crashes. It also provides a better base for future development.

- Support for prepared queries: create prepared query with
  [`dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html)
  and bind values with
  [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html).
  [`dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html)
  and [`dbGetQuery()`](https://dbi.r-dbi.org/reference/dbGetQuery.html)
  also support inline parameterised queries, like
  `dbGetQuery(mariadbDefault(), "SELECT * FROM mtcars WHERE cyl = :cyl", params = list(cyl = 4))`.
  This has no performance benefits but protects you from SQL injection
  attacks.

- [`dbListFields()`](https://dbi.r-dbi.org/reference/dbListFields.html)
  has been removed. Please use
  [`dbColumnInfo()`](https://dbi.r-dbi.org/reference/dbColumnInfo.html)
  instead.

- [`dbGetInfo()`](https://dbi.r-dbi.org/reference/dbGetInfo.html) has
  been removed. Please use the individual metadata functions.

- Information formerly contain in
  [`summary()`](https://rdrr.io/r/base/summary.html) methods has now
  been integrated into [`show()`](https://rdrr.io/r/methods/show.html)
  methods.

- [`make.db.names()`](https://dbi.r-dbi.org/reference/make.db.names.html)
  has been deprecated. Use
  [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html)
  instead.

- `isIdCurrent()` has been deprecated. Use
  [`dbIsValid()`](https://dbi.r-dbi.org/reference/dbIsValid.html)
  instead.

- `dbApply()`, `dbMoreResults()` and `dbNextResults()` have been
  removed. These were always flagged as experimental, and now the
  experiment is over.

- `dbEscapeStrings()` has been deprecated. Please use `dbQuoteStrings()`
  instead.

- dbObjectId compatibility shim removed

- Add SSL support on Windows.

- Fix repetition of strings in subsequent rows
  ([@peternowee](https://github.com/peternowee),
  [\#125](https://github.com/r-dbi/RMariaDB/issues/125)).

- Always set connection character set to utf-8

- Backport build system improvements from stable branch

- Reenable Travis-CI, switch to R Travis, collect coverage
