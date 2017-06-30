DBItest::make_context(
  MariaDB(),
  list(dbname = "test", username = "", password = ""),
  tweaks = DBItest::tweaks(
    constructor_relax_args = TRUE,
    placeholder_pattern = "?"
  ),
  name = "RMariaDB")
