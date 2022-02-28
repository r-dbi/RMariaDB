#ifndef __RMARIADB_MARIA_CONNECTION__
#define __RMARIADB_MARIA_CONNECTION__

#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>

class DbResult;

// convenience typedef for shared_ptr to DbConnection
class DbConnection;
typedef boost::shared_ptr<DbConnection> DbConnectionPtr;

class DbConnection : boost::noncopyable {
  MYSQL* pConn_;
  DbResult* pCurrentResult_;
  bool transacting_;

public:

  DbConnection();
  ~DbConnection();

public:
  void
  connect(const Nullable<std::string>& host, const Nullable<std::string>& user, const Nullable<std::string>& password,
          const Nullable<std::string>& db, unsigned int port, const Nullable<std::string>& unix_socket,
          unsigned long client_flag, const Nullable<std::string>& groups, const Nullable<std::string>& default_file,
          const Nullable<std::string>& ssl_key, const Nullable<std::string>& ssl_cert,
          const Nullable<std::string>& ssl_ca, const Nullable<std::string>& ssl_capath,
          const Nullable<std::string>& ssl_cipher,
          int timeout, bool reconnect);
  void disconnect();
  bool is_valid();
  void check_connection();

  List info();
  MYSQL* get_conn();

  SEXP quote_string(const String& input);
  static SEXP get_null_string();

  // Cancels previous query, if needed.
  void set_current_result(DbResult* pResult);
  void reset_current_result(DbResult* pResult);
  bool is_current_result(const DbResult* pResult) const;
  bool has_query();

  bool exec(const std::string& sql);

  void begin_transaction();
  void commit();
  void rollback();
  bool is_transacting() const;
  void autocommit();
};

#endif
