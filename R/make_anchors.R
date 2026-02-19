#' Make anchors
#'
#' This function is the main entrypoint that generates anchors by running a Multi-Armed Bandit algorithm
#'
#' @param dataset Dataset to use containing predictors and response variables.
#' @param cols Columns of interest
#' @param instance Id of the instance of interest in the training dataset
#' @param model_func Function that gives takes in any data and the model to give predictions
#' @param class_col Name of factor column containing class of interest
#' @param n_perturb_samples number of samples to be taken from the pertubation distribution
#' @param n_games Numeric. Number of games to play. Default to 20 games
#' @param n_epochs Numeric. Number of epochs in a single game. Default to 100 epochs.
#' @param seed Numeric. Seed to be used for the Multi-Armed Bandit algorithm.
#' This ensures that the results stay consistent
#' @param verbose Logical. Whether to print out diagnostics of the Multi-Armed Bandit Algorithm
#' @param parallel Logical. Whether to use parallel processing. Default set to FALSE.
#'
#' @return A data.frame of size 2 x (p+1) where p is the number of columns of interest with each row containing a upper. lower bound.
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
  progress = FALSE
) {
  if (progress) {
    p <- progressr::progressor(steps = length(instance))
  }

  # bin_edges <- define_bin_edges(dataset, cols, n_bins)
  logger::log_info("setting up bin edges")
  # print(bin_edges)

  if (parallel) {
    future::plan("multisession")
    final_bounds <- furrr::future_map(
      instance,
      function(i) {
        if (progress) {
          p()
        }
        make_single_anchor(
          dataset = dataset,
          cols = cols,
          i,
          model_func = model_func,
          class_col = class_col,
          n_bins = n_bins,
          seed = seed,
          verbose = verbose
        )
      },
      .options = furrr::furrr_options(seed = seed)
    )
  } else {
    future::plan("sequential")
    final_bounds <- purrr::map(
      instance,
      function(i) {
        if (progress) {
          p()
        }
        make_single_anchor(
          dataset = dataset,
          cols = cols,
          i,
          model_func = model_func,
          class_col = class_col,
          n_bins = n_bins,
          seed = seed,
          verbose = verbose
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
  n_bins,
  seed = 145,
  verbose = FALSE
) {
  cls_levels <- dataset[[class_col]] |> levels()
  inst_pred <- model_func(dataset[instance, c(cols)])
  class_ind <- match(as.character(inst_pred), cls_levels)
  perturbs <- generate_perturbations(dataset, instance, cols)
  perturbs[instance, cols] <- dataset[instance, cols]
  bin_edges <- define_bin_edges(perturbs, cols, n_bins)
  state_space <- generate_environment(perturbs, instance, cols, bin_edges)
  start_state <- rep(1, 2 * length(cols))
  bfs_results <- run_bfs(
    start_state,
    perturbs,
    instance,
    state_space,
    cols,
    model_func,
    class_ind,
    seed = seed,
    verbose = verbose
  )

  final_bounds <- bfs_results[["final_anchor"]]
  if (!validate_bound(final_bounds, perturbs[instance, cols])) {
    # WARN: Send warning that the final bound
    cli::cli_alert_warning("Found an invalid bound")
    # print(final_bounds) final_bounds <- rep(1, 2 * length(cols)) |>
    # envir_to_bounds(state_space, cols)
  }
  lower_bound <- final_bounds |> dplyr::select(tidyselect::ends_with("_l"))
  colnames(lower_bound) <- gsub("_l$", "", colnames(lower_bound))
  upper_bound <- final_bounds |> dplyr::select(tidyselect::ends_with("_u"))
  colnames(upper_bound) <- gsub("_u$", "", colnames(upper_bound))

  anchor_df <- rbind(
    lower_bound |> dplyr::mutate(bound = "lower"),
    upper_bound |> dplyr::mutate(bound = "upper")
  ) |>
    dplyr::mutate(id = instance, .before = 1) |>
    dplyr::mutate(
      reward = final_bounds$reward,
      prec = final_bounds$prec,
      cover = final_bounds$cover
    )

  return(
    list(
      final_anchor = anchor_df,
      history = bfs_results[["reward_history"]] |> dplyr::mutate(id = instance),
      perturbs = perturbs |> dplyr::mutate(id = instance)
    )
  )
}
