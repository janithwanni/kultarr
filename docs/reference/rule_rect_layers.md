# Add rectangular layers from rule boundaries

Converts a table of lower and upper x/y boundaries into rectangular
`ggplot2` layers.

## Usage

``` r
rule_rect_layers(rule_tbl, ...)
```

## Arguments

- rule_tbl:

  A data frame containing `x`, `y`, and `bound` columns. The `bound`
  column should contain `"lower"` and `"upper"` values.

- ...:

  Additional arguments passed to
  [`ggplot2::geom_rect()`](https://ggplot2.tidyverse.org/reference/geom_tile.html).

## Value

A list containing a
[`ggplot2::geom_rect()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)
layer.

## Examples

``` r
rule_tbl <- tibble::tribble(
  ~bound,  ~x, ~y,
  "lower",  1,  2,
  "upper",  4,  6
)

ggplot2::ggplot() +
  rule_rect_layers(
    rule_tbl,
    fill = "steelblue",
    alpha = 0.3
  )

```
