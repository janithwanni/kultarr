# S7 class to hold the bounding box created by `make_anchors`

S7 class to hold the bounding box created by `make_anchors`

S7 class to hold a list of bounding boxes

## Usage

``` r
bounding_box(bounds_tbl, target_inst_row, point_colors, edges_colors)

bounding_boxes(boxes = logical(0))
```

## Arguments

- bounds_tbl:

  Tibble containing two rows and (p+1) columns of p predictors.

- target_inst_row:

  Tibble of one row and p columns for the target instance.

- point_colors:

  Character vector of 2^p length or 1 value.

- edges_colors:

  Character cector of 2^(p-1) \* p length or 1 value.

- boxes:

  A vector of S7 objects of class bounding box

## Value

S7 object of class bounding box

S7 object of class bounding boxes
