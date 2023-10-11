#' @export
satisfies <- S7::new_generic("satisfies", "x")
#' @param data The dataframe to apply anchors on. Can be one instance or an entire dataset.
#' @return A logical vector indicating whether the anchors satisfies `data`
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
    result_list <- predicate@operator(data[[predicate@feature]], predicate@constant)
    satis_list <- satis_list & result_list
  }
  return(satis_list)
}
