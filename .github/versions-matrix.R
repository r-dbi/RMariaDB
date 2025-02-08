macos_combos <- data.frame(
  os = c("macos-latest", "macos-latest", "ubuntu-22.04", "ubuntu-22.04", "ubuntu-22.04", "ubuntu-22.04"),
  r = "release",
  mysql_client = c("false", "true", "true", "true", "false", "false"),
  RMARIADB_FORCE_MARIADBCONFIG = c(1, NA, NA, NA, NA, NA),
  RMARIADB_FORCE_MYSQLCONFIG = c(NA, 1, NA, NA, NA, NA),
  mysql_server = c(NA, NA, "true", "false", "true", "false"),
  desc = c("mariadb_config", "mysql_config", "MySQL server", "MariaDB server, MySQL client", "MySQL server, MariaDB client", "MariaDB server + client")
)
windows_versions <- data.frame(os = "windows-latest", r = r_versions[4:5])
rbind(macos_combos, windows_versions)
