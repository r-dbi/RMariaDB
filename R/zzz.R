.onLoad <- function(libname, pkgname) {
  driver_init();
}

.onUnload <- function(libname, pkgname) {
  driver_done();
}
