#ifndef RMARIADB_MARIARESULTSOURCE_H
#define RMARIADB_MARIARESULTSOURCE_H

class MariaResultSource {
public:
  MariaResultSource();
  virtual ~MariaResultSource();

public:
  virtual void* get_result() = 0;
};

#endif //RMARIADB_MARIARESULTSOURCE_H
