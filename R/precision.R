#' Generic function to calculate precision of anchors
#' @param samples the dataset to test coverage on
#' @param model a predict function that will provide the predicted labels given a dataset
#' @param n_samples the number of samples to generate from `dist` (the perturbation distribution)
#' @return named vector of proportions
#' @rdname anchors
#' @export
precision <- S7::new_generic("precision", "x")
S7::method(precision, anchors) <- function(x, model, samples, n_samples = 100) {
  # print("Getting precision for anchor")
  # print(x)
  satisfying_rows <- which(satisfies(x, samples), arr.ind = TRUE)
  samples <- samples |>
    dplyr::slice(satisfying_rows)
  # print("sending samples")
  # print(head(samples))
  preds <- model(samples)
  # print("Precision")
  # print(head(preds))
  tab_preds <- table(preds)
  # print("table preds")
  # print(tab_preds)
  prop <- as.vector(tab_preds / sum(tab_preds))
  # print(prop)
  return(prop = prop)
}
