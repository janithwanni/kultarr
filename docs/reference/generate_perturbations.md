# Generate Perturbations Around a Point of Interest

Generate Perturbations Around a Point of Interest

## Usage

``` r
generate_perturbations(
  data,
  instance,
  interest_columns,
  radius = 0.1,
  step = 0.01
)
```

## Arguments

- data:

  Training data frame

- instance:

  Row number of point of interest

- interest_columns:

  The columns of the dataset used for generating anchors

- radius:

  Perturbation radius (default: 0.1)

- step:

  Step size for perturbations (default: 0.01)

## Value

A data frame of perturbed points
