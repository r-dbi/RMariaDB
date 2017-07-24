#ifndef __RSQLITE_MY_UTILS__
#define __RSQLITE_MY_UTILS__

// Generic data frame utils ----------------------------------------------------

Rcpp::List dfResize(const Rcpp::List& df, int n);

// Set up S3 classes correctly
void dfS3(const Rcpp::List& df, const std::vector<MyFieldType>& types);

Rcpp::List dfCreate(const std::vector<MyFieldType>& types,
                    const std::vector<std::string>& names,
                    int n);

#endif
