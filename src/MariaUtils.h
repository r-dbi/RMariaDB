#ifndef __RMARIADB_MY_UTILS__
#define __RMARIADB_MY_UTILS__

// Generic data frame utils ----------------------------------------------------

List df_resize(const List& df, int n);

// Set up S3 classes correctly
void df_s3(const List& df, const std::vector<MariaFieldType>& types);

List df_create(const std::vector<MariaFieldType>& types,
               const std::vector<std::string>& names,
               int n);

int days_from_civil(int y, int m, int d);

#endif
