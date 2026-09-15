#include "pch.h"
#include "MariaColumnDataSourceFactory.h"
#include "MariaColumnDataSource.h"

MariaColumnDataSourceFactory::MariaColumnDataSourceFactory(MariaResultSource* result_source_, const std::vector<DATA_TYPE>& types_) :
  result_source(result_source_),
  types(types_)
{
}

MariaColumnDataSourceFactory::~MariaColumnDataSourceFactory() {
}

DbColumnDataSource* MariaColumnDataSourceFactory::create(const int j) {
  return new MariaColumnDataSource(result_source, types[j], j);
}
