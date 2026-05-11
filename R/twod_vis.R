#' @importFrom rlang .data
#' @export
rule_rect_layers <- function(
  rule_tbl,
  ...
) {
  rect_data <- rule_tbl |>
    tidyr::pivot_wider(
      names_from = .data$bound,
      values_from = c(.data$x, .data$y)
    ) |>
    dplyr::rename(
      xmin = .data$x_lower,
      ymin = .data$y_lower,
      xmax = .data$x_upper,
      ymax = .data$y_upper
    )

  list(
    ggplot2::geom_rect(
      data = rect_data,
      ggplot2::aes(
        xmin = .data$xmin,
        xmax = .data$xmax,
        ymin = .data$ymin,
        ymax = .data$ymax
      ),
      inherit.aes = FALSE,
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
vis_anchor <- function(anchors, dataset, instance, model_func) {
  lapply(anchors, function(anchor) {
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
        # TODO: This needs to be a box underneath the anchors
        # ggplot2::geom_point(
        #   data = anchor$perturbs |>
        #     dplyr::mutate(cls = model_func(anchor$perturbs)),
        #   ggplot2::aes(x = .data$x, y = .data$y, color = .data$cls),
        #   size = 0.1,
        #   alpha = 0.5
        # ) +
        rule_rect_layers(anchor$perturb_bounds) +
        rule_rect_layers(anchor$final_anchor)
    )
  })
}
