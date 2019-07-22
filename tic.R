do_package_checks(args = strsplit(Sys.getenv("R_CHECK_ARGS"), " ")[[1]])

if (ci_has_env("DEV_VERSIONS")) {
  get_stage("install") %>%
    add_step(step_install_github(c("r-dbi/DBI", "r-dbi/DBItest")))
}

if (ci_has_env("BUILD_PKGDOWN") && !ci_is_tag()) {
  do_pkgdown()
}
