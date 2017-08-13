DBItest::test_all(c(
  # driver
  "get_info_driver",                            # rstats-db/RSQLite#117

  # connection
  "get_info_connection",                        # rstats-db/RSQLite#117

  # result
  "fetch_no_return_value",                      #
  "data_logical",                               # not an error: cannot cast to logical
  "data_raw",                                   # not an error: can't cast to blob type
  "data_character",                             # failing on Windows
  "data_64_bit_.*",                             # #12

  # sql
  "list_tables",                                #
  "append_table_new",                           #
  "roundtrip_timestamp",                        #
  "roundtrip_64_bit_character",                 # rstats-db/DBI#48
  "roundtrip_raw",                              # #1
  "roundtrip_blob",                             # #1
  "read_table_error",                           #
  "read_table_name",                            #
  "write_table_error",                          #
  "write_table_name",                           #
  "exists_table_error",                         #
  "exists_table_name",                          #
  "remove_table_name",                          #
  "remove_table_temporary",                     #

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
  "bind_logical.*",                             # not an error: no logical data type
  "bind_timestamp_lt.*",                        # #22
  "bind_raw.*",                                 # #22
  "bind_factor",                                #
  "bind_blob",                                  #
  "bind_timestamp",                             #
  "bind_.*_named_.*",                           # not an error: named binding not supported
  "bind_named_param_unnamed_placeholders",      #
  "bind_named_param_empty_placeholders",        #
  "bind_named_param_na_placeholders",           #
  "bind_repeated.*",                            #
  "list_fields_row_names",                      #
  "row_count_statement",                        #
  "rows_affected_statement",                    #

  # transactions
  "commit_without_begin",                       # 38
  "rollback_without_begin",                     # 38
  "begin_begin",                                # 38
  "begin_write_rollback",                       #
  "begin_write_disconnect",                     #
  "begin_commit_return_value",                  #
  "begin_rollback_return_value",                #
  "with_transaction_.*",                        #

  # compliance
  "compliance",                                 # #23
  "ellipsis",                                   # requires DBItest > 1.5-11

  NULL
))
