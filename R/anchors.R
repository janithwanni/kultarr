#' Defines a new `anchor` object
#'
#' @param predicates a vector of `predicate` objects
#' @return A new `anchors` object containing the properties `predicates`
#' @examples
#' # Create predicates and combine them into an anchor.
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
#'   predicates = c(pred_1, pred_2)
#' )
#'
#' anchor
#' @export
anchors <- S7::new_class(
  "anchors",
  properties = list(
    predicates = S7::class_vector # a vector of predicate class
  ),
  validator = function(self) {
    if (!all(sapply(self@predicates, \(x) S7::S7_inherits(x, predicate)))) {
      return(
        "The list of predicates should all inherit from the predicate class "
      )
    }
  }
)
