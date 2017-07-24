#ifndef __RSQLITE_MY_UTILS__
#define __RSQLITE_MY_UTILS__

// Generic data frame utils ----------------------------------------------------

List dfResize(const List& df, int n);

// Set up S3 classes correctly
void dfS3(const List& df, const std::vector<MyFieldType>& types);

List dfCreate(const std::vector<MyFieldType>& types,
                    const std::vector<std::string>& names,
                    int n);

#endif
