if (Sys.getenv("GITHUB_ACTIONS") == "true" || (mariadbHasDefault() && identical(Sys.getenv("NOT_CRAN"), "true"))) {

  skip_if_not_installed("DBItest")
  DBItest::test_all()

}
