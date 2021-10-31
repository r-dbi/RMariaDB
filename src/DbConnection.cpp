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
    warning("call dbDisconnect() when finished working with a connection");
    disconnect();
  }
}

void DbConnection::connect(const Nullable<std::string>& host, const Nullable<std::string>& user,
                           const Nullable<std::string>& password, const Nullable<std::string>& db,
                           unsigned int port, const Nullable<std::string>& unix_socket,
                           unsigned long client_flag, const Nullable<std::string>& groups,
                           const Nullable<std::string>& default_file,
                           const Nullable<std::string>& ssl_key, const Nullable<std::string>& ssl_cert,
                           const Nullable<std::string>& ssl_ca, const Nullable<std::string>& ssl_capath,
                           const Nullable<std::string>& ssl_cipher,
                           int timeout) {
  LOG_VERBOSE;

  this->pConn_ = mysql_init(NULL);
  // Enable LOCAL INFILE for fast data ingest
  mysql_options(this->pConn_, MYSQL_OPT_LOCAL_INFILE, 0);
  // Default to UTF-8
  mysql_options(this->pConn_, MYSQL_SET_CHARSET_NAME, "utf8mb4");
  if (!groups.isNull())
    mysql_options(this->pConn_, MYSQL_READ_DEFAULT_GROUP,
                  as<std::string>(groups).c_str());
  if (!default_file.isNull())
    mysql_options(this->pConn_, MYSQL_READ_DEFAULT_FILE,
                  as<std::string>(default_file).c_str());

  if (!ssl_key.isNull() || !ssl_cert.isNull() || !ssl_ca.isNull() ||
      !ssl_capath.isNull() || !ssl_cipher.isNull()) {
    mysql_ssl_set(
      this->pConn_,
      ssl_key.isNull() ? NULL : as<std::string>(ssl_key).c_str(),
      ssl_cert.isNull() ? NULL : as<std::string>(ssl_cert).c_str(),
      ssl_ca.isNull() ? NULL : as<std::string>(ssl_ca).c_str(),
      ssl_capath.isNull() ? NULL : as<std::string>(ssl_capath).c_str(),
      ssl_cipher.isNull() ? NULL : as<std::string>(ssl_cipher).c_str()
    );
  }
  if (timeout > 0) {
    mysql_options(this->pConn_, MYSQL_OPT_CONNECT_TIMEOUT,
                  &timeout);
  }

  LOG_VERBOSE;

  if (!mysql_real_connect(this->pConn_,
                          host.isNull() ? NULL : as<std::string>(host).c_str(),
                          user.isNull() ? NULL : as<std::string>(user).c_str(),
                          password.isNull() ? NULL : as<std::string>(password).c_str(),
                          db.isNull() ? NULL : as<std::string>(db).c_str(),
                          port,
                          unix_socket.isNull() ? NULL : as<std::string>(unix_socket).c_str(),
                          client_flag)) {
    std::string error = mysql_error(this->pConn_);
    mysql_close(this->pConn_);
    this->pConn_ = NULL;

    stop("Failed to connect: %s", error.c_str());
  }
}

void DbConnection::disconnect() {
  if (!is_valid()) return;

  if (has_query()) {
    warning(
      "%s\n%s",
      "There is a result object still in use.",
      "The connection will be automatically released when it is closed"
    );
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
    stop("Invalid or closed connection");
  }
}

List DbConnection::info() {
  return
    List::create(
      _["host"] = std::string(pConn_->host),
      _["username"] = std::string(pConn_->user),
      _["dbname"] = std::string(pConn_->db ? pConn_->db : ""),
      _["con.type"] = std::string(mysql_get_host_info(pConn_)),
      _["db.version"] = std::string(mysql_get_server_info(pConn_)),
      _["port"] = NA_INTEGER,
      _["protocol.version"] = (int) mysql_get_proto_info(pConn_),
      _["thread.id"] = (int) mysql_thread_id(pConn_)
    );
}

MYSQL* DbConnection::get_conn() {
  return pConn_;
}

SEXP DbConnection::quote_string(const String& input) {
  if (input == NA_STRING)
    return get_null_string();

  const char* input_cstr = input.get_cstring();
  size_t input_len = strlen(input_cstr);

  // Create buffer with enough room to escape every character
  std::string output = "'";
  output.resize(input_len * 2 + 3);

  size_t end = mysql_real_escape_string(pConn_, &output[1], input_cstr, input_len);

  output.resize(end + 1);
  output.append("'");
  return Rf_mkCharCE(output.c_str(), CE_UTF8);
}

SEXP DbConnection::get_null_string() {
  static RObject null = Rf_mkCharCE("NULL", CE_UTF8);
  return null;
}

void DbConnection::set_current_result(DbResult* pResult) {
  if (pResult == pCurrentResult_)
    return;

  if (pCurrentResult_ != NULL) {
    if (pResult != NULL)
      warning("Cancelling previous query");

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

bool DbConnection::exec(std::string sql) {
  check_connection();

  if (mysql_real_query(pConn_, sql.data(), sql.size()) != 0)
    stop("Error executing query: %s", mysql_error(pConn_));

  MYSQL_RES* res = mysql_store_result(pConn_);
  if (res != NULL)
    mysql_free_result(res);

  autocommit();

  return true;
}

void DbConnection::begin_transaction() {
  if (is_transacting()) stop("Nested transactions not supported.");
  check_connection();

  transacting_ = true;
}

void DbConnection::commit() {
  if (!is_transacting()) stop("Call dbBegin() to start a transaction.");
  check_connection();

  mysql_commit(get_conn());
  transacting_ = false;
}

void DbConnection::rollback() {
  if (!is_transacting()) stop("Call dbBegin() to start a transaction.");
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
