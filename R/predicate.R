#' S7 class to define a predicate
#' @param feature Character. Defines the column that the predicate is applied to
#' @param operator Binary operator that works with the column and the constant given
#' @param constant Value to compare `feature` with using `operator`. Can be numeric/character/logical
#' @rdname anchors
#' @export
predicate <- S7::new_class(
  "predicate",
  properties = list(
    feature = S7::class_character,
    operator = S7::class_function,
    constant = S7::new_union(
      S7::class_integer,
      S7::class_double,
      S7::class_character,
      S7::class_logical
    )
  ),
  validator = function(self) {}
)
