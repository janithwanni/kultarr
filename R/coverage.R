#' @export
coverage <- S7::new_generic("coverage", "x")
#' @param dist the function that can be used to generate samples by providing an argument n. Should return a dataframe with proper column names.
#' @param n_samples the number of samples to generate from `dist` (the perturbation distribution)
S7::method(coverage, anchors) <- function(x, dist, n_samples = 100) {
  samples <- dist(n = n_samples)
  return(mean(satisfies(x, samples)))
}
