#ifndef RPOSTGRES_PQCOLUMNDATASOURCEFACTORY_H
#define RPOSTGRES_PQCOLUMNDATASOURCEFACTORY_H

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

#endif //RPOSTGRES_PQCOLUMNDATASOURCEFACTORY_H
