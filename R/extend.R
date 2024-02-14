#' Generic function to extend anchors
#' @param x Object of S7 class anchors
#' @param pred Object of S7 class predicate
#' @rdname anchors
#' @export
extend <- S7::new_generic("extend", "x")
S7::method(extend, anchors) <- function(x, pred) {
  x@predicates <- c(x@predicates, pred)
  return(x)
}
