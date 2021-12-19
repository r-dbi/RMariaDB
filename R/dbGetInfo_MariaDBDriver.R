#' @rdname MariaDBDriver-class
#' @usage NULL
dbGetInfo_MariaDBDriver <- function(dbObj, ...) {
  client_version <- names(version())[[2]]

  list(
    driver.version = PACKAGE_VERSION,
    client.version = package_version(client_version)
  )
}

#' @rdname MariaDBDriver-class
#' @export
setMethod("dbGetInfo", "MariaDBDriver", dbGetInfo_MariaDBDriver)
