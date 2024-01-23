get_reward <- function(
    new_anchor,
    round,
    dist_func,
    model_func,
    dataset,
    instance_id,
    class_ind = 1) {
  # cover <- coverage_area(new_anchor, train_df |> select(all_of(interest_cols)))
  cover <- coverage(new_anchor, dist_func, n_samples = 10000)
  prec <- precision(new_anchor, model_func, dist_func, n_samples = 10000)
  print(prec)
  prec <- prec[class_ind]
  if (is.null(prec) | is.na(prec)) prec <- 0
  if (prec < 0.5) prec <- 0
  if (is.infinite(cover)) cover <- 0
  print(glue::glue("==== {cover} | {prec} | {mean(c(cover, prec), na.rm = TRUE) }====="))
  return(list(
    reward = as.numeric(satisfies(new_anchor, dataset[instance_id, ])) *
      mean(c(cover / round, prec), na.rm = TRUE),
    # prec,
    prec = prec, cover = cover
  ))
}

select_action <- function(n_actions, success_probs, failure_probs) {
  r <- vector(mode = "numeric", length = n_actions)
  for (i_action in seq_len(n_actions)) {
    r[i_action] <- rbeta(1, shape1 = success_probs[i_action], failure_probs[i_action])
  }
  selected_action <- which.max(r)
  return(selected_action)
}

run_mab <- function(n_games, n_epochs, environment, interest_cols, dist_func, model_func, class_ind) {
  ## Define environment and actions
  all_possible_actions <- purrr::map(seq_len(2 * length(interest_cols)), ~ return(c(0, 1))) |> expand.grid()
  actions <- all_possible_actions[rowSums(all_possible_actions) == length(interest_cols), ]
  actions <- actions |>
    split(seq(nrow(actions))) |>
    map(~ unlist(.x) |> unname())
  n_actions <- length(actions)

  ## Run games
  success_probs <- rep(1, n_actions)
  failure_probs <- rep(1, n_actions)

  for (game in seq_len(n_games)) {
    current_envir <- rep(1, 2 * length(interest_cols))

    for (round in seq_len(n_epochs)) {
      selected_action <- select_action(n_actions, success_probs, failure_probs)

      current_envir <- update_bounds(current_envir, environment, actions, selected_action)
      new_anchor <- envir_to_bounds(
        current_envir,
        environment,
        interest_cols
      ) |>
        create_anchor_inst(interest_cols)
      reward <- get_reward(
        new_anchor,
        round,
        dist_func,
        model_func,
        dataset,
        instance_id,
        class_ind
      )
      outcome <- rbinom(1, size = 1, prob = reward$reward)

      if (outcome == 1) {
        success_probs[selected_action] <- success_probs[selected_action] + 1
      } else {
        failure_probs[selected_action] <- failure_probs[selected_action] + 1
      }

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
    final_bounds <<- envir_to_bounds(
      current_envir,
      environment,
      interest_cols
    )
  }
  return(final_bounds)
}
