# Data structure to hold information necessary to animate tours

Data structure to hold information necessary to animate tours

## Usage

``` r
anchor_tour(b_boxes, data, point_colors, point_shapes = 1, point_sizes = 1)
```

## Arguments

- b_boxes:

  S7 object of type boundary boxes

- data:

  data.frame of points to visualize on tours

- point_colors:

  Character vector of one or nrow(data)

- point_shapes:

  Numeric vector of one or nrow(data) containing shape number. Defaults
  to hollow (i.e. 1)

- point_sizes:

  Numeric vector of one or nrow(data) containing size. Defaults to 1
