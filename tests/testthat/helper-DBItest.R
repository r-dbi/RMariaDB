if (rlang::is_installed("DBItest")) DBItest::make_context(
  MariaDB(),
  c(
    mariadb_default_args,
    list(load_data_local_infile = (Sys.getenv("RMARIADB_LOAD_DATA_LOCAL_INFILE") != "") && rlang::is_installed("readr"))
  ),
  tweaks = DBItest::tweaks(
    dbitest_version = "1.8.3.6",
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

    # Enabled by dbitest_version = "1.8.3.6", not yet supported:
    "fetch_na_rows",                              # dbFetch(n = NA) errors
    "reexport",                                   # the Arrow generics are not reexported from DBI
    # The default dbCreateTableArrow() creates zero-width character columns:
    # "Data too long for column"
    "arrow_write_table_arrow_overwrite",
    "arrow_write_table_arrow_overwrite_missing",
    "arrow_write_table_arrow_append",
    "arrow_write_table_arrow_append_new",
    "arrow_write_table_arrow_temporary_1",
    "arrow_write_table_arrow_visible_in_other_connection_[123]",
    "arrow_(write|append)_table_arrow_roundtrip_(keywords|quotes|character|character_native|factor)",
    # nanoarrow warns about loss of precision in the conversion to double()
    "arrow_(write|append)_table_arrow_roundtrip_timestamp_extended",

    NULL
  )
)
