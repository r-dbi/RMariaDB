#ifndef __RMARIADB_MARIA_RESULT__
#define __RMARIADB_MARIA_RESULT__

#include "DbResult.h"


// MariaResult -----------------------------------------------------------------

class MariaResult : public DbResult {
protected:
  MariaResult(const DbConnectionPtr& pConn, const std::string& sql, bool is_statement);

public:
  static DbResult* create_and_send_query(const DbConnectionPtr& con, const std::string& sql, bool is_statement);

public:
  void close();
};

#endif // __RMARIADB_MARIA_RESULT__
