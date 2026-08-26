# Generic function calculate coverage of an anchor

The coverage of an anchor is defined as average number of observations
satisfied by an anchor

## Usage

``` r
coverage(x, samples)

## S7 method for class <kultarr::anchors>
coverage(x, samples)
```

## Arguments

- x:

  anchors object

- samples:

  the dataset to test coverage on

## Value

Numeric. Coverage of anchor

## Methods

`coverage()` is an S7 generic with methods available for the following
classes:

- [`kultarr::anchors`](anchors.md)

## Examples

``` r
# Create a simple anchor from two predicates.
pred_1 <- predicate(
  feature = "x",
  operator = `<`,
  constant = 0.8
)

anchor <- anchors(
  predicates = c(pred_1)
)

samples <- data.frame(
  x = c(0.1, 0.3, 0.5, 0.7, 0.9)
)

# Calculate the proportion of samples satisfying the anchor.
coverage(anchor, samples)
#> [1] 0.8
```
