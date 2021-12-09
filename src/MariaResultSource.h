#ifndef RPOSTGRES_PQRESULTSOURCE_H
#define RPOSTGRES_PQRESULTSOURCE_H

class MariaResultSource {
public:
  MariaResultSource();
  virtual ~MariaResultSource();

public:
  virtual PGresult* get_result() = 0;
};

#endif //RPOSTGRES_PQRESULTSOURCE_H
