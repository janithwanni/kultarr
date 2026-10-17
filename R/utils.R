#' Generate Perturbations Around a Point of Interest
#'
#' @param data Training data frame
#' @param instance Row number of point of interest
#' @param interest_columns The columns of the dataset used for generating anchors
#' @param radius Perturbation radius (default: 0.1)
#' @param step Step size for perturbations (default: 0.01)
#'
#' @return A data frame of perturbed points
#' @keywords internal
#' @noRd
generate_perturbations <- function(
  data,
  instance,
  interest_columns,
  radius = 0.1,
  step = 0.01
) {
  local_obs <- instance
  perturb_params <- lapply(interest_columns, function(i) {
    col_max <- max(data[[i]], na.rm = TRUE)
    col_min <- min(data[[i]], na.rm = TRUE)
    seq(
      max(local_obs[[i]] - radius, col_min),
      min(local_obs[[i]] + radius, col_max),
      by = step
    )
  })
  names(perturb_params) <- interest_columns
  pertubs <- do.call(tidyr::expand_grid, perturb_params)
  return(pertubs)
}

#' Lookup function to get value of upper and lower bounds for the current state
#'
#' The current state of the exploration is marked based on the indices
#' in the list of each combination of column and lower and upper bound type.
#'
#' @param current_envir List of indexes, the current state
#' @param envir The current environment
#' @param interest_cols Columns of interest
#'
#' @return A tibble of 1 x (2*p) where p is the number of columns of interest
#' @keywords internal
#' @noRd
envir_to_bounds <- function(current_envir, envir, interest_cols) {
  bounds <- matrix(
    rep(NA, 2 * length(interest_cols))
  ) |>
    t() |>
    `colnames<-`(paste0("V", seq_len(2 * length(interest_cols)))) |>
    tibble::as_tibble()
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
#' @keywords internal
#' @noRd
update_bounds <- function(current_envir, envir, actions, selected_action) {
  new_bound <- current_envir + actions[[selected_action]]
  for (i in seq_along(new_bound)) {
    if (is.na(envir[[i]][new_bound[i]])) {
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
#' @keywords internal
#' @noRd
create_anchor_inst <- function(bounds, interest_cols) {
  pred_vec <- c()
  feat_vec <- rep(interest_cols, each = 2)
  op_vec <- rep(c(`>`, `<`), times = length(interest_cols))
  bound_var <- colnames(bounds)
  for (i in seq(1, length(feat_vec))) {
    pred_vec <- c(
      pred_vec,
      predicate(feat_vec[i], op_vec[i][[1]], constant = bounds[[bound_var[i]]])
    )
  }
  anchor_box <- anchors(pred_vec)
  return(anchor_box)
}

#' Generates lower and upper bounds around a given instance
#'
#' @param dataset Cutpoints will be generated from in between the points in the dataset
#' @param instance_data The actual instance of the data
#' @param interest_coluns The columns of `dataset` to consider when creating lower and upper bounds
#' @param bin_edges Output of `define_bin_edges` function
#'
#' @returns A list. Contains lower and upper bounds for each specific column of interest.
#' @keywords internal
#' @noRd
generate_environment <- function(
  dataset,
  instance_data,
  interest_columns,
  bin_edges
) {
  envir <- purrr::map(interest_columns, function(cname) {
    vals <- dataset[[cname]] |> sort()
    cutpoints <- bin_edges[[cname]]
    if (isit("verbose")) {
      logger::log_info("setting lower bounds")
    }

    v_l <- sort(
      cutpoints[cutpoints < instance_data[[cname]]],
      decreasing = TRUE
    )
    if (isit("verbose")) {
      logger::log_info(
        "Have {length(v_l)} lower bounds with {paste(head(v_l, collapse=','))}"
      )
    }

    if (length(v_l) == 0) {
      if (isit("verbose")) {
        logger::log_warn("setting lower bounds to max")
      }
      v_l <- min(dataset[[cname]]) - 1e-3
    }
    if (isit("verbose")) {
      logger::log_info("setting upper bounds")
    }
    v_u <- cutpoints[cutpoints > instance_data[[cname]]]
    if (isit("verbose")) {
      logger::log_info(
        "Have {length(v_u)} upper bounds with {paste(head(v_u, collapse=','))}"
      )
    }

    if (length(v_u) == 0) {
      if (isit("verbose")) {
        logger::log_warn("Setting upper bound to max")
      }
      v_u <- max(dataset[[cname]]) + 1e-3
    }
    envir <- list(v_l, v_u)
  }) |>
    purrr::list_flatten() |>
    stats::setNames(
      paste0(
        rep(interest_columns, each = 2),
        rep(c("_l", "_u"), times = length(interest_columns))
      )
    )
  return(envir)
}

#' Defines the bin edges for each interest column
#'
#'
#' @keywords internal
#' @noRd
define_bin_edges <- function(dataset, interest_columns, num_bins = 3) {
  edges <- purrr::map(interest_columns, function(cname) {
    values <- dataset[[cname]]
    # we set num_bins + 1 to delete a bin at the end
    probs <- seq(0, 1, length.out = num_bins + 1)
    breaks <- stats::quantile(values, probs = probs, na.rm = TRUE) |>
      stats::setNames(NULL)
    return(breaks)
  }) |>
    stats::setNames(interest_columns)
}

#' Index each row of a dataset into cells delimited by the cutpoints
#'
#' For each column the cutpoints of the lower and upper bounds are merged and
#' sorted as `c_1 < ... < c_m`. A value strictly between `c_k` and `c_{k+1}`
#' gets cell `2k + 1` and a value equal to `c_k` gets cell `2k`. A box
#' `c_a < x < c_b` then covers exactly the cells `2a + 1` to `2b - 1`.
#'
#' @param dataset Data frame of points to index
#' @param interest_columns Columns of interest
#' @param state_space Output of `generate_environment`
#'
#' @returns A list with the merged cutpoints `cuts` and the cell indices `idx`,
#'   both named by column.
#' @keywords internal
#' @noRd
bin_index <- function(dataset, interest_columns, state_space) {
  cuts <- purrr::map(interest_columns, function(cname) {
    c(state_space[[paste0(cname, "_l")]], state_space[[paste0(cname, "_u")]]) |>
      unique() |>
      sort()
  }) |>
    stats::setNames(interest_columns)
  idx <- purrr::map(interest_columns, function(cname) {
    v <- dataset[[cname]]
    cp <- cuts[[cname]]
    findInterval(v, cp) + findInterval(v, cp, left.open = TRUE) + 1L
  }) |>
    stats::setNames(interest_columns)
  return(list(cuts = cuts, idx = idx))
}

#' Builds cumulative count tables used to count points inside a box
#'
#' The tables are padded with a leading zero slice on every axis, so the count
#' of points in any box is an inclusion-exclusion sum over its 2^p corners.
#'
#' @param binned Output of `bin_index`
#' @param hits Logical vector. Whether each row is predicted as the target class
#'
#' @returns A list with the padded `dims`, their `strides` and the cumulative
#'   tables `total` and `hits`.
#' @keywords internal
#' @noRd
build_count_tables <- function(binned, hits) {
  dims <- purrr::map_int(binned$cuts, \(cp) 2L * length(cp) + 2L)
  strides <- cumprod(c(1, dims[-length(dims)]))
  lin <- 1 + Reduce(`+`, purrr::map2(binned$idx, strides, \(i, s) i * s))
  cum_count <- function(rows) {
    a <- tabulate(lin[rows], nbins = prod(dims))
    for (j in seq_along(dims)) {
      pre <- strides[j]
      post <- length(a) / (pre * dims[j])
      dim(a) <- c(pre, dims[j], post)
      for (k in seq_len(dims[j])[-1]) {
        a[, k, ] <- a[, k, ] + a[, k - 1, ]
      }
    }
    as.vector(a)
  }
  return(list(
    dims = dims,
    strides = strides,
    total = cum_count(rep(TRUE, length(lin))),
    hits = cum_count(hits)
  ))
}

#' Counts the points inside many boxes at once
#'
#' @param lo,hi Lists with one integer vector per column giving the first and
#'   last cell of each box (unpadded cell coordinates).
#' @param tables Output of `build_count_tables`
#'
#' @returns A list with the vectors `total` and `hits`, one entry per box.
#' @keywords internal
#' @noRd
box_counts <- function(lo, hi, tables) {
  p <- length(tables$dims)
  total <- 0
  hits <- 0
  for (corner in 0:(2^p - 1)) {
    use_lo <- bitwAnd(corner, 2^(seq_len(p) - 1)) > 0
    lin <- 1
    for (j in seq_len(p)) {
      coord <- if (use_lo[j]) lo[[j]] else hi[[j]] + 1
      lin <- lin + (coord - 1) * tables$strides[j]
    }
    sgn <- if (sum(use_lo) %% 2 == 0) 1 else -1
    total <- total + sgn * tables$total[lin]
    hits <- hits + sgn * tables$hits[lin]
  }
  return(list(total = total, hits = hits))
}

#' Removes cutpoints that can never give the best box
#'
#' Consider the slab of points between two neighbouring cutpoints of the same
#' bound, taken over the whole dataset. If every point in the slab is a hit,
#' moving the bound outwards over the slab never lowers precision and never
#' lowers coverage, so the inner cutpoint is dominated. If every point is a
#' miss, moving the bound outwards keeps `prec * cover` fixed and lowers
#' precision, so the outer cutpoint is dominated. Both hold for any position
#' of the other bounds, since a box only ever sees part of the slab. Dropping
#' dominated cutpoints therefore keeps the maximum reward of the search.
#'
#' @inheritParams bin_index
#' @param hits Logical vector. Whether each row is predicted as the target class
#'
#' @returns `state_space` with dominated cutpoints removed.
#' @keywords internal
#' @noRd
prune_state_space <- function(dataset, interest_columns, state_space, hits) {
  binned <- bin_index(dataset, interest_columns, state_space)
  for (cname in interest_columns) {
    idx <- binned$idx[[cname]]
    cuts <- binned$cuts[[cname]]
    n_cells <- 2L * length(cuts) + 1L
    cum_total <- c(0, cumsum(tabulate(idx, nbins = n_cells)))
    cum_hits <- c(0, cumsum(tabulate(idx[hits], nbins = n_cells)))
    for (side in c("_l", "_u")) {
      bound <- paste0(cname, side)
      pos <- match(state_space[[bound]], cuts)
      keep <- rep(TRUE, length(pos))
      for (i in seq_len(length(pos) - 1)) {
        # slab between cutpoint i and the next cutpoint outwards, including
        # points that lie on cutpoint i
        if (side == "_l") {
          first <- 2L * pos[i + 1] + 1L
          last <- 2L * pos[i]
        } else {
          first <- 2L * pos[i]
          last <- 2L * pos[i + 1] - 1L
        }
        n_total <- cum_total[last + 1] - cum_total[first]
        n_hits <- cum_hits[last + 1] - cum_hits[first]
        if (n_hits == n_total) {
          keep[i] <- FALSE
        } else if (n_hits == 0) {
          keep[i + 1] <- FALSE
        }
      }
      if (isit("verbose")) {
        logger::log_info("pruned {sum(!keep)} of {length(keep)} cutpoints of {bound}")
      }
      state_space[[bound]] <- state_space[[bound]][keep]
    }
  }
  return(state_space)
}

#' Function to validate if a created boundary satisfies a given instance row
#' @keywords internal
#' @noRd
validate_bound <- function(b, cols, instance_row) {
  if (any(is.na(b))) {
    return(FALSE)
  }
  b |>
    create_anchor_inst(cols) |>
    satisfies(instance_row)
}

#' Function to check option value
#' @keywords internal
#' @noRd
isit <- function(opt_name) {
  opt <- rlang::peek_option(paste0("kultarr.", opt_name))
  if (is.null(opt)) {
    return(FALSE)
  } else {
    return(opt)
  }
}
