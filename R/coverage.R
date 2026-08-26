#' Generic function calculate coverage of an anchor
#'
#' @description The coverage of an anchor is defined as average number of observations satisfied by an anchor
#' # Methods
#' `coverage()` is an S7 generic with methods available for the following classes:
#'
#' `r doclisting::methods_list("coverage")`
#'
#' @param x anchors object
#' @param samples the dataset to test coverage on
#' @return Numeric. Coverage of anchor
#' @export
coverage <- S7::new_generic(
  name = "coverage",
  dispatch_args = "x",
  function(x, samples) {
    S7::S7_dispatch()
  }
)

#' @rdname coverage
S7::method(coverage, anchors) <- function(x, samples) {
  return(mean(satisfies(x, samples)))
}
