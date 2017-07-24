#ifndef __RMYSQL_MY_CONNECTION__
#define __RMYSQL_MY_CONNECTION__

#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>

class MyResult;

// convenience typedef for shared_ptr to PqConnection
class MyConnection;
typedef boost::shared_ptr<MyConnection> MyConnectionPtr;

class MyConnection : boost::noncopyable {
  MYSQL* pConn_;
  MyResult* pCurrentResult_;

public:

  MyConnection(const Rcpp::Nullable<std::string>& host,
               const Rcpp::Nullable<std::string>& user,
               const Rcpp::Nullable<std::string>& password,
               const Rcpp::Nullable<std::string>& db,
               unsigned int port,
               const Rcpp::Nullable<std::string>& unix_socket,
               unsigned long client_flag,
               const Rcpp::Nullable<std::string>& groups,
               const Rcpp::Nullable<std::string>& default_file,
               const Rcpp::Nullable<std::string>& ssl_key,
               const Rcpp::Nullable<std::string>& ssl_cert,
               const Rcpp::Nullable<std::string>& ssl_ca,
               const Rcpp::Nullable<std::string>& ssl_capath,
               const Rcpp::Nullable<std::string>& ssl_cipher);
  ~MyConnection();

public:
  Rcpp::List connectionInfo();
  MYSQL* conn();

  std::string quoteString(std::string input);

  // Cancels previous query, if needed.
  void setCurrentResult(MyResult* pResult);
  bool isCurrentResult(MyResult* pResult);
  bool hasQuery();

  bool exec(std::string sql);

};

#endif
