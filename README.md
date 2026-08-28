
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kultarr <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `kultarr` is to generate and understand how anchors are
generated in a simpler intuitive approach.

## Installation

You can install the development version of kultarr like so:

``` r
pak::pak("janithwanni/kultarr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(kultarr)
## basic example code

library(randomForest)
#> randomForest 4.7-1.2
#> Type rfNews() to see new features/changes/bug fixes.
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
train_data <- data.frame(x = runif(100), y = runif(100), z = runif(100))
train_data[21, ] <- c(0.5, 0.5, 0.5)
train_data$cls <- factor(ifelse(train_data$x > 0.5 & train_data$y > 0.5, "U", "D"))

rf_model <- randomForest(cls ~ ., data = train_data)

model_func <- carrier::crate(function(data) {
  return(randomForest:::predict.randomForest(!!rf_model, data))
})

final_bounds <- make_anchors(
  dataset = train_data,
  cols = c("x", "y", "z"),
  instance = train_data[21, ],
  model_func = model_func,
  class_col = "cls",
  verbose = FALSE
)
```

The `final_bounds` variable is a list containing both the history of the
algorithm (`reward_history`) and the resulting anchor (`final_anchor`).

``` r
str(final_bounds)
#> List of 4
#>  $ final_anchor  : tibble [2 × 8] (S3: tbl_df/tbl/data.frame)
#>   ..$ id    : int [1:2] 1 1
#>   ..$ x     : num [1:2] 0.4 0.55
#>   ..$ y     : num [1:2] 0.4 0.6
#>   ..$ z     : num [1:2] 0.4 0.6
#>   ..$ bound : chr [1:2] "lower" "upper"
#>   ..$ reward: num [1:2] 1.48 1.48
#>   ..$ prec  : num [1:2] 0.901 0.901
#>   ..$ cover : num [1:2] 0.546 0.546
#>  $ reward_history:'data.frame':  64 obs. of  5 variables:
#>   ..$ node_tag: chr [1:64] "1:1:1:1:1:1" "2:1:1:1:1:1" "1:2:1:1:1:1" "1:1:2:1:1:1" ...
#>   ..$ reward  : num [1:64] 1.21 1.29 1.06 1.29 1.15 ...
#>   ..$ prec    : num [1:64] 0.852 0.905 0.706 0.905 0.793 ...
#>   ..$ cover   : num [1:64] 0.0787 0.1224 0.1224 0.1224 0.1224 ...
#>   ..$ id      : int [1:64] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ perturbs      : tibble [9,261 × 5] (S3: tbl_df/tbl/data.frame)
#>   ..$ x    : num [1:9261] 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 ...
#>   ..$ y    : num [1:9261] 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 0.4 ...
#>   ..$ z    : num [1:9261] 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 ...
#>   ..$ id   : int [1:9261] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ preds: Factor w/ 2 levels "D","U": 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "names")= chr [1:9261] "1" "2" "3" "4" ...
#>  $ perturb_bounds: tibble [2 × 5] (S3: tbl_df/tbl/data.frame)
#>   ..$ id   : int [1:2] 1 1
#>   ..$ x    : num [1:2] 0.4 0.6
#>   ..$ y    : num [1:2] 0.4 0.6
#>   ..$ z    : num [1:2] 0.4 0.6
#>   ..$ bound: chr [1:2] "lower" "upper"
```

The resulting anchor will have the reward, the precision and the
coverage of the underlying algorithm as additional diagnostic
information.

``` r
final_bounds$final_anchor
#> # A tibble: 2 × 8
#>      id     x     y     z bound reward  prec cover
#>   <int> <dbl> <dbl> <dbl> <chr>  <dbl> <dbl> <dbl>
#> 1     1  0.4    0.4   0.4 lower   1.48 0.901 0.546
#> 2     1  0.55   0.6   0.6 upper   1.48 0.901 0.546
```

The diagnostic information can be helpful in understanding where the
algorithm explored in the solution space.

# Visualizing anchors in high dimensions

If the anchor has a dimension larger than 3 then it is possible to
visualize it in high dimensions using tours.

There are several S7 classes built to make the process of visualizing
the bounding box(es). (The option to visualize multiple boxes is still
under development)

#### 1. Create a bounding_box object by giving the result from the underlying algorithm

``` r
bnd_box <- bounding_box(
  bounds_tbl = final_bounds$final_anchor,
  target_inst_row = train_data[1, ] |> select(x, y, z),
  point_colors = "black",
  edges_colors = "black"
)
```

#### 2. Create an anchor_tour object to hold the data needed to create the animation

``` r
anc_tour <- anchor_tour(
  bnd_box,
  train_data |> select(x, y, z),
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

<img src="man/figures/tour_animation.gif"
data-alt-text="Animation of a tour in a high dimensional dataset that shows the anchor as a box" />
