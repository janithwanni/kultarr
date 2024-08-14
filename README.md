
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kultarr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/kultarr)](https://CRAN.R-project.org/package=kultarr)
<!-- badges: end -->

The goal of `kultarr` is to generate and understand how anchors are
generated in a simpler intuitive approach.

## Installation

You can install the development version of kultarr like so:

``` r
remotes::install_github("janithwanni/kultarr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(kultarr)
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
  instance = c(1),
  model_func = model_func,
  class_col = "species",
  n_games = 5,
  n_epochs = 50,
  verbose = FALSE
)
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe
#> random numbers are produced via the L'Ecuyer-CMRG method. To disable this
#> check, use 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
```

The `final_bounds` variable is a list containing both the history of the
algorithm (`reward_history`) and the resulting anchor (`final_anchor`).

``` r
str(final_bounds)
#> List of 2
#>  $ final_anchor  : tibble [2 × 9] (S3: tbl_df/tbl/data.frame)
#>   ..$ id               : num [1:2] 1 1
#>   ..$ bill_length_mm   : num [1:2] 44.1 47.5
#>   ..$ bill_depth_mm    : num [1:2] 13.2 15
#>   ..$ flipper_length_mm: num [1:2] 212 224
#>   ..$ body_mass_g      : num [1:2] 4062 4662
#>   ..$ bound            : chr [1:2] "lower" "upper"
#>   ..$ reward           : num [1:2] 0.5 0.5
#>   ..$ prec             : num [1:2] 1 1
#>   ..$ cover            : num [1:2] 0.0216 0.0216
#>  $ reward_history: tibble [250 × 14] (S3: tbl_df/tbl/data.frame)
#>   ..$ bill_length_mm_l   : num [1:250] 46.2 46.1 46 46 45.8 ...
#>   ..$ bill_length_mm_u   : num [1:250] 46.3 46.4 46.4 46.4 46.4 ...
#>   ..$ bill_depth_mm_l    : num [1:250] 14 14 14 14 14 ...
#>   ..$ bill_depth_mm_u    : num [1:250] 14.2 14.2 14.2 14.2 14.2 ...
#>   ..$ flipper_length_mm_l: num [1:250] 216 216 216 216 216 ...
#>   ..$ flipper_length_mm_u: num [1:250] 218 218 218 218 218 ...
#>   ..$ body_mass_g_l      : num [1:250] 4300 4300 4300 4300 4300 4300 4300 4300 4300 4300 ...
#>   ..$ body_mass_g_u      : num [1:250] 4400 4400 4400 4400 4400 ...
#>   ..$ earned_reward      : num [1:250] 0 0 0 0 0 0 0 0 0 0 ...
#>   ..$ prec               : num [1:250] 0 0 0 0 0 0 0 0 0 0 ...
#>   ..$ cover              : num [1:250] 0 0 0 0 0 0 0 0 0 0 ...
#>   ..$ game               : int [1:250] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ epoch              : int [1:250] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ id                 : num [1:250] 1 1 1 1 1 1 1 1 1 1 ...
```

The resulting anchor will have the reward, the precision and the
coverage of the underlying algorithm as additional diagnostic
information.

``` r
final_bounds$final_anchor
#> # A tibble: 2 × 9
#>      id bill_length_mm bill_depth_mm flipper_length_mm body_mass_g bound reward
#>   <dbl>          <dbl>         <dbl>             <dbl>       <dbl> <chr>  <dbl>
#> 1     1           44.1          13.2              212        4062. lower  0.500
#> 2     1           47.5          15                224.       4662. upper  0.500
#> # ℹ 2 more variables: prec <dbl>, cover <dbl>
```

The diagnostic information can be helpful in understanding where the
algorithm explored in the solution space.

# Visualizing anchors in high dimensions

If the anchor has a dimension larger than 3 then it is possible to
visualize it in high dimensions using tours.

There are several S7 classes built to make the process of visualizing
the bounding box(es). (The option to visualize multiple boxes is still
under development)

#### 1. Create a bounding_box object by giving the result from the Multi Armed Bandit algorithm

``` r
bnd_box <- bounding_box(
  bounds_tbl = final_bounds$final_anchor,
  target_inst_row = train_data[1, ] |> select(bill_length_mm:body_mass_g),
  point_colors = "black",
  edges_colors = "black"
)
```

#### 2. Create an anchor_tour object to hold the data needed to create the animation

``` r
anc_tour <- anchor_tour(
  bnd_box,
  train_data |> select(bill_length_mm:body_mass_g),
  "blue"
)
```

#### 3. Animate using the animate_anchor function by passing the anchor_tour object

``` r
animate_anchor(
  anc_tour,
  gif_file = "man/figures/tour_animation.gif",
  width = 500,
  height = 500,
  frames = 360
)
```

![](man/figures/tour_animation.gif)
