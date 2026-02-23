#' @title Defines a new `anchor` object
#' @param predicates a vector of `predicate` objects
#' @return A new `anchors` object containing the properties `predicates`
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
