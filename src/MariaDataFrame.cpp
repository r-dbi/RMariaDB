#include "pch.h"
#include "MariaDataFrame.h"
#include "MariaColumnDataSourceFactory.h"


MariaDataFrame::MariaDataFrame(MariaResultSource* result_source,
                         const std::vector<std::string>& names,
                         const int n_max_,
                         const std::vector<DATA_TYPE>& types) :
  DbDataFrame(new MariaColumnDataSourceFactory(result_source, types), names, n_max_, types)
{
}

MariaDataFrame::~MariaDataFrame() {
}
