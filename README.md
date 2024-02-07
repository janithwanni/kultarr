
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
  n_epochs = 50,
  verbose = FALSE
)
#> Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if
#> `.name_repair` is omitted as of tibble 2.0.0.
#> ℹ Using compatibility `.name_repair`.
#> ℹ The deprecated feature was likely used in the anchorsRevisited package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.

final_bounds
#> # A tibble: 2 × 5
#>   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g bound
#>            <dbl>         <dbl>             <dbl>       <dbl> <chr>
#> 1           44.1          13.2              212        4062. lower
#> 2           47.5          15                224.       4662. upper
```

# Visualizing anchors in high dimensions

If the anchor has a dimension larger than 3 then it is possible to
visualize it in high dimensions using tours.

There are several S7 classes built to make the process of visualizing
the bounding box(es). (The option to visualize multiple boxes is still
under development)

#### 1. Create a bounding_box object by giving the result from the Multi Armed Bandit algorithm

``` r
bnd_box <- bounding_box(
  bounds_tbl = final_bounds,
  target_inst_row = train_data[1, ] |> select(bill_length_mm:body_mass_g),
  point_colors = "black"
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
  gif_file = "tour_animation.gif",
  width = 500,
  height = 500,
  frames = 360
)
```

![](tour_animation.gif)
