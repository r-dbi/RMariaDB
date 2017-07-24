#include "pch.h"
#include "RMariaDB_types.h"

// [[Rcpp::export]]
XPtr<MyConnectionPtr> connection_create(
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
  MyConnectionPtr* pConn = new MyConnectionPtr(
    new MyConnection(
      host, user, password, db, port, unix_socket, client_flag,
      groups, default_file, ssl_key, ssl_cert, ssl_ca, ssl_capath, ssl_cipher)
  );
  return XPtr<MyConnectionPtr>(pConn, true);
}

// [[Rcpp::export]]
bool connection_valid(XPtr<MyConnectionPtr> con) {
  return con.get() != NULL;
}

// [[Rcpp::export]]
void connection_release(XPtr<MyConnectionPtr> con) {
  if (!connection_valid(con)) {
    warning("Already disconnected");
    return;
  }

  if ((*con)->hasQuery()) {
    warning(
      "%s\n%s",
      "There is a result object still in use.",
      "The connection will be automatically released when it is closed"
    );
  }
  return con.release();
}

// [[Rcpp::export]]
List connection_info(XPtr<MyConnectionPtr> con) {
  return (*con)->connectionInfo();
}

// [[Rcpp::export]]
CharacterVector connection_quote_string(XPtr<MyConnectionPtr> con,
                                        CharacterVector input) {
  int n = input.size();
  CharacterVector output(n);

  for (int i = 0; i < n; ++i) {
    if (input[i] == NA_STRING) {
      output[i] = NA_STRING;
    } else {
      String x = input[i];
      output[i] = "'" + (*con)->quoteString(x) + "'";
    }
  }

  return output;
}

// [[Rcpp::export]]
bool connection_exec(XPtr<MyConnectionPtr> con, std::string sql) {
  return (*con)->exec(sql);
}
