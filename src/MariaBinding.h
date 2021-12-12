#ifndef __RMARIADB_MARIA_BINDING__
#define __RMARIADB_MARIA_BINDING__

#include <boost/container/vector.hpp>
#include <boost/noncopyable.hpp>
#include "MariaTypes.h"

class MariaBinding : public boost::noncopyable {
  MYSQL_STMT* statement;
  List params;

  int p;
  R_xlen_t i, n_rows;
  std::vector<MYSQL_BIND> bindings;
  boost::container::vector<my_bool> is_null;
  std::vector<MariaFieldType> types;
  std::vector<MYSQL_TIME> time_buffers;

public:
  MariaBinding();
  ~MariaBinding();

public:
  void setup(MYSQL_STMT* statement_);

  void init_binding(const List& params);
  bool bind_next_row();

private:
  void binding_update(int j, enum_field_types type, int size);

  void clear_date_buffer(int j);
  void set_date_buffer(int j, int date);
  void clear_time_buffer(int j);
  void set_time_buffer(int j, double time);
};

#endif
