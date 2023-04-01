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
  connect(const cpp11::sexp& host, const cpp11::sexp& user, const cpp11::sexp& password,
          const cpp11::sexp& db, unsigned int port, const cpp11::sexp& unix_socket,
          unsigned long client_flag, const cpp11::sexp& group, const cpp11::sexp& default_file,
          const cpp11::sexp& ssl_key, const cpp11::sexp& ssl_cert,
          const cpp11::sexp& ssl_ca, const cpp11::sexp& ssl_capath,
          const cpp11::sexp& ssl_cipher,
          int timeout, bool reconnect);
  void disconnect();
  bool is_valid();
  void check_connection();

  cpp11::list info();
  MYSQL* get_conn();

  SEXP quote_string(const cpp11::r_string& input);
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
