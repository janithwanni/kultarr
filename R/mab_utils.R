#' Lookup function to get value of upper and lower bounds for the current state
#' 
#' The current state of the multi armed bandit is marked based on the indices
#' in the list of each combination of column and lower and upper bound type.
#' @export
envir_to_bounds <- function(current_envir, envir, interest_cols) {
  bounds <- matrix(
    rep(NA, 2 * length(interest_cols))
  ) |>
    t() |>
    as_tibble()
  for (i in seq_along(current_envir)) {
    bounds[1, i] <- envir[[i]][current_envir[i]]
  }
  colnames(bounds) <- names(envir)
  return(bounds)
}

#' Advance the current environment
#' 
#' @param current_envir List of indexes, the current state
#' @param selected_action The index of selected action from the actions list
#' 
#' @return New bounds
#' @export
update_bounds <- function(current_envir, envir, actions, selected_action) {
  new_bound <- current_envir + actions[[selected_action]]
  for(i in seq_along(new_bound)) {
    if(is.na(envir[[i]][new_bound[i]])) {
      new_bound[i] <- current_envir[i]
    }
  }
  return(new_bound)
}

#' Creates an instance of the anchor class
#' 
#' @param bounds The upper and lower bounds of each column of interest
#' @param interest_cols the columns of interest
#' 
#' @return an instance of the anchor class
#' @export
create_anchor_inst <- function(bounds, interest_cols) {
  pred_vec <- c()
  feat_vec <- rep(interest_cols, each = 2)
  op_vec <- rep(c(`>`, `<`), times = length(interest_cols))
  bound_var <- colnames(bounds)
  for (i in seq(1, length(feat_vec))) {
    pred_vec <- c(pred_vec, predicate(feat_vec[i], op_vec[i][[1]], constant = bounds[[bound_var[i]]]))
  }
  anchor_box <- anchors(pred_vec)
  return(anchor_box)
}

#' Generates lower and upper bounds around a given instance
#'
#' @param dataset Cutpoints will be generated from in between the points in the dataset
#' @param instance_id The index of the instance of interest
#' @param interest_coluns The columns of `dataset` to consider when creating lower and upper bounds
#'
#' @returns A list. Contains lower and upper bounds for each specific column of interest.
#' @export
generate_cutpoints <- function(dataset, instance_id, interest_columns) {
  envir <- purrr::map(interest_columns, function(cname) {
    vals <- dataset[-instance_id, ][[cname]] |> sort()
    cutpoints <- purrr::map2_dbl(vals[-length(vals)], vals[-1], function(x, x_1) {
      return(mean(c(x, x_1)))
    })
    v_l <- sort(
      cutpoints[cutpoints < dataset[instance_id, ][[cname]]],
      decreasing = TRUE
    )
    v_u <- cutpoints[cutpoints > dataset[instance_id, ][[cname]]]
    list(v_l, v_u)
  }) |>
    purrr::list_flatten() |>
    setNames(
      paste0(
        rep(interest_columns, each = 2),
        rep(c("_l", "_u"), times = length(interest_columns))
      )
    )
}

#' Make perturbation distribution function
#' 
#' @param n 
#' @param interest_cols
#' @param dataset
#' @param instance_id
#' @param seed
#' 
#' @return A purrr partial function that takes in N and returns N number of sample points around the instance
#' @export
make_perturb_distn <- function(n, interest_cols, dataset, instance_id, seed = 123) {
  distn_partial <- function(n, interest_cols, dataset, instance_id) {
    pertub_func <- function(n, interest_cols, dataset, instance_id) { 
      out <- mulgar::rmvn(n = n, 
                  p = length(interest_cols),
                  mn = dataset[instance_id, interest_cols] |> 
                    unlist(),
                  vc = cov(dataset[,interest_cols])
      ) |>
        as.data.frame()
      colnames(out) <- interest_cols
      return(as_tibble(out))
    }
    set.seed(seed)
    samples <- pertub_func(n = (n * 10), interest_cols, dataset, instance_id)
    samples[1:n, ]
  }
  dist_func <- purrr::partial(
    distn_partial,
    interest_cols = interest_cols,
    dataset = dataset,
    instance_id = instance_id
  )
  return(dist_func)
}