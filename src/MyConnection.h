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

  MyConnection(const Nullable<std::string>& host,
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
               const Nullable<std::string>& ssl_cipher);
  ~MyConnection();

public:
  List connectionInfo();
  MYSQL* conn();

  std::string quoteString(std::string input);

  // Cancels previous query, if needed.
  void setCurrentResult(MyResult* pResult);
  bool isCurrentResult(MyResult* pResult);
  bool hasQuery();

  bool exec(std::string sql);

};

#endif
