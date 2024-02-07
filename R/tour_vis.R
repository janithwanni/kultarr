#' @export 
bounding_box <- S7::new_class(
  "bounding_box",
  properties = list(
    raw_data = S7::class_data.frame,
    target_inst_row = S7::class_data.frame,
    box = S7::class_list,
    point_colors = S7::class_vector
  ),
  #' @param bounds_tbl Tibble containing two rows and (p+1) columns of p predictors
  #' @param target_inst_row Tibble of one row and p columns for the target instance
  #' @param point_colors Vector of 2^p length or 1 value
  constructor = function(bounds_tbl, target_inst_row, point_colors) {
    n_box_points <- 2^(ncol(target_inst_row))
    if(!length(point_colors) != 1 && !length(point_colors) != n_box_points) {
      cli::cli_abort(c(
        "point_colors argument should be vector of either 2^p length or 1",
        "i" = "There {?is/are} {length(point_colors)} only element{?s}"
      ))
    }
    cube <- geozoo::cube.iterate(p = ncol(target_inst_row))
    bounds_list <- bounds_tbl |>
      dplyr::select(
        tidyselect::all_of(colnames(target_inst_row))
      ) |> as.list()
    bounds_box <- do.call(expand.grid, bounds_list)
    cube$points <- bounds_box

    if(length(point_colors) == 1) {
      point_colors <- rep(point_colors, nrow(bounds_box))
    }

    S7::new_object(
      S7::S7_object(),
      raw_data = as.data.frame(bounds_tbl),
      target_inst_row = as.data.frame(target_inst_row),
      box = list(points = cube$points, edges = cube$edges),
      point_colors = point_colors
    )
  }
)

#' @export 
bounding_boxes <- S7::new_class(
  "bounding_boxes",
  properties = list(
    boxes = S7::class_vector # a vector of bounding box class
  ),
  validator = function(self) {
    if (!all(sapply(self@boxes, \(x) S7::S7_inherits(x, bounding_box)))) {
      return(
        "The list of boxes should all inherit from the box class"
      )
    }
  }
)

#' @export
anchor_tour <- S7::new_class(
  "anchor_tour",
  properties = list(
    raw_boxes = S7::new_union(bounding_box, bounding_boxes),
    raw_data = S7::class_data.frame,
    tour_vis_data = S7::class_list,
    tour_vis_colors = S7::class_vector,
    box_indices = S7::class_vector
  ),
  #' @param b_boxes S7 object of type boundary boxes
  #' @param data data.frame of points to visualize on tours
  #' @param point_colors Vector of one or nrow(data)
  constructor = function(b_boxes, data, point_colors) {
    if(!length(point_colors) != 1 && !length(point_colors) != nrow(data)) {
      cli::cli_abort(c(
        "point_colors argument should be vector of either length 1 or nrow(data)",
        "i" = "There {?is/are} {length(point_colors)} only element{?s}"
      ))
    }
    tour_vis_points <- NULL # the bounding box points are added first
    tour_vis_edges <- NULL # the bounding box edges are added with edge counts 
    tour_vis_colors <- NULL # the colors of the 
    increment <- 0
    box_indices <- c()
    if (S7::S7_inherits(b_boxes, bounding_box)) {
      b_boxes <- bounding_boxes(c(b_boxes))
    }
    for(b_box in b_boxes@boxes) {
      # Need to ensure that the 
      # edges are always updated with the number of points 
      # that were used in the previous bounding box
      tour_vis_points <- rbind(tour_vis_points, b_box@box$points)
      tour_vis_edges <- rbind(tour_vis_edges, b_box@box$edges + increment)
      increment <- nrow(b_box@box$edges)
      box_indices <- c(box_indices, increment)

      tour_vis_colors <- c(tour_vis_colors, b_box@point_colors)
    }
    tour_vis_points <- rbind(tour_vis_points, data)
    if(length(point_colors) == 1) {
      point_colors <- rep(point_colors, nrow(data))
    }
    tour_vis_colors <- c(tour_vis_colors, point_colors)

    S7::new_object(
      S7::S7_object(),
      raw_boxes = b_boxes,
      raw_data = data,
      tour_vis_data = list(
        points = tour_vis_points,
        edges = tour_vis_edges
      ),
      tour_vis_colors = tour_vis_colors,
      box_indices = box_indices
    )
  }
)

#' @export
animate_anchor <- S7::new_generic("animate", "x")
#' @param x An object of type anchor_tour
#' @param gif_file The file location to save the gif file
#' @param tour_path An object of type 'tour_path' from the tourr package. Defaults to grand_tour()
#' @param width the width of the gif file. Defaults to 500
#' @param height the height of the gif file. Defaults to 500
#' @param frames the number of frames to be included in the gif file. Defaults to 360
#' @param loop Logical. Defaults to TRUE
#' @param ... Additional arguments passed to display_xy
#' 
#' @return None. Saves GIF at file location
S7::method(animate_anchor, anchor_tour) <- function(
  x,
  gif_file,
  tour_path = tourr::grand_tour(),
  width = 500, 
  height = 500, 
  frames = 360, 
  loop = TRUE,
  rescale = TRUE,
  ...
) {
  if(rescale) {
    data <- x@tour_vis_data$points |> tourr::rescale() 
  } else {
    data <- x@tour_vis_data$points
  }
  tourr::render_gif(
    data = data,
    tour_path = tourr::grand_tour(),
    tourr::display_xy(
      col = x@tour_vis_colors,
      edges = x@tour_vis_data$edges
    ),
    gif_file = gif_file,
    loop = loop,
    width = width,
    height = height,
    frames = frames
  )
}