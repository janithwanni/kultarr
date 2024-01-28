
<!-- README.md is generated from README.Rmd. Please edit that file -->

# anchorsRevisited

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/anchorsRevisited)](https://CRAN.R-project.org/package=anchorsRevisited)
<!-- badges: end -->

The goal of `anchorsRevisited` is to generate and understand how anchors
are generated in a simpler intuitive approach.

## Installation

You can install the development version of anchorsRevisited like so:

``` r
remotes::install_github("janithwanni/anchorsRevisited")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(anchorsRevisited)
## basic example code

library(randomForest)
#> randomForest 4.7-1.1
#> Type rfNews() to see new features/changes/bug fixes.
library(palmerpenguins)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following object is masked from 'package:randomForest':
#> 
#>     combine
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(tidyr)

set.seed(145)
train_data <- penguins |> 
  drop_na() |>
  select(bill_length_mm: body_mass_g, species) |>
  slice_sample(prop = 0.8)

rf_model <- randomForest(species ~ ., data = train_data)

model_func <- function(model, data) {
  return(predict(model, data))
}

final_bounds <- make_anchors(
  rf_model,
  dataset = train_data,
  cols = train_data |> select(bill_length_mm:body_mass_g) |> colnames(),
  instance = 1,
  model_func = model_func,
  class_col = "species",
  n_games = 5,
  n_epochs = 50
)
#> Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if
#> `.name_repair` is omitted as of tibble 2.0.0.
#> ℹ Using compatibility `.name_repair`.
#> ℹ The deprecated feature was likely used in the anchorsRevisited package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 1 
#> 
#> selected : 28
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 2 
#> 
#> selected : 40
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 3 
#> 
#> selected : 9
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 4 
#> 
#> selected : 63
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 5 
#> 
#> selected : 37
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 6 
#> 
#> selected : 39
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 7 
#> 
#> selected : 70
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 1: Round 8 
#> 
#> selected : 61
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 1e-04 | 1 | 0.50005=====
#> Game 1: Round 9 
#> 
#> selected : 9
#>   prec: 1  |
#>   cover: 1e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 1: Round 10 
#> 
#> selected : 45
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 1: Round 11 
#> 
#> selected : 66
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 1: Round 12 
#> 
#> selected : 56
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 1: Round 13 
#> 
#> selected : 64
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 1: Round 14 
#> 
#> selected : 17
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 1: Round 15 
#> 
#> selected : 44
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 5e-04 | 1 | 0.50025=====
#> Game 1: Round 16 
#> 
#> selected : 55
#>   prec: 1  |
#>   cover: 5e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 5e-04 | 1 | 0.50025=====
#> Game 1: Round 17 
#> 
#> selected : 59
#>   prec: 1  |
#>   cover: 5e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 1: Round 18 
#> 
#> selected : 62
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 1: Round 19 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 1: Round 20 
#> 
#> selected : 26
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 8e-04 | 1 | 0.5004=====
#> Game 1: Round 21 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 8e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 9e-04 | 1 | 0.50045=====
#> Game 1: Round 22 
#> 
#> selected : 54
#>   prec: 1  |
#>   cover: 9e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 1: Round 23 
#> 
#> selected : 58
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 1: Round 24 
#> 
#> selected : 47
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0013 | 1 | 0.50065=====
#> Game 1: Round 25 
#> 
#> selected : 23
#>   prec: 1  |
#>   cover: 0.0013 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0013 | 1 | 0.50065=====
#> Game 1: Round 26 
#> 
#> selected : 25
#>   prec: 1  |
#>   cover: 0.0013 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0013 | 1 | 0.50065=====
#> Game 1: Round 27 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0013 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0015 | 1 | 0.50075=====
#> Game 1: Round 28 
#> 
#> selected : 53
#>   prec: 1  |
#>   cover: 0.0015 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0016 | 1 | 0.5008=====
#> Game 1: Round 29 
#> 
#> selected : 57
#>   prec: 1  |
#>   cover: 0.0016 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0017 | 1 | 0.50085=====
#> Game 1: Round 30 
#> 
#> selected : 60
#>   prec: 1  |
#>   cover: 0.0017 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0021 | 1 | 0.50105=====
#> Game 1: Round 31 
#> 
#> selected : 46
#>   prec: 1  |
#>   cover: 0.0021 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0025 | 1 | 0.50125=====
#> Game 1: Round 32 
#> 
#> selected : 50
#>   prec: 1  |
#>   cover: 0.0025 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0027 | 1 | 0.50135=====
#> Game 1: Round 33 
#> 
#> selected : 46
#>   prec: 1  |
#>   cover: 0.0027 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0031 | 1 | 0.50155=====
#> Game 1: Round 34 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.0031 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0037 | 1 | 0.50185=====
#> Game 1: Round 35 
#> 
#> selected : 54
#>   prec: 1  |
#>   cover: 0.0037 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0044 | 1 | 0.5022=====
#> Game 1: Round 36 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 0.0044 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0045 | 1 | 0.50225=====
#> Game 1: Round 37 
#> 
#> selected : 46
#>   prec: 1  |
#>   cover: 0.0045 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0052 | 1 | 0.5026=====
#> Game 1: Round 38 
#> 
#> selected : 52
#>   prec: 1  |
#>   cover: 0.0052 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0053 | 1 | 0.50265=====
#> Game 1: Round 39 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0053 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0059 | 1 | 0.50295=====
#> Game 1: Round 40 
#> 
#> selected : 53
#>   prec: 1  |
#>   cover: 0.0059 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0064 | 1 | 0.5032=====
#> Game 1: Round 41 
#> 
#> selected : 52
#>   prec: 1  |
#>   cover: 0.0064 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0076 | 1 | 0.5038=====
#> Game 1: Round 42 
#> 
#> selected : 39
#>   prec: 1  |
#>   cover: 0.0076 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.009 | 1 | 0.5045=====
#> Game 1: Round 43 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.009 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0108 | 1 | 0.5054=====
#> Game 1: Round 44 
#> 
#> selected : 69
#>   prec: 1  |
#>   cover: 0.0108 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.012 | 1 | 0.506=====
#> Game 1: Round 45 
#> 
#> selected : 15
#>   prec: 1  |
#>   cover: 0.012 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0136 | 1 | 0.5068=====
#> Game 1: Round 46 
#> 
#> selected : 7
#>   prec: 1  |
#>   cover: 0.0136 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0149 | 1 | 0.50745=====
#> Game 1: Round 47 
#> 
#> selected : 13
#>   prec: 1  |
#>   cover: 0.0149 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0159 | 1 | 0.50795=====
#> Game 1: Round 48 
#> 
#> selected : 52
#>   prec: 1  |
#>   cover: 0.0159 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0163 | 1 | 0.50815=====
#> Game 1: Round 49 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.0163 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0187 | 1 | 0.50935=====
#> Game 1: Round 50 
#> 
#> selected : 45
#>   prec: 1  |
#>   cover: 0.0187 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 1 
#> 
#> selected : 37
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 2 
#> 
#> selected : 35
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 3 
#> 
#> selected : 8
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 4 
#> 
#> selected : 32
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 5 
#> 
#> selected : 34
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 6 
#> 
#> selected : 8
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 7 
#> 
#> selected : 20
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 2: Round 8 
#> 
#> selected : 67
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 2: Round 9 
#> 
#> selected : 4
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 2: Round 10 
#> 
#> selected : 39
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 2: Round 11 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 2: Round 12 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 5e-04 | 1 | 0.50025=====
#> Game 2: Round 13 
#> 
#> selected : 52
#>   prec: 1  |
#>   cover: 5e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 2: Round 14 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 2: Round 15 
#> 
#> selected : 39
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 2: Round 16 
#> 
#> selected : 51
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 2: Round 17 
#> 
#> selected : 44
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 2: Round 18 
#> 
#> selected : 44
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 8e-04 | 1 | 0.5004=====
#> Game 2: Round 19 
#> 
#> selected : 51
#>   prec: 1  |
#>   cover: 8e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 8e-04 | 1 | 0.5004=====
#> Game 2: Round 20 
#> 
#> selected : 50
#>   prec: 1  |
#>   cover: 8e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 9e-04 | 1 | 0.50045=====
#> Game 2: Round 21 
#> 
#> selected : 47
#>   prec: 1  |
#>   cover: 9e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 9e-04 | 1 | 0.50045=====
#> Game 2: Round 22 
#> 
#> selected : 68
#>   prec: 1  |
#>   cover: 9e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 9e-04 | 1 | 0.50045=====
#> Game 2: Round 23 
#> 
#> selected : 50
#>   prec: 1  |
#>   cover: 9e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0011 | 1 | 0.50055=====
#> Game 2: Round 24 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 0.0011 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 2: Round 25 
#> 
#> selected : 47
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0016 | 1 | 0.5008=====
#> Game 2: Round 26 
#> 
#> selected : 50
#>   prec: 1  |
#>   cover: 0.0016 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0018 | 1 | 0.5009=====
#> Game 2: Round 27 
#> 
#> selected : 47
#>   prec: 1  |
#>   cover: 0.0018 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0021 | 1 | 0.50105=====
#> Game 2: Round 28 
#> 
#> selected : 66
#>   prec: 1  |
#>   cover: 0.0021 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0024 | 1 | 0.5012=====
#> Game 2: Round 29 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.0024 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0027 | 1 | 0.50135=====
#> Game 2: Round 30 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 0.0027 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0029 | 1 | 0.50145=====
#> Game 2: Round 31 
#> 
#> selected : 33
#>   prec: 1  |
#>   cover: 0.0029 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.003 | 1 | 0.5015=====
#> Game 2: Round 32 
#> 
#> selected : 68
#>   prec: 1  |
#>   cover: 0.003 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0038 | 1 | 0.5019=====
#> Game 2: Round 33 
#> 
#> selected : 19
#>   prec: 1  |
#>   cover: 0.0038 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0042 | 1 | 0.5021=====
#> Game 2: Round 34 
#> 
#> selected : 50
#>   prec: 1  |
#>   cover: 0.0042 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0048 | 1 | 0.5024=====
#> Game 2: Round 35 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 0.0048 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0056 | 1 | 0.5028=====
#> Game 2: Round 36 
#> 
#> selected : 47
#>   prec: 1  |
#>   cover: 0.0056 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0064 | 1 | 0.5032=====
#> Game 2: Round 37 
#> 
#> selected : 65
#>   prec: 1  |
#>   cover: 0.0064 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0066 | 1 | 0.5033=====
#> Game 2: Round 38 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0066 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0067 | 1 | 0.50335=====
#> Game 2: Round 39 
#> 
#> selected : 65
#>   prec: 1  |
#>   cover: 0.0067 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0082 | 1 | 0.5041=====
#> Game 2: Round 40 
#> 
#> selected : 67
#>   prec: 1  |
#>   cover: 0.0082 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0086 | 1 | 0.5043=====
#> Game 2: Round 41 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0086 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.01 | 1 | 0.505=====
#> Game 2: Round 42 
#> 
#> selected : 16
#>   prec: 1  |
#>   cover: 0.01 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0115 | 1 | 0.50575=====
#> Game 2: Round 43 
#> 
#> selected : 15
#>   prec: 1  |
#>   cover: 0.0115 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0124 | 1 | 0.5062=====
#> Game 2: Round 44 
#> 
#> selected : 7
#>   prec: 1  |
#>   cover: 0.0124 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0136 | 1 | 0.5068=====
#> Game 2: Round 45 
#> 
#> selected : 13
#>   prec: 1  |
#>   cover: 0.0136 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0144 | 1 | 0.5072=====
#> Game 2: Round 46 
#> 
#> selected : 22
#>   prec: 1  |
#>   cover: 0.0144 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0157 | 1 | 0.50785=====
#> Game 2: Round 47 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0157 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0169 | 1 | 0.50845=====
#> Game 2: Round 48 
#> 
#> selected : 62
#>   prec: 1  |
#>   cover: 0.0169 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0169 | 1 | 0.50845=====
#> Game 2: Round 49 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.0169 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0182 | 1 | 0.5091=====
#> Game 2: Round 50 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 0.0182 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 1 
#> 
#> selected : 37
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 2 
#> 
#> selected : 31
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 3 
#> 
#> selected : 10
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 4 
#> 
#> selected : 19
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 5 
#> 
#> selected : 21
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 6 
#> 
#> selected : 30
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 3: Round 7 
#> 
#> selected : 11
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 3: Round 8 
#> 
#> selected : 4
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 3: Round 9 
#> 
#> selected : 3
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 3: Round 10 
#> 
#> selected : 65
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 3: Round 11 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 3: Round 12 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 3: Round 13 
#> 
#> selected : 56
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 5e-04 | 1 | 0.50025=====
#> Game 3: Round 14 
#> 
#> selected : 67
#>   prec: 1  |
#>   cover: 5e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 15 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 16 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 17 
#> 
#> selected : 60
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 18 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 19 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 20 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 3: Round 21 
#> 
#> selected : 15
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 3: Round 22 
#> 
#> selected : 7
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 9e-04 | 1 | 0.50045=====
#> Game 3: Round 23 
#> 
#> selected : 2
#>   prec: 1  |
#>   cover: 9e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.001 | 1 | 0.5005=====
#> Game 3: Round 24 
#> 
#> selected : 13
#>   prec: 1  |
#>   cover: 0.001 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 3: Round 25 
#> 
#> selected : 65
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0016 | 1 | 0.5008=====
#> Game 3: Round 26 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0016 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0016 | 1 | 0.5008=====
#> Game 3: Round 27 
#> 
#> selected : 62
#>   prec: 1  |
#>   cover: 0.0016 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.002 | 1 | 0.501=====
#> Game 3: Round 28 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.002 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0022 | 1 | 0.5011=====
#> Game 3: Round 29 
#> 
#> selected : 23
#>   prec: 1  |
#>   cover: 0.0022 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0024 | 1 | 0.5012=====
#> Game 3: Round 30 
#> 
#> selected : 25
#>   prec: 1  |
#>   cover: 0.0024 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0029 | 1 | 0.50145=====
#> Game 3: Round 31 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 0.0029 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0032 | 1 | 0.5016=====
#> Game 3: Round 32 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 0.0032 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0039 | 1 | 0.50195=====
#> Game 3: Round 33 
#> 
#> selected : 33
#>   prec: 1  |
#>   cover: 0.0039 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.004 | 1 | 0.502=====
#> Game 3: Round 34 
#> 
#> selected : 54
#>   prec: 1  |
#>   cover: 0.004 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0055 | 1 | 0.50275=====
#> Game 3: Round 35 
#> 
#> selected : 67
#>   prec: 1  |
#>   cover: 0.0055 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0059 | 1 | 0.50295=====
#> Game 3: Round 36 
#> 
#> selected : 63
#>   prec: 1  |
#>   cover: 0.0059 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0063 | 1 | 0.50315=====
#> Game 3: Round 37 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0063 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0071 | 1 | 0.50355=====
#> Game 3: Round 38 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0071 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0071 | 1 | 0.50355=====
#> Game 3: Round 39 
#> 
#> selected : 27
#>   prec: 1  |
#>   cover: 0.0071 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0074 | 1 | 0.5037=====
#> Game 3: Round 40 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 0.0074 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0077 | 1 | 0.50385=====
#> Game 3: Round 41 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.0077 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0085 | 1 | 0.50425=====
#> Game 3: Round 42 
#> 
#> selected : 40
#>   prec: 1  |
#>   cover: 0.0085 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0091 | 1 | 0.50455=====
#> Game 3: Round 43 
#> 
#> selected : 56
#>   prec: 1  |
#>   cover: 0.0091 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.01 | 1 | 0.505=====
#> Game 3: Round 44 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.01 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.011 | 1 | 0.5055=====
#> Game 3: Round 45 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 0.011 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0122 | 1 | 0.5061=====
#> Game 3: Round 46 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0122 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0128 | 1 | 0.5064=====
#> Game 3: Round 47 
#> 
#> selected : 65
#>   prec: 1  |
#>   cover: 0.0128 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0149 | 1 | 0.50745=====
#> Game 3: Round 48 
#> 
#> selected : 16
#>   prec: 1  |
#>   cover: 0.0149 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0179 | 1 | 0.50895=====
#> Game 3: Round 49 
#> 
#> selected : 15
#>   prec: 1  |
#>   cover: 0.0179 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0206 | 1 | 0.5103=====
#> Game 3: Round 50 
#> 
#> selected : 7
#>   prec: 1  |
#>   cover: 0.0206 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 1 
#> 
#> selected : 60
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 2 
#> 
#> selected : 6
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 3 
#> 
#> selected : 18
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 4 
#> 
#> selected : 12
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 5 
#> 
#> selected : 18
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 6 
#> 
#> selected : 29
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 7 
#> 
#> selected : 64
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 8 
#> 
#> selected : 12
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 9 
#> 
#> selected : 64
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 10 
#> 
#> selected : 6
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 11 
#> 
#> selected : 64
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 4: Round 12 
#> 
#> selected : 12
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 4: Round 13 
#> 
#> selected : 17
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 4: Round 14 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 4: Round 15 
#> 
#> selected : 13
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 4: Round 16 
#> 
#> selected : 22
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 5e-04 | 1 | 0.50025=====
#> Game 4: Round 17 
#> 
#> selected : 67
#>   prec: 1  |
#>   cover: 5e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 4: Round 18 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 4: Round 19 
#> 
#> selected : 62
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 4: Round 20 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 4: Round 21 
#> 
#> selected : 43
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 4: Round 22 
#> 
#> selected : 37
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 7e-04 | 1 | 0.50035=====
#> Game 4: Round 23 
#> 
#> selected : 54
#>   prec: 1  |
#>   cover: 7e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 8e-04 | 1 | 0.5004=====
#> Game 4: Round 24 
#> 
#> selected : 3
#>   prec: 1  |
#>   cover: 8e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0011 | 1 | 0.50055=====
#> Game 4: Round 25 
#> 
#> selected : 49
#>   prec: 1  |
#>   cover: 0.0011 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 4: Round 26 
#> 
#> selected : 65
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 4: Round 27 
#> 
#> selected : 14
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0014 | 1 | 0.5007=====
#> Game 4: Round 28 
#> 
#> selected : 24
#>   prec: 1  |
#>   cover: 0.0014 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0019 | 1 | 0.50095=====
#> Game 4: Round 29 
#> 
#> selected : 38
#>   prec: 1  |
#>   cover: 0.0019 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0019 | 1 | 0.50095=====
#> Game 4: Round 30 
#> 
#> selected : 38
#>   prec: 1  |
#>   cover: 0.0019 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0021 | 1 | 0.50105=====
#> Game 4: Round 31 
#> 
#> selected : 38
#>   prec: 1  |
#>   cover: 0.0021 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0024 | 1 | 0.5012=====
#> Game 4: Round 32 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0024 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0032 | 1 | 0.5016=====
#> Game 4: Round 33 
#> 
#> selected : 38
#>   prec: 1  |
#>   cover: 0.0032 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0052 | 1 | 0.5026=====
#> Game 4: Round 34 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0052 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0058 | 1 | 0.5029=====
#> Game 4: Round 35 
#> 
#> selected : 46
#>   prec: 1  |
#>   cover: 0.0058 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0063 | 1 | 0.50315=====
#> Game 4: Round 36 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0063 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0067 | 1 | 0.50335=====
#> Game 4: Round 37 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0067 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0067 | 1 | 0.50335=====
#> Game 4: Round 38 
#> 
#> selected : 46
#>   prec: 1  |
#>   cover: 0.0067 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.007 | 1 | 0.5035=====
#> Game 4: Round 39 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.007 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0082 | 1 | 0.5041=====
#> Game 4: Round 40 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 0.0082 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0089 | 1 | 0.50445=====
#> Game 4: Round 41 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0089 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0092 | 1 | 0.5046=====
#> Game 4: Round 42 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0092 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0097 | 1 | 0.50485=====
#> Game 4: Round 43 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 0.0097 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0101 | 1 | 0.50505=====
#> Game 4: Round 44 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0101 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0114 | 1 | 0.5057=====
#> Game 4: Round 45 
#> 
#> selected : 61
#>   prec: 1  |
#>   cover: 0.0114 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0125 | 1 | 0.50625=====
#> Game 4: Round 46 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0125 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0136 | 1 | 0.5068=====
#> Game 4: Round 47 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0136 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0148 | 1 | 0.5074=====
#> Game 4: Round 48 
#> 
#> selected : 35
#>   prec: 1  |
#>   cover: 0.0148 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0169 | 1 | 0.50845=====
#> Game 4: Round 49 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0169 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0178 | 1 | 0.5089=====
#> Game 4: Round 50 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 0.0178 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 1 
#> 
#> selected : 55
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 2 
#> 
#> selected : 42
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 3 
#> 
#> selected : 9
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 4 
#> 
#> selected : 10
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 5 
#> 
#> selected : 64
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 6 
#> 
#> selected : 6
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 7 
#> 
#> selected : 53
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 8 
#> 
#> selected : 9
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] NaN NaN NaN
#> ==== 0 | 0 | 0=====
#> Game 5: Round 9 
#> 
#> selected : 19
#>   prec: 0  |
#>   cover: 0 |
#>   reward: 0 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 1e-04 | 1 | 0.50005=====
#> Game 5: Round 10 
#> 
#> selected : 61
#>   prec: 1  |
#>   cover: 1e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 2e-04 | 1 | 0.5001=====
#> Game 5: Round 11 
#> 
#> selected : 66
#>   prec: 1  |
#>   cover: 2e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 3e-04 | 1 | 0.50015=====
#> Game 5: Round 12 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 3e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 13 
#> 
#> selected : 59
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 14 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 15 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 16 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 17 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 18 
#> 
#> selected : 24
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 4e-04 | 1 | 0.5002=====
#> Game 5: Round 19 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 4e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 5: Round 20 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 6e-04 | 1 | 0.5003=====
#> Game 5: Round 21 
#> 
#> selected : 32
#>   prec: 1  |
#>   cover: 6e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 8e-04 | 1 | 0.5004=====
#> Game 5: Round 22 
#> 
#> selected : 66
#>   prec: 1  |
#>   cover: 8e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 8e-04 | 1 | 0.5004=====
#> Game 5: Round 23 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 8e-04 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.001 | 1 | 0.5005=====
#> Game 5: Round 24 
#> 
#> selected : 35
#>   prec: 1  |
#>   cover: 0.001 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 5: Round 25 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0012 | 1 | 0.5006=====
#> Game 5: Round 26 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 0.0012 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0016 | 1 | 0.5008=====
#> Game 5: Round 27 
#> 
#> selected : 55
#>   prec: 1  |
#>   cover: 0.0016 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0019 | 1 | 0.50095=====
#> Game 5: Round 28 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0019 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0027 | 1 | 0.50135=====
#> Game 5: Round 29 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0027 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0029 | 1 | 0.50145=====
#> Game 5: Round 30 
#> 
#> selected : 59
#>   prec: 1  |
#>   cover: 0.0029 |
#>   reward: 0.5 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0037 | 1 | 0.50185=====
#> Game 5: Round 31 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0037 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0039 | 1 | 0.50195=====
#> Game 5: Round 32 
#> 
#> selected : 21
#>   prec: 1  |
#>   cover: 0.0039 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0044 | 1 | 0.5022=====
#> Game 5: Round 33 
#> 
#> selected : 66
#>   prec: 1  |
#>   cover: 0.0044 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0048 | 1 | 0.5024=====
#> Game 5: Round 34 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0048 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.005 | 1 | 0.5025=====
#> Game 5: Round 35 
#> 
#> selected : 61
#>   prec: 1  |
#>   cover: 0.005 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0053 | 1 | 0.50265=====
#> Game 5: Round 36 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 0.0053 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0057 | 1 | 0.50285=====
#> Game 5: Round 37 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0057 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0063 | 1 | 0.50315=====
#> Game 5: Round 38 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0063 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0076 | 1 | 0.5038=====
#> Game 5: Round 39 
#> 
#> selected : 53
#>   prec: 1  |
#>   cover: 0.0076 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0084 | 1 | 0.5042=====
#> Game 5: Round 40 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0084 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0084 | 1 | 0.5042=====
#> Game 5: Round 41 
#> 
#> selected : 45
#>   prec: 1  |
#>   cover: 0.0084 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0088 | 1 | 0.5044=====
#> Game 5: Round 42 
#> 
#> selected : 64
#>   prec: 1  |
#>   cover: 0.0088 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0094 | 1 | 0.5047=====
#> Game 5: Round 43 
#> 
#> selected : 36
#>   prec: 1  |
#>   cover: 0.0094 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.01 | 1 | 0.505=====
#> Game 5: Round 44 
#> 
#> selected : 22
#>   prec: 1  |
#>   cover: 0.01 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0113 | 1 | 0.50565=====
#> Game 5: Round 45 
#> 
#> selected : 35
#>   prec: 1  |
#>   cover: 0.0113 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.013 | 1 | 0.5065=====
#> Game 5: Round 46 
#> 
#> selected : 24
#>   prec: 1  |
#>   cover: 0.013 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0137 | 1 | 0.50685=====
#> Game 5: Round 47 
#> 
#> selected : 42
#>   prec: 1  |
#>   cover: 0.0137 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0143 | 1 | 0.50715=====
#> Game 5: Round 48 
#> 
#> selected : 48
#>   prec: 1  |
#>   cover: 0.0143 |
#>   reward: 0.5001 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0153 | 1 | 0.50765=====
#> Game 5: Round 49 
#> 
#> selected : 70
#>   prec: 1  |
#>   cover: 0.0153 |
#>   reward: 0.5002 
#> 
#> outcome: 0
#> [1] 0 0 1
#> ==== 0.0163 | 1 | 0.50815=====
#> Game 5: Round 50 
#> 
#> selected : 7
#>   prec: 1  |
#>   cover: 0.0163 |
#>   reward: 0.5002 
#> 
#> outcome: 0

final_bounds
#> # A tibble: 2 × 5
#>   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g bound
#>            <dbl>         <dbl>             <dbl>       <dbl> <chr>
#> 1           45.3          13.2               213       4150  lower
#> 2           48.2          14.5               225       4888. upper
```
