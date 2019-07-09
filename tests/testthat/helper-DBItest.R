DBItest::make_context(
  MariaDB(),
  list(dbname = "test"),
  tweaks = DBItest::tweaks(
    constructor_relax_args = TRUE,
    placeholder_pattern = "?",
    logical_return = function(x) as.integer(x),
    list_temporary_tables = FALSE
  ),
  name = "RMariaDB",
  default_skip = c(
    # driver
    "get_info_driver",                            # r-dbi/RSQLite#117

    # connection
    "get_info_connection",                        # r-dbi/RSQLite#117

    # result
    "data_logical",                               # not an error: cannot cast to logical
    "data_raw",                                   # not an error: can't cast to blob type

    # meta
    "get_info_result",                            # r-dbi/DBI#55

    NULL
  )
)
