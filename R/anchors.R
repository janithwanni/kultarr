#' S7 class to define anchors
#' @param predicates a vector of objects with the S7 class of predicate
#' @return Object of S7 class anchors
#' @rdname anchors
#' @export
anchors <- S7::new_class(
  "anchors",
  properties = list(
    predicates = S7::class_vector # a vector of predicate class
  ),
  validator = function(self) {
    # print(class(self$predicates))
    # if (!all(sapply(self@predicates, \(x) S7::S7_inherits(x, predicate)))) {
    #   return(
    #     "The list of predicates should all inherit from the predicate class "
    #   )
    # }
  }
)
