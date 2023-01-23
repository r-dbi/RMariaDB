#include "pch.h"

#if defined(MYSQL_SERVER_VERSION)
#define SERVER_VERSION MYSQL_SERVER_VERSION
#elif defined(MARIADB_CLIENT_VERSION_STR)
#define SERVER_VERSION MARIADB_CLIENT_VERSION_STR
#else
#define SERVER_VERSION "<unknown server version>"
#endif


[[cpp11::register]]
void driver_init() {
  mysql_library_init(0, NULL, NULL);
}

[[cpp11::register]]
void driver_done() {
  mysql_library_end();
}

[[cpp11::register]]
cpp11::integers version() {
  return
    cpp11::writable::integers({
      cpp11::named_arg(SERVER_VERSION) = MYSQL_VERSION_ID,
      cpp11::named_arg(mysql_get_client_info()) = mysql_get_client_version()
    });
}

[[cpp11::register]]
void init_logging(const std::string& log_level) {
  plog::init_r(log_level);
}
