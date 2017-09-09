#ifndef __RMARIADB_MARIA_CONNECTION__
#define __RMARIADB_MARIA_CONNECTION__

#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>

class MariaResult;

// convenience typedef for shared_ptr to PqConnection
class MariaConnection;
typedef boost::shared_ptr<MariaConnection> MariaConnectionPtr;

class MariaConnection : boost::noncopyable {
  MYSQL* pConn_;
  MariaResult* pCurrentResult_;

public:

  MariaConnection();
  ~MariaConnection();

public:
  void
  connect(const Nullable<std::string>& host, const Nullable<std::string>& user, const Nullable<std::string>& password,
          const Nullable<std::string>& db, unsigned int port, const Nullable<std::string>& unix_socket,
          unsigned long client_flag, const Nullable<std::string>& groups, const Nullable<std::string>& default_file,
          const Nullable<std::string>& ssl_key, const Nullable<std::string>& ssl_cert,
          const Nullable<std::string>& ssl_ca, const Nullable<std::string>& ssl_capath,
          const Nullable<std::string>& ssl_cipher);
  void disconnect();
  bool is_connected();
  void check_connection();

  List connectionInfo();
  MYSQL* conn();

  std::string quoteString(const Rcpp::String& input);

  // Cancels previous query, if needed.
  void setCurrentResult(MariaResult* pResult);
  bool isCurrentResult(MariaResult* pResult);
  bool hasQuery();

  bool exec(std::string sql);
};

#endif
