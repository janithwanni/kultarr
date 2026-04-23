#' Make anchors
#'
#' This function is the main entrypoint that generates anchors by running a Breadth First Search algorithm
#'
#' @param dataset Dataset to use containing predictors and response variables.
#' @param cols Columns of interest
#' @param instance A tibble row containing the instance to interpret, can be a dataframe containing multiple rows
#' @param model_func Function that gives takes in any data and the model to give predictions
#' @param class_col Name of factor column containing class of interest
#' @param n_bins Number of bins used for binning the perturbation distribution. A higher bin size would make granular anchors but will increase computation time.
#' @param seed Numeric. Seed to ensure that the results stay consistent
#' @param verbose Logical. Whether to print out diagnostics of the Multi-Armed Bandit Algorithm
#' @param parallel Logical. Whether to use parallel processing. Default set to FALSE.
#' @param progress Logical. Whether to show a bar progress bar when performing parallel computation
#' @param perturb_distance Numeric. The distance from the given instance to start creating perturbations
#' @param perturb_step Numeric. The step size to create the grid of points around the given instance
#'
#' @return A list containing the final anchor which is a data.frame of size 2 x (p+1) where p is the number of columns of interest with each row containing a upper. lower bound, the reward history which contains the reward history for each node traversed and the perturbations generated
#' @export
make_anchors <- function(
  dataset,
  cols,
  instance,
  model_func,
  class_col,
  n_bins = 4,
  seed = 145,
  verbose = FALSE,
  parallel = FALSE,
  progress = FALSE,
  perturb_distance = 0.1,
  perturb_step = 0.01
) {
  # TODO: Assert if instance is a dataframe and has more than 0 rows
  if (progress) {
    p <- progressr::progressor(steps = nrow(instance))
  }

  # bin_edges <- define_bin_edges(dataset, cols, n_bins)
  logger::log_info("setting up bin edges")
  # print(bin_edges)

  if (parallel) {
    future::plan("multisession")
    final_bounds <- furrr::future_map(
      seq_len(nrow(instance)),
      function(i) {
        if (progress) {
          p()
        }
        inst <- instance[i, ]
        make_single_anchor(
          dataset = dataset,
          cols = cols,
          inst,
          model_func = model_func,
          class_col = class_col,
          n_bins = n_bins,
          seed = seed,
          verbose = verbose,
          perturb_distance = perturb_distance,
          perturb_step = perturb_step
        )
      },
      .options = furrr::furrr_options(seed = seed)
    )
  } else {
    future::plan("sequential")
    final_bounds <- purrr::map(
      seq_len(nrow(instance)),
      function(i) {
        if (progress) {
          p()
        }
        inst <- instance[i, ]
        make_single_anchor(
          dataset = dataset,
          cols = cols,
          inst,
          model_func = model_func,
          class_col = class_col,
          n_bins = n_bins,
          seed = seed,
          verbose = verbose,
          perturb_distance = perturb_distance,
          perturb_step = perturb_step
        )
      }
    )
  }
  return(list(
    final_anchor = final_bounds |> purrr::map_dfr(~ .x[["final_anchor"]]),
    reward_history = final_bounds |> purrr::map_dfr(~ .x[["history"]]),
    perturbs = final_bounds |> purrr::map_dfr(~ .x[["perturbs"]])
  ))
}

#' @keywords internal
#' @noRd
make_single_anchor <- function(
  dataset,
  cols,
  instance,
  model_func,
  class_col,
  n_bins = 4,
  seed = 145,
  verbose = FALSE,
  perturb_distance = 0.1,
  perturb_step = 0.01
) {
  cls_levels <- dataset[[class_col]] |> levels()
  inst_pred <- model_func(instance[, c(cols)])
  class_ind <- match(as.character(inst_pred), cls_levels)
  perturbs <- generate_perturbations(
    dataset,
    instance,
    cols,
    perturb_distance,
    perturb_step
  )
  # perturbs[instance, cols] <- dataset[instance, cols]
  bin_edges <- define_bin_edges(perturbs, cols, n_bins)
  state_space <- generate_environment(
    perturbs,
    instance,
    cols,
    bin_edges
  )
  start_state <- rep(1, 2 * length(cols))
  bfs_results <- run_bfs(
    start_state,
    perturbs,
    state_space,
    cols,
    model_func,
    class_ind,
    seed = seed,
    verbose = verbose
  )

  final_bounds <- bfs_results[["final_anchor"]]
  if (!validate_bound(final_bounds, cols, instance[, cols])) {
    cli::cli_alert_warning("Found an invalid bound")
    # print(final_bounds) final_bounds <- rep(1, 2 * length(cols)) |>
    # envir_to_bounds(state_space, cols)
  }
  lower_bound <- final_bounds |> dplyr::select(tidyselect::ends_with("_l"))
  colnames(lower_bound) <- gsub("_l$", "", colnames(lower_bound))
  upper_bound <- final_bounds |> dplyr::select(tidyselect::ends_with("_u"))
  colnames(upper_bound) <- gsub("_u$", "", colnames(upper_bound))

  instance_lbl <- uuid::UUIDgenerate(instance)

  anchor_df <- rbind(
    lower_bound |> dplyr::mutate(bound = "lower"),
    upper_bound |> dplyr::mutate(bound = "upper")
  ) |>
    dplyr::mutate(id = instance_lbl, .before = 1) |>
    dplyr::mutate(
      reward = final_bounds$reward,
      prec = final_bounds$prec,
      cover = final_bounds$cover
    )

  perturb_bounds <- rbind(
    perturbs |>
      dplyr::summarise(dplyr::across(tidyselect::all_of(cols), min)) |>
      dplyr::mutate(bound = "lower"),
    perturbs |>
      dplyr::summarise(dplyr::across(tidyselect::all_of(cols), max)) |>
      dplyr::mutate(bound = "upper")
  )

  return(
    list(
      final_anchor = anchor_df,
      history = bfs_results[["reward_history"]] |>
        dplyr::mutate(id = instance_lbl),
      perturbs = perturbs |>
        dplyr::mutate(id = instance_lbl, preds = model_func(perturbs[, cols])),
      perturb_bounds = perturb_bounds
    )
  )
}
