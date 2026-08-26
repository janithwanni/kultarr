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
#' @param x Object of S7 class `anchors`.
#' @param pred Object of S7 class `predicate`.
#' @returns An `anchors` object with the additional predicate.
#' @export
extend <- S7::new_generic(
  name = "extend",
  dispatch_args = "x",
  function(x, pred) {
    S7::S7_dispatch()
  }
)

#' @rdname extend
S7::method(extend, S7::class_any) <- function(x, pred) {
  stop("Unimplemented.")
}

#' @rdname extend
S7::method(extend, anchors) <- function(x, pred) {
  x@predicates <- c(x@predicates, pred)
  return(x)
}
