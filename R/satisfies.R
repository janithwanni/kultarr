#' Check whether data satisfies an anchor
#'
#' @description
#' `satisfies()` is an S7 generic that checks whether each row in a
#' dataset is satisfied by an anchor's predicates, with methods available
#' for the following classes:
#'
#' `r doclisting::methods_list("satisfies")`
#'
#' @param x An object.
#' @param data The dataframe to apply anchors on. Can be one instance or
#'   an entire dataset.
#' @returns A logical vector indicating whether the anchor is satisfied
#'   by each row of `data`.
#' @export
satisfies <- S7::new_generic(
  name = "satisfies",
  dispatch_args = "x",
  function(x, data) {
    S7::S7_dispatch()
  }
)

#' @rdname satisfies
S7::method(satisfies, anchors) <- function(x, data) {
  predicate_cols <- sapply(x@predicates, \(x) x@feature)
  if (!all(predicate_cols %in% colnames(data))) {
    stop(glue::glue(
      "Predicates contain the following columns \n {predicate_cols}\n",
      "that might not be in the dataset with the following columns \n {colnames(data)}"
    ))
  }
  satis_list <- rep(TRUE, nrow(data))
  for (predicate in x@predicates) {
    result_list <- predicate@operator(
      data[[predicate@feature]],
      predicate@constant
    )
    satis_list <- satis_list & result_list
  }
  return(satis_list)
}
