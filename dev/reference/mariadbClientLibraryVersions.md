# MariaDB Check for Compiled Versus Loaded Client Library Versions

This function prints out the compiled and loaded client library
versions.

## Usage

``` r
mariadbClientLibraryVersions()
```

## Value

A named integer vector of length two, the first element representing the
compiled library version and the second element representing the loaded
client library version.

## Examples

``` r
mariadbClientLibraryVersions()
#> 11.8.8-MariaDB          3.4.9 
#>         110808          30409 
```
