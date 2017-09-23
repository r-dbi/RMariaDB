DBItest::test_all(c(
  # driver
  "get_info_driver",                            # rstats-db/RSQLite#117

  # connection
  "get_info_connection",                        # rstats-db/RSQLite#117

  # result
  "data_logical",                               # not an error: cannot cast to logical
  "data_raw",                                   # not an error: can't cast to blob type

  # sql
  "read_table_error",                           #
  "read_table_name",                            #
  "write_table_error",                          #
  "write_table_name",                           #
  "exists_table_error",                         #

  # meta
  "get_statement_error",                        #
  "get_info_result",                            # rstats-db/DBI#55
  "exists_table_closed_connection",             #
  "exists_table_invalid_connection",            #
  "list_fields_row_names",                      #

  # compliance
  "compliance",                                 # #23

  NULL
))
