#ifndef RMARIADB_MARIADATAFRAME_H
#define RMARIADB_MARIADATAFRAME_H

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

#endif //RMARIADB_MARIADATAFRAME_H
