# Link against libmariadbclient static libraries
if(!file.exists("../windows/libmariadbclient-2.3.3/include/mariadb/mysql.h")){
  if(getRversion() < "3.3.0") setInternet2()
  download.file("https://github.com/rwinlib/libmariadbclient/archive/v2.3.3.zip", "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}

# Link against libz static libraries (if not provided by R)
if(!file.exists("../windows/libz-1.2.8/include/zlib.h") && getRversion() < "3.2.0"){
  if(getRversion() < "3.3.0") setInternet2()
  download.file("https://github.com/rwinlib/libz/archive/v1.2.8.zip", "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
