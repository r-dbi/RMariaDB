find_file(MYSQL mysql/mysql.h)
get_filename_component(MYSQL_PATH ${MYSQL} DIRECTORY)

execute_process(COMMAND bash "-c" "Rscript -e 'cat(R.home(\"include\"))'" OUTPUT_VARIABLE R_INCLUDE)
execute_process(COMMAND bash "-c" "Rscript -e 'cat(.libPaths()[[1]])'" OUTPUT_VARIABLE R_LIBRARIES_INCLUDE)

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
    ${R_INCLUDE}
    ${R_LIBRARIES_INCLUDE}/plogr/include
    ${R_LIBRARIES_INCLUDE}/Rcpp/include
    ${MYSQL_PATH}
    "vendor"
)

target_compile_definitions(RMariaDB PUBLIC
    "RCPP_DEFAULT_INCLUDE_CALL=false"
    "RCPP_USING_UTF8_ERROR_STRING"
    "BOOST_NO_AUTO_PTR"
)
