#' Extend an anchor
#'
#' @description
#' `extend()` adds a new predicate to an anchor's existing set of
#' predicates, returning an updated `anchors` object.
#'
#' # Methods
#'
#' `extend()` is an S7 generic with methods available for the following
#' classes:
#'
#' `r doclisting::methods_list("extend")`
#'
#' @param x Object of S7 class `anchors`.
#' @param pred Object of S7 class `predicate`.
#' @returns An `anchors` object with the additional predicate.
#' @examples
#' pred_1 <- predicate(
#'   feature = "x",
#'   operator = `>`,
#'   constant = 0.8
#' )
#'
#' pred_2 <- predicate(
#'   feature = "y",
#'   operator = `<`,
#'   constant = 0.9
#' )
#'
#' anchor <- anchors(
#'   predicates = c(pred_1)
#' )
#'
#' # Add another predicate to the anchor.
#' extended_anchor <- extend(anchor, pred_2)
#'
#' extended_anchor
#'
#' @export
extend <- S7::new_generic(
  name = "extend",
  dispatch_args = "x",
  function(x, pred) {
    S7::S7_dispatch()
  }
)

#' @rdname extend
S7::method(extend, anchors) <- function(x, pred) {
  x@predicates <- c(x@predicates, pred)
  return(x)
}
