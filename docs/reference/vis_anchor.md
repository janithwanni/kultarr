# Visualize the anchor in two dimensional space

Visualize the anchor in two dimensional space

## Usage

``` r
vis_anchor(anchor, dataset, instance, model_func)
```

## Arguments

- anchor:

  The result of [`make_anchors()`](make_anchors.md) function call.

- dataset:

  The dataset passed to [`make_anchors()`](make_anchors.md)

- instance:

  The point of interest

- model_func:

  A crate object containing the prediction function of the modelfor
  visualisation

## Value

A ggplot object
