#include "pch.h"
#include "MariaConnection.h"
#include "MariaResult.h"

MariaConnection::MariaConnection(const Nullable<std::string>& host, const Nullable<std::string>& user,
                                 const Nullable<std::string>& password, const Nullable<std::string>& db,
                                 unsigned int port, const Nullable<std::string>& unix_socket, unsigned long client_flag,
                                 const Nullable<std::string>& groups, const Nullable<std::string>& default_file,
                                 const Nullable<std::string>& ssl_key, const Nullable<std::string>& ssl_cert,
                                 const Nullable<std::string>& ssl_ca, const Nullable<std::string>& ssl_capath,
                                 const Nullable<std::string>& ssl_cipher) :
  pCurrentResult_(NULL)
{
  connect(
    host, user, password, db, port, unix_socket, client_flag, groups, default_file,
    ssl_key, ssl_cert, ssl_ca, ssl_capath, ssl_cipher
  );
}

MariaConnection::~MariaConnection() {
  try {
    mysql_close(pConn_);
  } catch (...) {};
}

void MariaConnection::connect(const Nullable<std::string>& host, const Nullable<std::string>& user,
                              const Nullable<std::string>& password, const Nullable<std::string>& db,
                              unsigned int port, const Nullable<std::string>& unix_socket,
                              unsigned long client_flag, const Nullable<std::string>& groups,
                              const Nullable<std::string>& default_file,
                              const Nullable<std::string>& ssl_key, const Nullable<std::string>& ssl_cert,
                              const Nullable<std::string>& ssl_ca, const Nullable<std::string>& ssl_capath,
                              const Nullable<std::string>& ssl_cipher) {
  this->pConn_ = mysql_init(NULL);
  // Enable LOCAL INFILE for fast data ingest
  mysql_options(this->pConn_, MYSQL_OPT_LOCAL_INFILE, 0);
  // Default to UTF-8
  mysql_options(this->pConn_, MYSQL_SET_CHARSET_NAME, "UTF8");
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

  if (!mysql_real_connect(this->pConn_,
                          host.isNull() ? NULL : as<std::string>(host).c_str(),
                          user.isNull() ? NULL : as<std::string>(user).c_str(),
                          password.isNull() ? NULL : as<std::string>(password).c_str(),
                          db.isNull() ? NULL : as<std::string>(db).c_str(),
                          port,
                          unix_socket.isNull() ? NULL : as<std::string>(unix_socket).c_str(),
                          client_flag)) {
    mysql_close(this->pConn_);
    stop("Failed to connect: %s", mysql_error(this->pConn_));
  }
}

List MariaConnection::connectionInfo() {
  return
    List::create(
      _["host"] = std::string(pConn_->host),
      _["user"] = std::string(pConn_->user),
      _["dbname"] = std::string(pConn_->db ? pConn_->db : ""),
      _["conType"] = std::string(mysql_get_host_info(pConn_)),
      _["serverVersion"] = std::string(mysql_get_server_info(pConn_)),
      _["protocolVersion"] = (int) mysql_get_proto_info(pConn_),
      _["threadId"] = (int) mysql_thread_id(pConn_),
      _["client"] = std::string(mysql_get_client_info())
    );
}

MYSQL* MariaConnection::conn() {
  return pConn_;
}

std::string MariaConnection::quoteString(std::string input) {
  // Create buffer with enough room to escape every character
  std::string output;
  output.resize(input.size() * 2 + 1);

  size_t end = mysql_real_escape_string(pConn_, &output[0],
                                        input.data(), input.size());
  output.resize(end);

  return output;
}

void MariaConnection::setCurrentResult(MariaResult* pResult) {
  if (pResult == pCurrentResult_)
    return;

  if (pCurrentResult_ != NULL) {
    if (pResult != NULL)
      warning("Cancelling previous query");

    pCurrentResult_->close();
  }
  pCurrentResult_ = pResult;
}

bool MariaConnection::isCurrentResult(MariaResult* pResult) {
  return pCurrentResult_ == pResult;
}

bool MariaConnection::hasQuery() {
  return pCurrentResult_ != NULL;
}

bool MariaConnection::exec(std::string sql) {
  setCurrentResult(NULL);

  if (mysql_real_query(pConn_, sql.data(), sql.size()) != 0)
    stop(mysql_error(pConn_));

  MYSQL_RES* res = mysql_store_result(pConn_);
  if (res != NULL)
    mysql_free_result(res);

  return true;
}
