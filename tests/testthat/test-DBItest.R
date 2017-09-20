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
  "rows_affected_query",                        #
  "get_statement_error",                        #
  "get_info_result",                            # rstats-db/DBI#55
  "exists_table_closed_connection",             #
  "exists_table_invalid_connection",            #
  "bind_empty.*",                               # #27
  "bind_return_value.*",                        # #27
  "bind_wrong_name",                            #
  "bind_multi_row.*",                           # #39
  "bind_logical.*",                             #
  "bind_timestamp_lt.*",                        # #22
  "bind_factor",                                #
  "bind_timestamp",                             #
  "bind_.*_named_.*",                           # not an error: named binding not supported
  "bind_named_param_unnamed_placeholders",      #
  "bind_named_param_empty_placeholders",        #
  "bind_named_param_na_placeholders",           #
  "bind_repeated.*",                            #
  "list_fields_row_names",                      #
  "row_count_statement",                        #
  "rows_affected_statement",                    #

  # compliance
  "compliance",                                 # #23

  NULL
))
