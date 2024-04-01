if (rlang::is_installed("DBItest")) DBItest::make_context(
  MariaDB(),
  c(
    mariadb_default_args,
    list(load_data_local_infile = (Sys.getenv("RMARIADB_LOAD_DATA_LOCAL_INFILE") != "") && rlang::is_installed("readr"))
  ),
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

    # Fails on Ubuntu 18.04:
    "list_objects_features",

    # bad tests
    if ((.Platform$OS.type == "windows" && .Platform$r_arch == "i386") || packageVersion("DBItest") < "1.7.2") "append_roundtrip_timestamp",
    if ((.Platform$OS.type == "windows" && .Platform$r_arch == "i386") || packageVersion("DBItest") < "1.7.2") "roundtrip_timestamp",

    NULL
  )
)
