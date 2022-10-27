find_file(MYSQL mysql/mysql.h)
get_filename_component(MYSQL_PATH ${MYSQL} DIRECTORY)

find_file(POSTGRESSQL postgresql/plogr.h)
get_filename_component(POSTGRESSQL_PATH ${POSTGRESSQL} DIRECTORY)

target_include_directories(RMariaDB PUBLIC
    ${POSTGRESSQL_PATH}
    ${MYSQL_PATH}
    "vendor"
)

target_compile_definitions(RMariaDB PUBLIC
    "RCPP_DEFAULT_INCLUDE_CALL=false"
    "RCPP_USING_UTF8_ERROR_STRING"
    "BOOST_NO_AUTO_PTR"
)
