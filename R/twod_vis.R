#' @importFrom rlang .data
#' @noRd
rule_rect_layers <- function(
  rule_tbl,
  fill = "#ffffff00",
  alpha = 0,
  color = "steelblue4",
  ...
) {
  lower <- rule_tbl |> dplyr::filter(.data$bound == "lower")
  upper <- rule_tbl |> dplyr::filter(.data$bound == "upper")

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
      linewidth = 0.8,
      ...
    )
  )
}

#' Visualize the anchor in two dimensional space
#' @param anchor The result of `make_anchors()` function call.
#' @param dataset The dataset passed to `make_anchors()`
#' @param instance The point of interest
#' @param model_func A crate object containing the prediction function of the modelfor visualisation
#' @return A ggplot object
#' @importFrom rlang .data
#' @export
vis_anchor <- function(anchor, dataset, instance, model_func) {
  return(
    ggplot2::ggplot() +
      ggplot2::geom_point(
        data = dataset,
        ggplot2::aes(x = .data$x, y = .data$y, color = .data$cls)
      ) +
      ggplot2::geom_point(
        data = dataset[instance, ],
        ggplot2::aes(x = .data$x, y = .data$y, color = .data$cls),
        size = 3
      ) +
      ggplot2::geom_point(
        data = anchor$perturbs |>
          dplyr::mutate(cls = model_func(anchor$perturbs)),
        ggplot2::aes(x = .data$x, y = .data$y, color = .data$cls),
        size = 0.1,
        alpha = 0.5
      ) +
      rule_rect_layers(anchor$final_anchor)
  )
}
