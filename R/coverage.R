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
#'
#' @examples
#' # Create a simple anchor from two predicates.
#' pred_1 <- predicate(
#'   feature = "x",
#'   operator = `<`,
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
#' # Calculate the proportion of samples satisfying the anchor.
#' coverage(anchor, samples)
#'
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
