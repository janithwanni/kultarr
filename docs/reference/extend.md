# Extend an anchor

`extend()` adds a new predicate to an anchor's existing set of
predicates, returning an updated `anchors` object.

## Usage

``` r
extend(x, pred)

## S7 method for class <kultarr::anchors>
extend(x, pred)
```

## Arguments

- x:

  Object of S7 class `anchors`.

- pred:

  Object of S7 class `predicate`.

## Value

An `anchors` object with the additional predicate.

## Methods

`extend()` is an S7 generic with methods available for the following
classes:

- [`kultarr::anchors`](anchors.md)

## Examples

``` r
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
  predicates = c(pred_1)
)

# Add another predicate to the anchor.
extended_anchor <- extend(anchor, pred_2)

extended_anchor
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
