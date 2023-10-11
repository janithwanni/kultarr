#' @export
predicate <- S7::new_class(
  "predicate",
  properties = list(
    feature = S7::class_character,
    operator = S7::class_function,
    constant = S7::new_union(
      S7::class_integer,
      S7::class_double,
      S7::class_character
    )
  ),
  validator = function(self) {}
)
