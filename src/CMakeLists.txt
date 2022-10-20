find_file(MYSQL mysql/mysql.h)
get_filename_component(MYSQL_PATH ${MYSQL} DIRECTORY)

find_file(POSTGRESSQL postgresql/plogr.h)
get_filename_component(POSTGRESSQL_PATH ${POSTGRESSQL} DIRECTORY)

add_library(RMariaDB
  connection.cpp
  DbConnection.cpp
  DbConnection.h
  DbResult.cpp
  DbResult.h
  DbResultImplDecl.h
  DbResultImpl.h
  driver.cpp
  integer64.h
  MariaBinding.cpp
  MariaBinding.h
  MariaResult.cpp
  MariaResult.h
  MariaResultImpl.cpp
  MariaResultImpl.h
  MariaResultPrep.cpp
  MariaResultPrep.h
  MariaResultSimple.cpp
  MariaResultSimple.h
  MariaRow.cpp
  MariaRow.h
  MariaTypes.cpp
  MariaTypes.h
  pch.h
  RcppExports.cpp
  result.cpp
  RMariaDB_types.h
)

target_include_directories(RMariaDB PUBLIC
    "/usr/share/R/include"
    "/home/gitpod/R/x86_64-pc-linux-gnu-library/3.6/cpp11/include/"
    "/home/gitpod/R/x86_64-pc-linux-gnu-library/3.6/plogr/include/"
    "/home/gitpod/R/x86_64-pc-linux-gnu-library/3.6/Rcpp/include/"
    ${POSTGRESSQL_PATH}
    ${MYSQL_PATH}
    "vendor"
)

target_compile_definitions(RMariaDB PUBLIC
    "RCPP_DEFAULT_INCLUDE_CALL=false"
    "RCPP_USING_UTF8_ERROR_STRING"
    "BOOST_NO_AUTO_PTR"
)
