DBItest::make_context(
  MariaDB(),
  list(dbname = "test"),
  tweaks = DBItest::tweaks(
    constructor_relax_args = TRUE,
    placeholder_pattern = "?"
  ),
  name = "RMariaDB")
