# Defines a predicate object

A predicate is built up of a feature column name, a comparison operator
and a constant to compare with For example a predicate can take the form
of x \> 10, which captures all the observations that have the feature x
greater than 10

## Usage

``` r
predicate(
  feature = character(0),
  operator = function() NULL,
  constant = integer(0)
)
```

## Arguments

- feature:

  Character. Defines the column that the predicate is applied to

- operator:

  Binary operator that works with the column and the constant given

- constant:

  Value to compare `feature` with using `operator`. Can be
  numeric/character/logical

## Value

A predicate object containing the properties `feature`, `operator`,
`constant`

## Examples

``` r
# A predicate specifying that x should be greater than 0.5.
pred <- predicate(
  feature = "x",
  operator = `>`,
  constant = 0.5
)

pred
#> <kultarr::predicate>
#>  @ feature : chr "x"
#>  @ operator: function (e1, e2)  
#>  @ constant: num 0.5
```
