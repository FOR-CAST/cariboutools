# cariboutools

<!-- badges: start -->
[![R-CMD-check](https://github.com/FOR-CAST/cariboutools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/FOR-CAST/cariboutools/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Helper functions for the YT_caribou Yukon caribou / anthropogenic-disturbance modelling workflow --
building the study area and template rasters, and other shared utilities used across the `prep-fit`
and `predict` targets pipelines.

## Installation

``` r
# install.packages("pak")
pak::pak("FOR-CAST/cariboutools")
```

## Usage

``` r
library(cariboutools)

sa  <- build_study_area()                 # Northern Mountain Complex caribou range (SpatVector)
rtm <- build_rasterToMatch(sa, res_m = 250)
sac <- build_study_area_calibration(sa)   # larger convex-hull area for scfm
```
