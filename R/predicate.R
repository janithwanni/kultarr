#' @title Defines a predicate object
#' @description A predicate is built up of a feature column name, a comparison operator and a constant to compare with
#'  For example a predicate can take the form of x > 10, which captures all the observations that have the feature x greater than 10
#' @param feature Character. Defines the column that the predicate is applied to
#' @param operator Binary operator that works with the column and the constant given
#' @param constant Value to compare `feature` with using `operator`. Can be numeric/character/logical
#' @return A predicate object containing the properties `feature`, `operator`, `constant`
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
  validator = function(self) {
    if (is.na(self@constant)) {
      return("Can not set predicate with missing constant")
    }
  }
)
