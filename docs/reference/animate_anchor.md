# Generic function to visualize tours

This function enables the user to animate the anchor in high dimensions
using tourrs

- [`kultarr::anchor_tour`](anchor_tour.md)

## Usage

``` r
animate_anchor(
  x,
  gif_file,
  tour_path = tourr::grand_tour(),
  width = 500,
  height = 500,
  frames = 360,
  loop = TRUE,
  rescale = TRUE,
  ...
)

## S7 method for class <kultarr::anchor_tour>
animate_anchor(
  x,
  gif_file,
  tour_path = tourr::grand_tour(),
  width = 500,
  height = 500,
  frames = 360,
  loop = TRUE,
  rescale = TRUE,
  ...
)
```

## Arguments

- x:

  An object of type anchor_tour

- gif_file:

  The file location to save the gif file

- tour_path:

  An object of type 'tour_path' from the tourr package. Defaults to
  grand_tour()

- width:

  the width of the gif file. Defaults to 500

- height:

  the height of the gif file. Defaults to 500

- frames:

  the number of frames to be included in the gif file. Defaults to 360

- loop:

  Logical. Defaults to TRUE

- rescale:

  Logical. whether to rescale the data or not. Defaults to TRUE.

- ...:

  Additional arguments passed to display_xy

## Value

None. Saves GIF at file location

## Examples

``` r
if (FALSE) { # \dontrun{
# Animate the projection of an anchor tour.
#
# `anchor_tour` objects can be created using the package's
# anchor visualisation workflow.
animate_anchor(
  x = anchor_tour_object,
  gif_file = tempfile(fileext = ".gif"),
  frames = 60,
  width = 400,
  height = 400
)
} # }
```
