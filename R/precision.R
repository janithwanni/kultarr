#' Generic function to calculate precision of anchors
#' @param model a predict function that will provide the predicted labels given a dataset
#' @param dist the function that can be used to generate samples by providing an argument n. Should return a dataframe with proper column names.
#' @param n_samples the number of samples to generate from `dist` (the perturbation distribution)
#' @return named vector of proportions
#' @rdname anchors
#' @export
precision <- S7::new_generic("precision", "x")
S7::method(precision, anchors) <- function(x, model, dist, n_samples = 100) {
  samples <- dist(n = n_samples)
  satisfying_rows <- which(satisfies(x, samples), arr.ind = TRUE)
  samples <- samples |>
    dplyr::slice(satisfying_rows)
  preds <- model(samples)
  return(prop = as.vector(table(preds) / sum(table(preds))))
}
