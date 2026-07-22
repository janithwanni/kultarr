# enable usage of <S7_object>@name in package code
#' @rawNamespace if (getRversion() < "4.3.0") importFrom("S7", "@")
NULL

.onLoad <- function(...) {
  S7::methods_register()
}

ignore_unused_imports <- function() {
  doclisting::methods_list
  tourr::grand_tour
}
