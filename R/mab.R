#' Reward function for Multi Armed Bandit. 
#' 
#' This is an internal function 
#'
#' @param new_anchor Object of class anchor.
#' @param round Numerical. A value to round the coverage by.
#' @param dist_func Function that takes n as an argument and returns 
#' a data.frame of size n x p where p is the number of variables in the dataset
#' @param model_func Function that takes in a data.frame of size m x p 
#' where m is the number of rows and p is the number of variables in the dataset 
#' and returns a vector of predictions of size m x 1
#' @param dataset Data frame used in the algorithm
#' @param instance_id The row index of the target instance in the `dataset` argument
#' @param class_ind Numeric. The index of the required class when ordered alphabetically
#' @param verbose Logical. Whether to print out diagnostics of the Multi-Armed Bandit Algorithm
#'
#' @return List containing the reward, the precision and the coverage
#' 
#' @export
get_reward <- function(
    new_anchor,
    round,
    dist_func,
    model_func,
    dataset,
    instance_id,
    class_ind = 1,
    verbose) {
  # cover <- coverage_area(new_anchor, train_df |> select(all_of(interest_cols)))
  cover <- coverage(new_anchor, dist_func, n_samples = 10000)
  prec <- precision(new_anchor, model_func, dist_func, n_samples = 10000)
  prec <- prec[class_ind]
  if (is.null(prec) | is.na(prec)) prec <- 0
  if (prec < 0.5) prec <- 0
  if (is.infinite(cover)) cover <- 0
  if(verbose) {
    print(glue::glue(
      "==== {cover} | {prec} | {mean(c(cover, prec), na.rm = TRUE) }====="
    ))
  }
  return(list(
    reward = as.numeric(satisfies(new_anchor, dataset[instance_id, ])) *
      mean(c(cover / round, prec), na.rm = TRUE),
    # prec,
    prec = prec, cover = cover
  ))
}

get_reward_faster <- memoise::memoise(get_reward)

#' Function to decide on the appropriate actions
#' 
#' @param n_actions Number of possible actions
#' @param success_probs Numeric vector with length equal to n_actions containing values between 0-1
#' @param failure_probs Numeric vector with length equal to n_actions containing values between 0-1
#' @return Numeric value in the range of 1 to n_actions
#' 
#' @export
select_action <- function(n_actions, success_probs, failure_probs) {
  r <- vector(mode = "numeric", length = n_actions)
  for (i_action in seq_len(n_actions)) {
    r[i_action] <- rbeta(1, shape1 = success_probs[i_action], failure_probs[i_action])
  }
  selected_action <- which.max(r)
  return(selected_action)
}

#' Run Multi-Armed bandit algorithm
#' 
#' @param n_games Numeric. Number of games to play
#' @param n_epochs Numeric. Number of epochs in a single game
#' @param dataset The dataset to run algorithm on
#' @param instance_id The index of the target observation in the datasert
#' @param environment The environment of poss
#' @param interest_cols The columns of interest
#' @param dist_func Function that takes n as an argument and returns 
#' a data.frame of size n x p where p is the number of variables in the dataset
#' @param model_func Function that takes in a data.frame of size m x p 
#' where m is the number of rows and p is the number of variables in the dataset 
#' and returns a vector of predictions of size m x 1
#' @param class_ind Numeric. The index of the required class when ordered alphabetically
#' @param seed Numeric. Seed to be used for the Multi-Armed Bandit algorithm.
#' This ensures that the results stay consistent
#' @param verbose Logical. Whether to print out diagnostics of the Multi-Armed Bandit Algorithm
#'
#' @return A tibble of 1 x (2*p) where p is the number of columns of interest
#' @export
run_mab <- function(
  n_games,
  n_epochs,
  dataset,
  instance_id,
  environment,
  interest_cols,
  dist_func,
  model_func,
  class_ind,
  seed = 145,
  verbose
) {
  ## Define environment and actions
  all_possible_actions <- purrr::map(seq_len(2 * length(interest_cols)), ~ return(c(0, 1))) |> expand.grid()
  actions <- all_possible_actions[rowSums(all_possible_actions) == length(interest_cols), ]
  actions <- actions |>
    split(seq(nrow(actions))) |>
    purrr::map(~ unlist(.x) |> unname())
  n_actions <- length(actions)

  ## Run games
  success_probs <- rep(1, n_actions)
  failure_probs <- rep(1, n_actions)

  envir_reward_hist <- list() # save reward history for efficiency

  set.seed(seed)
  for (game in seq_len(n_games)) {
    current_envir <- rep(1, 2 * length(interest_cols))

    for (round in seq_len(n_epochs)) {
      selected_action <- select_action(n_actions, success_probs, failure_probs)

      current_envir <- update_bounds(current_envir, environment, actions, selected_action)
      new_anchor <- envir_to_bounds_faster(
        current_envir,
        environment,
        interest_cols
      ) |>
        create_anchor_inst(interest_cols)

      envir_tag <- paste0("E", current_envir, collapse = "")
      if(is.null(names(envir_reward_hist)) ||
         !envir_tag %in% names(envir_reward_hist)){
        reward <- get_reward_faster(
          new_anchor,
          round,
          dist_func,
          model_func,
          dataset,
          instance_id,
          class_ind,
          verbose
        )
        envir_reward_hist[[envir_tag]] <- reward
      } else {
        reward <- envir_reward_hist[[envir_tag]]
      }
      outcome <- rbinom(1, size = 1, prob = reward$reward)

      if (!is.na(outcome) && outcome == 1) {
        success_probs[selected_action] <- success_probs[selected_action] + 1
      } else {
        failure_probs[selected_action] <- failure_probs[selected_action] + 1
      }

      if(verbose) {
        print(
        glue::glue(
          "Game {game}: Round {round} \n
            selected : {selected_action}
              prec: {round(reward$prec, 4)}  |
              cover: {round(reward$cover, 4)} |
              reward: {round(reward$reward,4)} \n
            outcome: {outcome}"
        )
      )
      }
    }
    final_bounds <<- envir_to_bounds_faster(
      current_envir,
      environment,
      interest_cols
    )
  }
  return(final_bounds)
}

#' Make anchors
#' 
#' This function is the main entrypoint that generates anchors by running a Multi-Armed Bandit algorithm
#'
#' @param model The model to be interrogated
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
#'
#' @return A data.frame of size 2 x (p+1) where p is the number of columns of interest with each row containing a upper. lower bound.
#' @export
make_anchors <- function(
  model,
  dataset,
  cols,
  instance,
  model_func,
  class_col,
  n_perturb_samples = 10000,
  n_games = 20,
  n_epochs = 100,
  seed = 145,
  verbose = FALSE
) {
  p <- progressr::progressor(steps = length(instance))
  future::plan("multisession")
  final_bounds <- furrr::future_map_dfr(
    instance,
    function(i) {
      p()
      make_single_anchor(
        model = model,
        dataset = dataset,
        cols = cols,
        i,
        model_func = model_func,
        class_col = class_col,
        n_perturb_samples = n_perturb_samples,
        n_games = n_games,
        n_epochs = n_epochs,
        seed = seed,
        verbose = verbose
      ) |> 
      dplyr::mutate(id = i, .before = 1)
    },
    .options = furrr::furrr_options(
      packages = c("randomForest")
    )
  )
}

#' @export
make_single_anchor <- function(
  model,
  dataset,
  cols,
  instance,
  model_func,
  class_col,
  n_perturb_samples = 10000,
  n_games = 20,
  n_epochs = 100,
  seed = 145,
  verbose = FALSE
) {
  class_ind <- dataset[[class_col]][instance] |> as.numeric()
  environment <- generate_cutpoints(dataset, instance, cols)
  perturb_distn <- make_perturb_distn(n_perturb_samples, cols, dataset, instance, seed)
  dist_func <- function(n) perturb_distn[1:n, ]
  model_func <- purrr::partial(model_func, model = model)
  final_bounds <- run_mab(
    n_games,
    n_epochs,
    dataset,
    instance,
    environment,
    cols,
    dist_func,
    model_func,
    class_ind,
    seed = seed,
    verbose = verbose
  )
  lower_bound <- final_bounds |> dplyr::select(ends_with("_l"))
  colnames(lower_bound) <- gsub("_l$", "", colnames(lower_bound))
  upper_bound <- final_bounds |> dplyr::select(ends_with("_u"))
  colnames(upper_bound) <- gsub("_u$", "", colnames(upper_bound))
  return(rbind(
    lower_bound |> dplyr::mutate(bound = "lower"),
    upper_bound |> dplyr::mutate(bound = "upper")
  ))
}
