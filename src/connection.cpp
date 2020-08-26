#include "pch.h"
#include "RMariaDB_types.h"

// [[Rcpp::export]]
XPtr<DbConnectionPtr> connection_create(
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
  const Nullable<std::string>& ssl_cipher,
  int timeout
) {
  LOG_VERBOSE;

  DbConnection* pConnPtr = new DbConnection;
  try {
    pConnPtr->connect(
      host, user, password, db, port, unix_socket, client_flag, groups, default_file,
      ssl_key, ssl_cert, ssl_ca, ssl_capath, ssl_cipher, timeout
    );
  } catch (...) {
    delete pConnPtr;
    throw;
  }

  DbConnectionPtr* pConn = new DbConnectionPtr(pConnPtr);

  return XPtr<DbConnectionPtr>(pConn, true);
}

// [[Rcpp::export]]
bool connection_valid(XPtr<DbConnectionPtr> con_) {
  DbConnectionPtr* con = con_.get();
  return con && con->get()->is_valid();
}

// [[Rcpp::export]]
void connection_release(XPtr<DbConnectionPtr> con_) {
  if (!connection_valid(con_)) {
    warning("Already disconnected");
    return;
  }

  DbConnectionPtr* con = con_.get();
  con->get()->disconnect();
  con_.release();
}

// [[Rcpp::export]]
List connection_info(DbConnection* con) {
  return con->info();
}

// Quoting

// [[Rcpp::export]]
CharacterVector connection_quote_string(DbConnection* con, CharacterVector xs) {
  R_xlen_t n = xs.size();
  CharacterVector output(n);

  for (R_xlen_t i = 0; i < n; ++i) {
    String x = xs[i];
    output[i] = con->quote_string(x);
  }

  return output;
}

// Transactions

// [[Rcpp::export]]
void connection_begin_transaction(XPtr<DbConnectionPtr> con) {
  (*con)->begin_transaction();
}

// [[Rcpp::export]]
void connection_commit(XPtr<DbConnectionPtr> con) {
  (*con)->commit();
}

// [[Rcpp::export]]
void connection_rollback(XPtr<DbConnectionPtr> con) {
  (*con)->rollback();
}

// [[Rcpp::export]]
bool connection_is_transacting(DbConnection* con) {
  return con->is_transacting();
}


// Specific functions


// as() override

namespace Rcpp {

template<>
DbConnection* as(SEXP x) {
  DbConnectionPtr* connection = (DbConnectionPtr*)(R_ExternalPtrAddr(x));
  if (!connection)
    stop("Invalid connection");
  return connection->get();
}

}
