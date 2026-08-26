# Precision of an anchor

`precision()` is an S7 generic that calculates the precision of an
anchor — the proportion of each predicted class among observations
satisfying the anchor — with methods available for the following
classes:

- [`kultarr::anchors`](anchors.md)

## Usage

``` r
precision(x, model, samples)

## S7 method for class <kultarr::anchors>
precision(x, model, samples)
```

## Arguments

- x:

  An object.

- model:

  A predict function that returns predicted labels given a dataset.

- samples:

  The dataset to test precision on.

## Value

A named vector of proportions for each class predicted by `model`.

## Examples

``` r
pred_1 <- predicate(
  feature = "x",
  operator  = `<`,
  constant = 0.8
)

anchor <- anchors(
  predicates = c(pred_1)
)

samples <- data.frame(
  x = c(0.1, 0.3, 0.5, 0.7, 0.9)
)

# A model function returning predictions for each sample.
model <- function(data) {
  ifelse(data$x > 0.5, "positive", "negative")
}

# Calculate the prediction distribution among samples
# satisfying the anchor.
precision(anchor, model, samples)
#> [1] 0.75 0.25
```
