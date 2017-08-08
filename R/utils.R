stopc <- function(...) {
  stop(..., call. = FALSE, domain = NA)
}

warningc <- function(...) {
  warning(..., call. = FALSE, domain = NA)
}
