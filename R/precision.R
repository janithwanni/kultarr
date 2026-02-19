#' Generic function to calculate precision of anchors
#' @param samples the dataset to test coverage on
#' @param model a predict function that will provide the predicted labels given a dataset
#' @param n_samples the number of samples to generate from `dist` (the perturbation distribution)
#' @return named vector of proportions
#' @rdname anchors
#' @export
precision <- S7::new_generic("precision", "x")
S7::method(precision, anchors) <- function(x, model, samples) {
  satisfying_rows <- which(satisfies(x, samples), arr.ind = TRUE)
  samples <- samples |>
    dplyr::slice(satisfying_rows)
  preds <- model(samples)
  tab_preds <- table(preds)
  prop <- as.vector(tab_preds / sum(tab_preds))
  return(prop = prop)
}
