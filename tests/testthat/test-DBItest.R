DBItest::test_all(c(
  # driver
  "get_info_driver",                            # rstats-db/RSQLite#117

  # connection
  "get_info_connection",                        # rstats-db/RSQLite#117
  "cannot_forget_disconnect",                   #

  # result
  "cannot_clear_result_twice_.*",               #
  "fetch_n_bad",                                #
  "fetch_n_good_after_bad",                     #
  "fetch_no_return_value",                      #
  "get_query_n_.*",                             #
  "data_logical",                               # not an error: no logical data type
  "data_64_bit_.*",                             # #77
  "data_character",                             # #93
  "data_raw",                                   # not an error: can't cast to blob type
  "data_date_typed",                            #
  "data_time",                                  # #95
  "data_timestamp",                             # #113
  "data_timestamp_current",                     # #113
  "data_timestamp_current_typed",               # #113

  # sql
  "quote_string.*",                             # #115
  "quote_identifier_vectorized",                #
  "list_fields",                                # #137
  "list_tables",                                #
  "append_table_new",                           #
  "roundtrip_quotes",                           # #101
  "roundtrip_keywords",                         #
  "roundtrip_logical",                          #
  "roundtrip_64_bit_character",                 # rstats-db/DBI#48
  "roundtrip_character",                        # #93
  "roundtrip_character_native",                 # #93
  "roundtrip_factor",                           # #93
  "roundtrip_date",                             #
  "roundtrip_time",                             #
  "roundtrip_raw",                              # #111
  "roundtrip_blob",                             # #111
  "roundtrip_timestamp",                        # #104
  "roundtrip_field_types",                      #
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
  "bind_empty.*",                               # #116
  "bind_return_value.*",                        # #116
  "bind_wrong_name",                            #
  "bind_multi_row.*",                           # #170
  "bind_logical.*",                             # not an error: no logical data type
  "bind_character.*",                           # #93
  "bind_timestamp_lt.*",                        # #110
  "bind_raw.*",                                 # #110
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
  "commit_without_begin",                       # 167
  "rollback_without_begin",                     # 167
  "begin_begin",                                # 167
  "begin_write_rollback",                       #
  "begin_write_disconnect",                     #
  "with_transaction_.*",                        #

  # compliance
  "compliance",                                 # #112
  "ellipsis",                                   # #171

  # visibility
  "can_disconnect",
  "write_table_return",
  "remove_table_return",
  "begin_commit_return_value",
  "begin_rollback_return_value",
  "clear_result_return_.*",

  NULL
))
