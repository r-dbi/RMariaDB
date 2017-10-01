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
  bool transacting_;

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

  List connection_info();
  MYSQL* get_conn();

  std::string quote_string(const Rcpp::String& input);

  // Cancels previous query, if needed.
  void set_current_result(MariaResult* pResult);
  bool is_current_result(const MariaResult* pResult) const;
  bool has_query();

  bool exec(std::string sql);

  void begin_transaction();
  void commit();
  void rollback();
  bool is_transacting() const;
  void autocommit();
};

#endif
