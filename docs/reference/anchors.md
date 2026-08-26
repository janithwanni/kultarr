# Defines a new `anchor` object

Defines a new `anchor` object

## Usage

``` r
anchors(predicates = logical(0))
```

## Arguments

- predicates:

  a vector of `predicate` objects

## Value

A new `anchors` object containing the properties `predicates`

## Examples

``` r
# Create predicates and combine them into an anchor.
pred_1 <- predicate(
  feature = "x",
  operator = `>`,
  constant = 0.8
)

pred_2 <- predicate(
  feature = "y",
  operator = `<`,
  constant = 0.9
)

anchor <- anchors(
  predicates = c(pred_1, pred_2)
)

anchor
#> <kultarr::anchors>
#>  @ predicates:List of 2
#>  .. $ : <kultarr::predicate>
#>  ..  ..@ feature : chr "x"
#>  ..  ..@ operator: function (e1, e2)  
#>  ..  ..@ constant: num 0.8
#>  .. $ : <kultarr::predicate>
#>  ..  ..@ feature : chr "y"
#>  ..  ..@ operator: function (e1, e2)  
#>  ..  ..@ constant: num 0.9
```
