# Make anchors

This function is the main entrypoint that generates anchors by running a
Breadth First Search algorithm

## Usage

``` r
make_anchors(
  dataset,
  cols,
  instance,
  model_func,
  class_col,
  n_bins = 4,
  seed = 145,
  verbose = FALSE,
  parallel = FALSE,
  progress = FALSE,
  perturb_distance = 0.1,
  perturb_step = 0.01,
  instance_lbls = NULL
)
```

## Arguments

- dataset:

  Dataset to use containing predictors and response variables.

- cols:

  Columns of interest

- instance:

  A tibble row containing the instance to interpret, can be a dataframe
  containing multiple rows

- model_func:

  Function that gives takes in any data and the model to give
  predictions

- class_col:

  Name of factor column containing class of interest

- n_bins:

  Number of bins used for binning the perturbation distribution. A
  higher bin size would make granular anchors but will increase
  computation time.

- seed:

  Numeric. Seed to ensure that the results stay consistent

- verbose:

  Logical. Whether to print out diagnostics of the algorithm

- parallel:

  Logical. Whether to use parallel processing. Default set to FALSE.

- progress:

  Logical. Whether to show a bar progress bar when performing parallel
  computation

- perturb_distance:

  Numeric. The distance from the given instance to start creating
  perturbations

- perturb_step:

  Numeric. The step size to create the grid of points around the given
  instance

- instance_lbls:

  Character. A vector of labels to be used in the result. Needs to have
  length equal to number of rows in instance

## Value

A list containing the final anchor which is a data.frame of size 2 x
(p+1) where p is the number of columns of interest with each row
containing a upper. lower bound, the reward history which contains the
reward history for each node traversed and the perturbations generated

## Examples

``` r
set.seed(145)

# A small dataset containing the response column.
dataset <- data.frame(
  x = runif(50),
  y = runif(50)
)

dataset$class <- ifelse(
  dataset$x + dataset$y > 1,
  "high",
  "low"
)

# Model function used to predict the class of new observations.
model_func <- function(data) {
  ifelse(data$x + data$y > 1, "high", "low")
}

# Select one observation to explain.
instance <- dataset[1, c("x", "y")]

result <- make_anchors(
  dataset = dataset,
  cols = c("x", "y"),
  instance = instance,
  model_func = model_func,
  class_col = "class",
  n_bins = 2,
  seed = 145
)
#> INFO [2026-08-28 17:10:18] setting up bin edges
#> INFO [2026-08-28 17:10:19] setting lower bounds
#> INFO [2026-08-28 17:10:19] Have 1 lower bounds with 0.653931205254048
#> INFO [2026-08-28 17:10:19] setting upper bounds
#> INFO [2026-08-28 17:10:19] Have 1 upper bounds with 0.853931205254048
#> INFO [2026-08-28 17:10:19] setting lower bounds
#> INFO [2026-08-28 17:10:19] Have 2 lower bounds with 0.887393567832187
#> INFO [2026-08-28 17:10:19] Have 2 lower bounds with 0.792393567832187
#> INFO [2026-08-28 17:10:19] setting upper bounds
#> INFO [2026-08-28 17:10:19] Have 1 upper bounds with 0.982393567832187
#> INFO [2026-08-28 17:10:19] received precisions 1 , NA
#> INFO [2026-08-28 17:10:19] found new max_reward -1 and node 1:1:1:1
#> INFO [2026-08-28 17:10:19] max_values
#> INFO [2026-08-28 17:10:19] 1:1:2:1
#> INFO [2026-08-28 17:10:19] received precisions 1 , NA
#> INFO [2026-08-28 17:10:19] max_values
#> INFO [2026-08-28 17:10:19] 1:1:2:1

# The result contains the discovered anchors and supporting
# information about the search.
names(result)
#> [1] "final_anchor"   "reward_history" "perturbs"       "perturb_bounds"
result$final_anchor
#> # A tibble: 2 × 7
#>      id     x     y bound reward  prec cover
#>   <int> <dbl> <dbl> <chr>  <dbl> <dbl> <dbl>
#> 1     1 0.654 0.887 lower    0.5     0 0.407
#> 2     1 0.854 0.982 upper    0.5     0 0.407
```
