#' @export
extend <- S7::new_generic("extend", "x")
#' @param pred The predicate to extend x with
#' @return Extended anchor
S7::method(extend, anchors) <- function(x, pred) {
  x@predicates <- c(x@predicates, pred)
  return(x)
}
