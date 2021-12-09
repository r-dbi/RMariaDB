#ifndef RPOSTGRES_PQDATAFRAME_H
#define RPOSTGRES_PQDATAFRAME_H

#include "DbDataFrame.h"

class MariaResultSource;

class MariaDataFrame : public DbDataFrame {
public:
  MariaDataFrame(MariaResultSource* result_source,
              const std::vector<std::string>& names,
              const int n_max_,
              const std::vector<DATA_TYPE>& types);
  ~MariaDataFrame();
};

#endif //RPOSTGRES_PQDATAFRAME_H
