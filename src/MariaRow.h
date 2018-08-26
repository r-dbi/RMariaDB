#ifndef __RMARIADB_MARIA_ROW__
#define __RMARIADB_MARIA_ROW__

#include <boost/core/noncopyable.hpp>
#include <boost/container/vector.hpp>
#include <boost/cstdint.hpp>

#include "MariaTypes.h"

class MariaRow : public boost::noncopyable {
  MYSQL_STMT* pStatement_;

  int n_;
  std::vector<MYSQL_BIND> bindings_;

  std::vector<MariaFieldType> types_;
  std::vector<std::vector<unsigned char> > buffers_;
  std::vector<unsigned long> lengths_;
  boost::container::vector<my_bool> nulls_, errors_;

public:
  MariaRow();
  ~MariaRow();

public:
  void setup(MYSQL_STMT* pStatement, const std::vector<MariaFieldType>& types);
  void set_list_value(SEXP x, int i, int j);

private:
  // Value accessors -----------------------------------------------------------
  bool is_null(int j);

  int value_int(int j);
  int64_t value_int64(int j);
  double value_double(int j);
  SEXP value_string(int j);
  SEXP value_raw(int j);
  double value_date_time(int j);
  double value_date(int j);
  double value_time(int j);

  void fetch_buffer(int j);
};

#endif
