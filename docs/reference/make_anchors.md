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
  perturb_step = 0.01
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

  Logical. Whether to print out diagnostics of the Multi-Armed Bandit
  Algorithm

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

## Value

A list containing the final anchor which is a data.frame of size 2 x
(p+1) where p is the number of columns of interest with each row
containing a upper. lower bound, the reward history which contains the
reward history for each node traversed and the perturbations generated
