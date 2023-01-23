#ifndef __RMARIADB_MY_UTILS__
#define __RMARIADB_MY_UTILS__

// Generic data frame utils ----------------------------------------------------

cpp11::list df_resize(const cpp11::list& df, int n);

// Set up S3 classes correctly
void df_s3(const cpp11::list& df, const std::vector<MariaFieldType>& types);

cpp11::writable::list df_create(const std::vector<MariaFieldType>& types,
               const std::vector<std::string>& names,
               int n);

int days_from_civil(int y, int m, int d);

#endif
