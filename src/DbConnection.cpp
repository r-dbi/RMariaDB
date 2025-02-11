#include "pch.h"
#include "DbConnection.h"
#include "DbResult.h"

DbConnection::DbConnection() :
  pConn_(NULL),
  pCurrentResult_(NULL),
  transacting_(false)
{
  LOG_VERBOSE;
}

DbConnection::~DbConnection() {
  LOG_VERBOSE;

  if (is_valid()) {
    cpp11::warning(std::string("call dbDisconnect() when finished working with a connection"));
    disconnect();
  }
}

void DbConnection::connect(const cpp11::sexp& host, const cpp11::sexp& user,
                           const cpp11::sexp& password, const cpp11::sexp& db,
                           unsigned int port, const cpp11::sexp& unix_socket,
                           unsigned long client_flag, const cpp11::sexp& group,
                           const cpp11::sexp& default_file,
                           const cpp11::sexp& ssl_key, const cpp11::sexp& ssl_cert,
                           const cpp11::sexp& ssl_ca, const cpp11::sexp& ssl_capath,
                           const cpp11::sexp& ssl_cipher,
                           int timeout, bool reconnect) {
  LOG_VERBOSE;

  this->pConn_ = mysql_init(NULL);
  // Enable LOCAL INFILE for fast data ingest
  unsigned int local_infile = 1;
  mysql_options(this->pConn_, MYSQL_OPT_LOCAL_INFILE, &local_infile);
  // Default to UTF-8
  mysql_options(this->pConn_, MYSQL_SET_CHARSET_NAME, "utf8mb4");
  if (!Rf_isNull(group))
    mysql_options(this->pConn_, MYSQL_READ_DEFAULT_GROUP,
                  cpp11::as_cpp<std::string>(group).c_str());
  if (!Rf_isNull(default_file))
    mysql_options(this->pConn_, MYSQL_READ_DEFAULT_FILE,
                  cpp11::as_cpp<std::string>(default_file).c_str());

  // Set SSL options
  if (client_flag & CLIENT_SSL) {
#if MYSQL_VERSION_ID >= 80000 && MYSQL_VERSION_ID < 100000
    // MySQL 8.0 deprecated the enforce SSL flag in prefernce to defining an SSL MODE
    unsigned int ssl_mode_ = SSL_MODE_REQUIRED;
    mysql_options(this->pConn_, MYSQL_OPT_SSL_MODE, &ssl_mode_);
#elif MYSQL_VERSION_ID >= 50700
    my_bool use_ssl_ = 1;
    mysql_options(this->pConn_, MYSQL_OPT_SSL_ENFORCE, &use_ssl_);
#else
    mysql_ssl_set(
      this->pConn_,
      Rf_isNull(ssl_key) ? NULL : cpp11::as_cpp<std::string>(ssl_key).c_str(),
      Rf_isNull(ssl_cert) ? NULL : cpp11::as_cpp<std::string>(ssl_cert).c_str(),
      Rf_isNull(ssl_ca) ? NULL : cpp11::as_cpp<std::string>(ssl_ca).c_str(),
      Rf_isNull(ssl_capath) ? NULL : cpp11::as_cpp<std::string>(ssl_capath).c_str(),
      Rf_isNull(ssl_cipher) ? NULL : cpp11::as_cpp<std::string>(ssl_cipher).c_str()
    );
#endif
    // From MySQL manual: Do not set this option within an application program; it is set internally in the client library.
    // Instead the application program should set mysql_options
    client_flag &= ~CLIENT_SSL;
  }
  if (client_flag & CLIENT_SSL_VERIFY_SERVER_CERT) {
#if MYSQL_VERSION_ID >= 80000 && MYSQL_VERSION_ID < 100000
    // Note: in MySQL 8.0, there is only mode, so we "upgrade" the mode to verify identity.
    // Also, MySQL 8.0 has the ability to just verify the server CA, but our interface doesn't define that.
    // If that is the desired SSL mode, then configure that via a defaults file or group definition.
    unsigned int ssl_mode_ = SSL_MODE_VERIFY_IDENTITY;
    mysql_options(this->pConn_, MYSQL_OPT_SSL_MODE, &ssl_mode_);
#else    
    my_bool verify_server_cert_ = 1;
    mysql_options(this->pConn_, MYSQL_OPT_SSL_VERIFY_SERVER_CERT, (void *)&verify_server_cert_);
#endif
    client_flag &= ~CLIENT_SSL_VERIFY_SERVER_CERT;
  }
#if MYSQL_VERSION_ID >= 50700
  if (!Rf_isNull(ssl_key)) {
    mysql_options(this->pConn_, MYSQL_OPT_SSL_KEY,    cpp11::as_cpp<std::string>(ssl_key).c_str());
  }
  if (!Rf_isNull(ssl_cert)) {
    mysql_options(this->pConn_, MYSQL_OPT_SSL_CERT,   cpp11::as_cpp<std::string>(ssl_cert).c_str());
  }
  if (!Rf_isNull(ssl_ca)) {
    mysql_options(this->pConn_, MYSQL_OPT_SSL_CA,     cpp11::as_cpp<std::string>(ssl_ca).c_str());
  }
  if (!Rf_isNull(ssl_capath)) {
    mysql_options(this->pConn_, MYSQL_OPT_SSL_CAPATH, cpp11::as_cpp<std::string>(ssl_capath).c_str());
  }
  if (!Rf_isNull(ssl_cipher)) {
    mysql_options(this->pConn_, MYSQL_OPT_SSL_CIPHER, cpp11::as_cpp<std::string>(ssl_cipher).c_str());
  }
#endif
  if (timeout > 0) {
    mysql_options(this->pConn_, MYSQL_OPT_CONNECT_TIMEOUT,
                  &timeout);
  }
  if (reconnect) {
    my_bool reconnect_ = 1;
    mysql_options(this->pConn_, MYSQL_OPT_RECONNECT, &reconnect_);
  }

  LOG_VERBOSE;

  if (!mysql_real_connect(this->pConn_,
                          Rf_isNull(host) ? NULL : cpp11::as_cpp<std::string>(host).c_str(),
                          Rf_isNull(user) ? NULL : cpp11::as_cpp<std::string>(user).c_str(),
                          Rf_isNull(password) ? NULL : cpp11::as_cpp<std::string>(password).c_str(),
                          Rf_isNull(db) ? NULL : cpp11::as_cpp<std::string>(db).c_str(),
                          port,
                          Rf_isNull(unix_socket) ? NULL : cpp11::as_cpp<std::string>(unix_socket).c_str(),
                          client_flag)) {
    std::string error = mysql_error(this->pConn_);
    mysql_close(this->pConn_);
    this->pConn_ = NULL;

    cpp11::stop("Failed to connect: %s", error.c_str());
  }
}

void DbConnection::disconnect() {
  if (!is_valid()) return;

  if (has_query()) {
    cpp11::warning(std::string("There is a result object still in use.\n"
      "The connection will be automatically released when it is closed"));
  }

  try {
    mysql_close(get_conn());
  } catch (...) {};

  pConn_ = NULL;
}

bool DbConnection::is_valid() {
  return !!get_conn();
}

void DbConnection::check_connection() {
  if (!is_valid()) {
    cpp11::stop("Invalid or closed connection");
  }
}

cpp11::list DbConnection::info() {
  using namespace cpp11::literals;
  const char *ssl_cipher = mysql_get_ssl_cipher(pConn_);
  return
    cpp11::list({
      "host"_nm = std::string(pConn_->host),
      "port"_nm = (pConn_->port != 0) ? pConn_->port : NA_INTEGER,
      "username"_nm = std::string(pConn_->user),
      "dbname"_nm = std::string(pConn_->db ? pConn_->db : ""),
      "con.type"_nm = std::string(mysql_get_host_info(pConn_)),
      "ssl.cipher"_nm = (ssl_cipher != NULL) ? cpp11::as_sexp(std::string(ssl_cipher)) : R_NilValue,
      "client.version"_nm = std::string(mysql_get_client_info()),
      "client.version.int"_nm = (int) mysql_get_client_version(),
      "db.version"_nm = std::string(mysql_get_server_info(pConn_)),
      "db.version.int"_nm = (int) mysql_get_server_version(pConn_),
      "protocol.version"_nm = (int) mysql_get_proto_info(pConn_),
      "thread.id"_nm = (int) mysql_thread_id(pConn_),
      "client.flag"_nm = pConn_->client_flag,
      "server.capabilities"_nm = pConn_->server_capabilities,
      "status"_nm = (int) pConn_->status
    });
}

MYSQL* DbConnection::get_conn() {
  return pConn_;
}

SEXP DbConnection::quote_string(const cpp11::r_string& input) {
  if (input == NA_STRING)
    return get_null_string();

  const auto input_str = static_cast<std::string>(input);
  const auto input_len = input_str.size();

  // Create buffer with enough room to escape every character
  std::string output = "'";
  output.resize(input_len * 2 + 3);

  size_t end = mysql_real_escape_string(pConn_, &output[1], input_str.c_str(), input_len);

  output.resize(end + 1);
  output.append("'");
  return Rf_mkCharCE(output.c_str(), CE_UTF8);
}

SEXP DbConnection::get_null_string() {
  static auto null = Rf_mkCharCE("NULL", CE_UTF8);
  return null;
}

void DbConnection::set_current_result(DbResult* pResult) {
  if (pResult == pCurrentResult_)
    return;

  if (pCurrentResult_ != NULL) {
    if (pResult != NULL)
      cpp11::warning("Cancelling previous query");

    pCurrentResult_->close();
  }
  pCurrentResult_ = pResult;
}

void DbConnection::reset_current_result(DbResult* pResult) {
  // FIXME: What to do if not current result is reset?
  if (pResult != pCurrentResult_)
    return;

  pCurrentResult_->close();
  pCurrentResult_ = NULL;
}

bool DbConnection::is_current_result(const DbResult* pResult) const {
  return pCurrentResult_ == pResult;
}

bool DbConnection::has_query() {
  return pCurrentResult_ != NULL;
}

bool DbConnection::exec(const std::string& sql) {
  check_connection();

  if (mysql_real_query(pConn_, sql.data(), sql.size()) != 0)
    cpp11::stop("Error executing query: %s", mysql_error(pConn_));

  do {
    MYSQL_RES* res = mysql_store_result(pConn_);
    if (res != NULL)
      mysql_free_result(res);
  } while (mysql_next_result(pConn_) == 0);

  autocommit();

  return true;
}

void DbConnection::begin_transaction() {
  if (is_transacting()) cpp11::stop("Nested transactions not supported.");
  check_connection();

  transacting_ = true;
}

void DbConnection::commit() {
  if (!is_transacting()) cpp11::stop("Call dbBegin() to start a transaction.");
  check_connection();

  mysql_commit(get_conn());
  transacting_ = false;
}

void DbConnection::rollback() {
  if (!is_transacting()) cpp11::stop("Call dbBegin() to start a transaction.");
  check_connection();

  mysql_rollback(get_conn());
  transacting_ = false;
}

bool DbConnection::is_transacting() const {
  return transacting_;
}

void DbConnection::autocommit() {
  if (!is_transacting() && get_conn()) {
    mysql_commit(get_conn());
  }
}
