
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rocrateR: RO-Crate R Package Wrapper

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/rocrateR)](https://CRAN.R-project.org/package=rocrateR)
[![R-CMD-check](https://github.com/villegar/ro-crate-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/villegar/ro-crate-r/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/villegar/ro-crate-r/graph/badge.svg)](https://app.codecov.io/gh/villegar/ro-crate-r)
<!-- badges: end -->

The goal of rocrateR is to provide an R package for creating,
manipulating and reading RO-Crates. Latest supported version 1.2 of the
specification.

## Installation

You can install the development version of rocrateR like so:

``` r
# install.packages("remotes")
remotes::install_github("villegar/ro-crate-r", "main")

OR

remotes::install_github("ResearchObject/ro-crate-r", "main")
```

## First RO-Crate

The following command creates an RO-Crate Metadata descriptor
(`ro-crate-metadata.json`). This should be stored inside the root (`./`)
of your RO-Crate.

``` r
# library(rocrateR)
my_first_ro_crate <- rocrateR::rocrate()
```

This object is a list with the basic components of an RO-Crate. It can
be visualised in the console with the `print` command:

``` r
print(my_first_ro_crate)
#> {
#>   "@context": "https://w3id.org/ro/crate/1.2/context",
#>   "@graph": [
#>     {
#>       "@id": "ro-crate-metadata.json",
#>       "@type": "CreativeWork",
#>       "about": {
#>         "@id": "./"
#>       },
#>       "conformsTo": {
#>         "@id": "https://w3id.org/ro/crate/1.2"
#>       }
#>     },
#>     {
#>       "@id": "./",
#>       "@type": "Dataset"
#>     }
#>   ]
#> }
```

This object can be saved to disk using the following command:

``` r
my_first_ro_crate |>
  rocrateR::write_rocrate("/path/to/ro-crate/ro-crate-metadata.json")
```

For example, using a temporary directory:

``` r
tmp <- file.path(tempdir(), "ro-crate-metadata.json")
my_first_ro_crate |>
  rocrateR::write_rocrate(tmp)

# load lines / flat file
readLines(tmp)
#>  [1] "{"                                                         
#>  [2] "  \"@context\": \"https://w3id.org/ro/crate/1.2/context\","
#>  [3] "  \"@graph\": ["                                           
#>  [4] "    {"                                                     
#>  [5] "      \"@id\": \"ro-crate-metadata.json\","                
#>  [6] "      \"@type\": \"CreativeWork\","                        
#>  [7] "      \"about\": {"                                        
#>  [8] "        \"@id\": \"./\""                                   
#>  [9] "      },"                                                  
#> [10] "      \"conformsTo\": {"                                   
#> [11] "        \"@id\": \"https://w3id.org/ro/crate/1.2\""        
#> [12] "      }"                                                   
#> [13] "    },"                                                    
#> [14] "    {"                                                     
#> [15] "      \"@id\": \"./\","                                    
#> [16] "      \"@type\": \"Dataset\""                              
#> [17] "    }"                                                     
#> [18] "  ]"                                                       
#> [19] "}"

# delete temporal file
unlink(tmp)
```
