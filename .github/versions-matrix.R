# The Linux combos run on ubuntu-26.04, in line with the workflow template.
#
# "MySQL server, MariaDB client" is gone: on Ubuntu 26.04 the `mysql-server`
# package declares `Conflicts: mariadb-common`, and `mariadb-common` is pulled
# in by `libmariadb-dev`, so a MySQL server and a MariaDB client cannot be
# installed side by side anymore.
mysql_combos <- data.frame(
  os = c("macos-latest", "macos-latest", "ubuntu-26.04", "ubuntu-26.04", "ubuntu-26.04"),
  r = "release",
  mysql_client = c("false", "true", "true", "true", "false"),
  RMARIADB_FORCE_MARIADBCONFIG = c(1, NA, NA, NA, NA),
  RMARIADB_FORCE_MYSQLCONFIG = c(NA, 1, NA, NA, NA),
  mysql_server = c(NA, NA, "true", "false", "false"),
  desc = c("mariadb_config", "mysql_config", "MySQL server", "MariaDB server, MySQL client", "MariaDB server + client")
)
windows_versions <- data.frame(os = "windows-latest", r = r_versions[4:5])
list(mysql_combos, windows_versions)
