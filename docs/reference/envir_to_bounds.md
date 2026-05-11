# Lookup function to get value of upper and lower bounds for the current state

The current state of the multi armed bandit is marked based on the
indices in the list of each combination of column and lower and upper
bound type.

## Usage

``` r
envir_to_bounds(current_envir, envir, interest_cols)
```

## Arguments

- current_envir:

  List of indexes, the current state

- envir:

  The current environment

- interest_cols:

  Columns of interest

## Value

A tibble of 1 x (2\*p) where p is the number of columns of interest
