#ifndef RMARIADB_MARIACOLUMNDATASOURCEFACTORY_H
#define RMARIADB_MARIACOLUMNDATASOURCEFACTORY_H

#include "DbColumnDataSourceFactory.h"
#include "DbColumnDataType.h"

class MariaResultSource;

class MariaColumnDataSourceFactory : public DbColumnDataSourceFactory {
  MariaResultSource* result_source;
  const std::vector<DATA_TYPE> types;

public:
  MariaColumnDataSourceFactory(MariaResultSource* result_source_, const std::vector<DATA_TYPE>& types_);
  virtual ~MariaColumnDataSourceFactory();

public:
  virtual DbColumnDataSource* create(const int j);
};

#endif //RMARIADB_MARIACOLUMNDATASOURCEFACTORY_H
