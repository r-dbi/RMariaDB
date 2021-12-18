if (Sys.getenv("GITHUB_ACTIONS") == "true" || (mariadbHasDefault() && identical(Sys.getenv("NOT_CRAN"), "true"))) {

  DBItest::test_all()

}
