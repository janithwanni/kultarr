#' Precision of an anchor
#'
#' @description
#' `precision()` is an S7 generic that calculates the precision of an
#' anchor — the proportion of each predicted class among observations
#' satisfying the anchor — with methods available for the following
#' classes:
#'
#' `r doclisting::methods_list("precision")`
#'
#' @param x An object.
#' @param model A predict function that returns predicted labels given a
#'   dataset.
#' @param samples The dataset to test precision on.
#' @returns A named vector of proportions for each class predicted by
#'   `model`.
#' @examples
#' pred_1 <- predicate(
#'   feature = "x",
#'   operator  = `<`,
#'   constant = 0.8
#' )
#'
#' anchor <- anchors(
#'   predicates = c(pred_1)
#' )
#'
#' samples <- data.frame(
#'   x = c(0.1, 0.3, 0.5, 0.7, 0.9)
#' )
#'
#' # A model function returning predictions for each sample.
#' model <- function(data) {
#'   ifelse(data$x > 0.5, "positive", "negative")
#' }
#'
#' # Calculate the prediction distribution among samples
#' # satisfying the anchor.
#' precision(anchor, model, samples)
#' @export
precision <- S7::new_generic(
  name = "precision",
  dispatch_args = "x",
  function(x, model, samples) {
    S7::S7_dispatch()
  }
)


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
