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
    cube <- geozoo::cube.iterate(p = ncol(target_inst_row))
    bounds_list <- bounds_tbl |>
      dplyr::select(
        tidyselect::all_of(ncol(target_inst_row))
      ) |> as.list()
    bounds_box <- do.call(bounds_list, expand.grid)
    cube$points <- bounds_box

    S7::new_object(
      S7::object(),
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
    if (!all(sapply(self@boxes, \(x) S7::S7_inherits(x, bounding_box))) {
      return(
        "The list of boxes should all inherit from the box class"
      )
    })
  }
)

#' @export
tour_anchor <- S7::new_class(
  "tour_anchor",
  properties = list(
    raw_boxes = S7::class_list,
    raw_data = S7::class_data.frame,
    tour_vis_data = S7::class_list,
    tour_vis_colors = S7::class_vector,
    box_indices = S7::class_vector
  ),
  validator = function(self) {
    if(!S7::S7_inherits(self@boundary_boxes, boundary_boxes)) {
      return("The boundary boxes argument must be a object of class boundary boxes")
    }
  }
  #' @param boundary_boxes S7 object of type
  #' param
  constructor = function(boundary_boxes, data, point_colors) {
    tour_vis_points <- NULL # the bounding box points are added first
    tour_vis_edges <- NULL # the bounding box edges are added with edge counts 
    tour_vis_colors <- NULL # the colors of the 
    increment <- 0
    for(boundary_box in boundary_boxes@boxes) {
      # Need to ensure that the 
      # edges are always updated with the number of points 
      # that were used in the previous bounding box
      tour_vis_points <- rbind(tour_vis_points, boundary_box@box$points)
      tour_vis_edges <- rbind(tour_vis_edges, boundary_box@box$edges + increment)
      increment <- nrow(boundary_box@box$edges)

      tour_vis_colors <- c(tour_vis_colors, boundary_box@point_colors)
    }
    tour_vis_points <- rbind(tour_vis_points, data)
    tour_vis_colors <- rbind(tour_vis_colors, point_colors)

    S7::new_object(
      S7::S7_object(),
      raw_boxes = boundary_boxes,
      raw_data = data,
      tour_vis_data = list(
        points = tour_vis_points,
        edges = tour_vis_edges
      )
      tour_vis_colors = tour_vis_colors
    )
  }
)

#' @export
animate_anchor <- S7::new_generic("animate", "x")
#' @param x An object of type tour_anchor
#' @param gif_file The file location to save the gif file
#' @param width the width of the gif file
#' @param height the height of the gif file
#' @param frames the number of frames to be included in the gif file
#' @param loop Logical. Defaults to TRUE
#' @return None. Saves GIF at file location
S7::method(animate_anchor, tour_anchor) <- function(
  x,
  gif_file, 
  width, 
  height, 
  frames, 
  loop = TRUE
) {
  tourr::render_gif(
    data = tour_anchor@tour_vis_data$points,
    tour_path = tourr::grand_tour(),
    tourr::display_xy(
      col = tour_anchor@tour_vis_colors,
      edges = tour_anchor@tour_vis_data$edges
    ),
    loop = loop,
    width = width,
    height = height,
    frames = frames
  )
}