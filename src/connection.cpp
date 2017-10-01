#include "pch.h"
#include "RMariaDB_types.h"

// [[Rcpp::export]]
XPtr<MariaConnectionPtr> connection_create(
  const Nullable<std::string>& host,
  const Nullable<std::string>& user,
  const Nullable<std::string>& password,
  const Nullable<std::string>& db,
  unsigned int port,
  const Nullable<std::string>& unix_socket,
  unsigned long client_flag,
  const Nullable<std::string>& groups,
  const Nullable<std::string>& default_file,
  const Nullable<std::string>& ssl_key,
  const Nullable<std::string>& ssl_cert,
  const Nullable<std::string>& ssl_ca,
  const Nullable<std::string>& ssl_capath,
  const Nullable<std::string>& ssl_cipher
) {
  LOG_VERBOSE;

  std::auto_ptr<MariaConnection> pConnPtr(new MariaConnection);
  pConnPtr->connect(
    host, user, password, db, port, unix_socket, client_flag, groups, default_file,
    ssl_key, ssl_cert, ssl_ca, ssl_capath, ssl_cipher
  );

  return XPtr<MariaConnectionPtr>(new MariaConnectionPtr(pConnPtr.release()), true);
}

// [[Rcpp::export]]
bool connection_valid(XPtr<MariaConnectionPtr> con) {
  return con.get() != NULL && (*con)->is_connected();
}

// [[Rcpp::export]]
void connection_release(XPtr<MariaConnectionPtr> con) {
  if (!connection_valid(con)) {
    warning("Already disconnected");
    return;
  }

  (*con)->disconnect();
  con.release();
}

// [[Rcpp::export]]
List connection_info(XPtr<MariaConnectionPtr> con) {
  return (*con)->connection_info();
}

// [[Rcpp::export]]
CharacterVector connection_quote_string(XPtr<MariaConnectionPtr> con,
                                        CharacterVector input) {
  R_xlen_t n = input.size();
  CharacterVector output(n);

  for (R_xlen_t i = 0; i < n; ++i) {
    String x = input[i];
    output[i] = String((*con)->quote_string(x), CE_UTF8);
  }

  return output;
}

// [[Rcpp::export]]
void connection_begin_transaction(XPtr<MariaConnectionPtr> con) {
  (*con)->begin_transaction();
}

// [[Rcpp::export]]
void connection_commit(XPtr<MariaConnectionPtr> con) {
  (*con)->commit();
}

// [[Rcpp::export]]
void connection_rollback(XPtr<MariaConnectionPtr> con) {
  (*con)->rollback();
}

// [[Rcpp::export]]
bool connection_is_transacting(XPtr<MariaConnectionPtr> con) {
  return (*con)->is_transacting();
}
