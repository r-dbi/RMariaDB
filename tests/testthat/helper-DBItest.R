DBItest::make_context(
  MariaDB(),
  list(dbname = "test"),
  tweaks = DBItest::tweaks(
    dbitest_version = "1.7.2",
    constructor_relax_args = TRUE,
    placeholder_pattern = "?",
    logical_return = function(x) as.integer(x),
    list_temporary_tables = FALSE
  ),
  name = "RMariaDB",
  default_skip = c(
    # result
    "data_logical",                               # not an error: cannot cast to logical
    "data_raw",                                   # not an error: can't cast to blob type

    # bad tests
    "list_objects_features",

    NULL
  )
)
