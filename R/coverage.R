#' Generic function calculate coverage of an anchor
#' @param samples the dataset to test coverage on
#' @param n_samples the number of samples to generate from `dist` (the perturbation distribution)
#' @return Numeric. Coverage of anchor
#' @rdname anchors
#' @export
coverage <- S7::new_generic("coverage", "x")
S7::method(coverage, anchors) <- function(x, samples) {
  return(mean(satisfies(x, samples)))
}
