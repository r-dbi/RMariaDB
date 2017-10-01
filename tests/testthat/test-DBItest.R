if (identical(Sys.getenv("NOT_CRAN"), "true")) {

DBItest::test_all(c(
  # driver
  "get_info_driver",                            # rstats-db/RSQLite#117

  # connection
  "get_info_connection",                        # rstats-db/RSQLite#117

  # result
  "data_logical",                               # not an error: cannot cast to logical
  "data_raw",                                   # not an error: can't cast to blob type

  # meta
  "get_info_result",                            # rstats-db/DBI#55

  NULL
))

}
