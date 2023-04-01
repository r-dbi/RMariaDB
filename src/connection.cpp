#include "pch.h"
#include "RMariaDB_types.h"

[[cpp11::register]]
cpp11::external_pointer<DbConnectionPtr> connection_create(
  const cpp11::sexp& host,
  const cpp11::sexp& user,
  const cpp11::sexp& password,
  const cpp11::sexp& db,
  unsigned int port,
  const cpp11::sexp& unix_socket,
  unsigned long client_flag,
  const cpp11::sexp& groups,
  const cpp11::sexp& default_file,
  const cpp11::sexp& ssl_key,
  const cpp11::sexp& ssl_cert,
  const cpp11::sexp& ssl_ca,
  const cpp11::sexp& ssl_capath,
  const cpp11::sexp& ssl_cipher,
  int timeout,
  bool reconnect
) {
  LOG_VERBOSE;

  DbConnection* pConnPtr = new DbConnection;
  try {
    pConnPtr->connect(
      host, user, password, db, port, unix_socket, client_flag, groups, default_file,
      ssl_key, ssl_cert, ssl_ca, ssl_capath, ssl_cipher, timeout, reconnect
    );
  } catch (...) {
    delete pConnPtr;
    throw;
  }

  DbConnectionPtr* pConn = new DbConnectionPtr(pConnPtr);

  return cpp11::external_pointer<DbConnectionPtr>(pConn, true);
}

[[cpp11::register]]
bool connection_valid(cpp11::external_pointer<DbConnectionPtr> con_) {
  DbConnectionPtr* con = con_.get();
  return con && con->get()->is_valid();
}

[[cpp11::register]]
void connection_release(cpp11::external_pointer<DbConnectionPtr> con_) {
  if (!connection_valid(con_)) {
    cpp11::warning("Already disconnected");
    return;
  }

  DbConnectionPtr* con = con_.get();
  con->get()->disconnect();
  con_.reset();
}

[[cpp11::register]]
cpp11::list connection_info(DbConnection* con) {
  return con->info();
}

// Quoting

[[cpp11::register]]
cpp11::strings connection_quote_string(DbConnection* con, cpp11::strings xs) {
  const auto n = xs.size();
  cpp11::writable::strings output(n);

  for (R_xlen_t i = 0; i < n; ++i) {
    const auto& x = xs[i];
    output[i] = con->quote_string(x);
  }

  return output;
}

// Transactions

[[cpp11::register]]
void connection_begin_transaction(cpp11::external_pointer<DbConnectionPtr> con) {
  (*con)->begin_transaction();
}

[[cpp11::register]]
void connection_commit(cpp11::external_pointer<DbConnectionPtr> con) {
  (*con)->commit();
}

[[cpp11::register]]
void connection_rollback(cpp11::external_pointer<DbConnectionPtr> con) {
  (*con)->rollback();
}

[[cpp11::register]]
bool connection_is_transacting(DbConnection* con) {
  return con->is_transacting();
}
