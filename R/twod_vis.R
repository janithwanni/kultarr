#' @export
rule_rect_layers <- function(
  rule_tbl,
  fill = "#ffffff00",
  alpha = 0,
  color = "steelblue4"
) {
  lower <- rule_tbl |> dplyr::filter(bound == "lower")
  upper <- rule_tbl |> dplyr::filter(bound == "upper")

  list(
    ggplot2::geom_rect(
      ggplot2::aes(
        xmin = lower$x,
        xmax = upper$x,
        ymin = lower$y,
        ymax = upper$y
      ),
      fill = fill,
      alpha = alpha,
      color = color,
      linewidth = 0.8
    )
  )
}
