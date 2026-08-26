#' Precision of an anchor
#'
#' @description
#' `precision()` is an S7 generic that calculates the precision of an
#' anchor — the proportion of each predicted class among observations
#' satisfying the anchor — with methods available for the following
#' classes:
#''
#' @param x An object.
#' @param model A predict function that returns predicted labels given a
#'   dataset.
#' @param samples The dataset to test precision on.
#' @returns A named vector of proportions for each class predicted by
#'   `model`.
#' @export
precision <- S7::new_generic(
  name = "precision",
  dispatch_args = "x",
  function(x, model, samples) {
    S7::S7_dispatch()
  }
)

#' @rdname precision
S7::method(precision, S7::class_any) <- function(x, model, samples) {
  stop("Unimplemented. Provide model and samples instead")
}

#' @rdname precision
S7::method(precision, anchors) <- function(x, model, samples) {
  satisfying_rows <- which(satisfies(x, samples), arr.ind = TRUE)
  samples <- samples |>
    dplyr::slice(satisfying_rows)
  preds <- model(samples)
  tab_preds <- table(preds)
  prop <- as.vector(tab_preds / sum(tab_preds))
  return(prop = prop)
}
