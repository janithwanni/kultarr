#' Add rectangular layers from rule boundaries
#'
#' Converts a table of lower and upper x/y boundaries into rectangular
#' `ggplot2` layers.
#'
#' @param rule_tbl A data frame containing `x`, `y`, and `bound` columns.
#'   The `bound` column should contain `"lower"` and `"upper"` values.
#' @param ... Additional arguments passed to [ggplot2::geom_rect()].
#'
#' @return A list containing a `ggplot2::geom_rect()` layer.
#'
#' @examples
#' rule_tbl <- tibble::tribble(
#'   ~bound,  ~x, ~y,
#'   "lower",  1,  2,
#'   "upper",  4,  6
#' )
#'
#' ggplot2::ggplot() +
#'   rule_rect_layers(
#'     rule_tbl,
#'     fill = "steelblue",
#'     alpha = 0.3
#'   )
#'
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
      mapping = ggplot2::aes(
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
#'
#' @param anchors The result of `make_anchors()` function call.
#' @param dataset The dataset passed to `make_anchors()`
#' @param instance The point of interest
#' @param model_func A crate object containing the prediction function of the modelfor visualisation
#' @return A ggplot object
#' @importFrom rlang .data
#' @export
vis_anchor <- function(anchors, dataset, instance, model_func) {
  lapply(anchors, function(anchor) {
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
      rule_rect_layers(anchor$perturb_bounds) +
      rule_rect_layers(anchor$final_anchor)
  })
}
