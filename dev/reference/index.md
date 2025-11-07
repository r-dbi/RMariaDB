# Package index

## Connecting and disconnecting

Connecting to and disconnecting from databases.

- [`MariaDB()`](https://rmariadb.r-dbi.org/dev/reference/dbConnect-MariaDBDriver-method.md)
  [`dbConnect(`*`<MariaDBDriver>`*`)`](https://rmariadb.r-dbi.org/dev/reference/dbConnect-MariaDBDriver-method.md)
  : Connect/disconnect to a MariaDB DBMS
- [`Client-flags`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_LONG_PASSWORD`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_FOUND_ROWS`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_LONG_FLAG`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_CONNECT_WITH_DB`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_NO_SCHEMA`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_COMPRESS`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_ODBC`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_LOCAL_FILES`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_IGNORE_SPACE`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_PROTOCOL_41`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_INTERACTIVE`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_SSL`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_IGNORE_SIGPIPE`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_TRANSACTIONS`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_RESERVED`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_RESERVED2`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_MULTI_STATEMENTS`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_MULTI_RESULTS`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  [`CLIENT_SSL_VERIFY_SERVER_CERT`](https://rmariadb.r-dbi.org/dev/reference/Client-flags.md)
  : Client flags
- [`mariadbClientLibraryVersions()`](https://rmariadb.r-dbi.org/dev/reference/mariadbClientLibraryVersions.md)
  : MariaDB Check for Compiled Versus Loaded Client Library Versions
- [`mariadbHasDefault()`](https://rmariadb.r-dbi.org/dev/reference/mariadbHasDefault.md)
  [`mariadbDefault()`](https://rmariadb.r-dbi.org/dev/reference/mariadbHasDefault.md)
  : Check if default database is available.
- [`RMariaDB`](https://rmariadb.r-dbi.org/dev/reference/RMariaDB-package.md)
  [`RMariaDB-package`](https://rmariadb.r-dbi.org/dev/reference/RMariaDB-package.md)
  : RMariaDB: Database Interface and MariaDB Driver

## Tables

Reading and writing entire tables.

- [`dbAppendTable(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbExistsTable(`*`<MariaDBConnection>`*`,`*`<character>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbListObjects(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbListTables(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbReadTable(`*`<MariaDBConnection>`*`,`*`<character>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbRemoveTable(`*`<MariaDBConnection>`*`,`*`<character>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbWriteTable(`*`<MariaDBConnection>`*`,`*`<character>`*`,`*`<character>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  [`dbWriteTable(`*`<MariaDBConnection>`*`,`*`<character>`*`,`*`<data.frame>`*`)`](https://rmariadb.r-dbi.org/dev/reference/mariadb-tables.md)
  : Read and write MariaDB tables.

## Results

More control for sending queries and executing statements.

- [`dbBind(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/query.md)
  [`dbClearResult(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/query.md)
  [`dbFetch(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/query.md)
  [`dbGetStatement(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/query.md)
  [`dbSendQuery(`*`<MariaDBConnection>`*`,`*`<character>`*`)`](https://rmariadb.r-dbi.org/dev/reference/query.md)
  [`dbSendStatement(`*`<MariaDBConnection>`*`,`*`<character>`*`)`](https://rmariadb.r-dbi.org/dev/reference/query.md)
  : Execute a SQL statement on a database connection.
- [`dbColumnInfo(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/result-meta.md)
  [`dbGetRowCount(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/result-meta.md)
  [`dbGetRowsAffected(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/result-meta.md)
  [`dbHasCompleted(`*`<MariaDBResult>`*`)`](https://rmariadb.r-dbi.org/dev/reference/result-meta.md)
  : Database interface meta-data.

## Transactions

Ensuring multiple statements are executed together, or not at all.

- [`dbBegin(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/transactions.md)
  [`dbCommit(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/transactions.md)
  [`dbRollback(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/transactions.md)
  : DBMS Transaction Management

## SQL

Tools for creating and parsing SQL queries.

- [`dbDataType(`*`<MariaDBConnection>`*`)`](https://rmariadb.r-dbi.org/dev/reference/dbDataType.md)
  [`dbDataType(`*`<MariaDBDriver>`*`)`](https://rmariadb.r-dbi.org/dev/reference/dbDataType.md)
  : Determine the SQL Data Type of an S object
