RMariaDB 1.3.2

## R CMD check results

- [x] Checked locally, R 4.3.3
- [x] Checked on CI system, R 4.4.0
- [x] Checked on win-builder, R devel

## Current CRAN check results

- [x] Checked on 2024-05-26, problems found: https://cran.r-project.org/web/checks/check_results_RMariaDB.html
- [ ] NOTE: r-devel-linux-x86_64-debian-clang, r-devel-linux-x86_64-debian-gcc, r-devel-linux-x86_64-fedora-clang, r-devel-linux-x86_64-fedora-gcc
     File ‘RMariaDB/libs/RMariaDB.so’:
     Found non-API calls to R: ‘SETLENGTH’, ‘SET_TRUELENGTH’
     
     Compiled code should not call non-API entry points in R.
     
     See ‘Writing portable packages’ in the ‘Writing R Extensions’ manual.
- [ ] NOTE: r-devel-windows-x86_64
     File 'RMariaDB/libs/x64/RMariaDB.dll':
     Found non-API calls to R: 'SETLENGTH', 'SET_TRUELENGTH'
     
     Compiled code should not call non-API entry points in R.
     
     See 'Writing portable packages' in the 'Writing R Extensions' manual.

Check results at: https://cran.r-project.org/web/checks/check_results_RMariaDB.html
