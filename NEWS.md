# kultarr (development version)

## Improvements

* Each box is now scored from precomputed count tables, using one model call per instance, so the search is much faster and larger `n_bins` values are practical. The anchors found are unchanged.
* New `prune` argument to `make_anchors()` (default `TRUE`) drops cutpoints that can never give the best box. This never changes the best reward.
* New `search` argument to `make_anchors()`: `"refine"` (coarse to fine) and `"coordinate"` (coordinate ascent) are deterministic alternatives to the default `"exhaustive"` search for fine cutpoints or many columns.

## Bug fixes

* Precision is now computed against the instance's predicted label. Before, the class was looked up by position in `levels(class_col)`, which failed for character columns and for models whose factor levels were in a different order.

# kultarr 2.0.0

## Improvements

* Changed underlying algorithm to a breadth-first search algorithm

# kultarr 0.1.0

## Improvements

* Added functions to create anchors
* Added functions to visualize anchors using tourr package
