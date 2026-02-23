#' @export
coverage <- S7::new_generic("coverage", "x")

#' @title Generic function calculate coverage of an anchor
#' @description The coverage of an anchor is defined as average number of observations satisfied by an anchor
#' @param samples the dataset to test coverage on
#' @return Numeric. Coverage of anchor
#' @name coverage
#' @export
S7::method(coverage, anchors) <- function(x, samples) {
  return(mean(satisfies(x, samples)))
}
