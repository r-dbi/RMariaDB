#ifndef __RMARIADB_MARIA_BINDING__
#define __RMARIADB_MARIA_BINDING__

#include <boost/noncopyable.hpp>
#include "MariaTypes.h"

class MariaBinding : public boost::noncopyable {
  MYSQL_STMT* statement;

  int p;
  std::vector<MYSQL_BIND> bindings;
  std::vector<my_bool> is_null;
  std::vector<MariaFieldType> types;
  std::vector<MYSQL_TIME> time_buffers;

public:
  MariaBinding();
  ~MariaBinding();

public:
  void setup(MYSQL_STMT* statement_);

  void init_binding(List params);
  void bind_row(List params, int i);

private:
  void binding_update(int j, enum_field_types type, int size);

  void set_date_time_buffer(int j, time_t time);
  void set_time_buffer(int j, double time);
};

#endif
