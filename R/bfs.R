#'
#' @export
get_reward <- function(
  new_anchor,
  model_func,
  dataset,
  instance_id,
  class_ind = 1,
  verbose
) {
  # cover <- coverage_area(new_anchor, train_df |> select(all_of(interest_cols)))
  cover <- coverage(new_anchor, dataset)
  prec <- precision(new_anchor, model_func, dataset)
  prec <- prec[class_ind]
  if (is.null(prec) | is.na(prec)) {
    prec <- 0
  }
  if (is.infinite(cover)) {
    cover <- 0
  }
  if (verbose) {
    logger::log_info(glue::glue(
      "==== {cover} | {prec} | {mean(c(cover, prec), na.rm = TRUE) }====="
    ))
  }
  reward = mean(prec, cover)
  return(list(reward = reward, prec = prec, cover = cover))
}

get_neighbors <- function(node, max_values = NULL) {
  logger::log_info("max_values")
  logger::log_info(state_tag(max_values))
  dirs <- length(node)
  all_cant_increment <- TRUE
  neighbors <- lapply(seq_len(dirs), function(d) {
    cur_node_dir <- node[d]
    can_increment <- cur_node_dir < max_values[d]
    if (can_increment) {
      node[d] <- node[d] + 1
      all_cant_increment <<- FALSE
    }
    return(node)
  })
  if (all_cant_increment) {
    return(NULL)
  }
  return(neighbors)
}

reward_for_node <- function(
  node,
  state_space,
  interest_columns,
  model_func,
  dataset,
  instance_id,
  class_ind,
  verbose
) {
  bounds <- envir_to_bounds(node, state_space, interest_columns)
  anchor <- create_anchor_inst(bounds, interest_columns)
  reward <- get_reward(
    anchor,
    model_func,
    dataset,
    instance_id,
    class_ind,
    verbose
  )
  return(reward)
}

state_tag <- function(node) {
  return(paste(node, collapse = ':'))
}

run_bfs <- function(
  start_state,
  dataset,
  instance_id,
  state_space,
  interest_columns,
  model_func,
  class_ind,
  seed = seed,
  verbose = verbose
) {
  queue <- list(start_state)
  visited <- list()
  visited[[state_tag(start_state)]] <- TRUE
  depth <- list()
  depth[[state_tag(start_state)]] <- 0
  max_reward <- list(reward = c(-1), prec = c(), cover = c())
  max_reward_node <- c()
  queue_idx <- 1
  while (queue_idx <= length(queue)) {
    # Dequeue first element
    node <- queue[[queue_idx]]
    if (verbose) {
      logger::log_info("at node")
      logger::log_info(state_tag(node))
    }
    queue_idx <- queue_idx + 1
    # queue <- queue[-1]

    current_depth <- depth[[state_tag(node)]]

    reward <- reward_for_node(
      node,
      state_space,
      interest_columns,
      model_func,
      dataset,
      instance_id,
      class_ind,
      verbose
    )
    logger::log_info(
      "current reward for {state_tag(node)} is {reward$reward} and max_reward is {max_reward$reward}"
    )
    # if (is_stable) {
    #   return(list(node = node, depth = current_depth))
    # }
    if (reward$reward > max_reward$reward) {
      logger::log_info(
        "found new max_reward {max_reward$reward} and node {state_tag(node)}"
      )
      max_reward <- reward
      max_reward_node <- node
    }

    # Explore neighbors
    neighbors <- get_neighbors(node, lapply(state_space, length))
    if (is.null(neighbors)) {
      next
    }
    for (neighbor in neighbors) {
      neighbor_key <- state_tag(neighbor)
      if (verbose) {
        logger::log_info("going to neighbor")
        logger::log_info(neighbor_key)
      }
      if (is.null(visited[[neighbor_key]])) {
        visited[[neighbor_key]] <- TRUE
        depth[[neighbor_key]] <- current_depth + 1
        queue <- c(queue, list(neighbor))
      }
    }
  }
  logger::log_info("creating new bounds")
  print(state_space)

  bounds <- envir_to_bounds(max_reward_node, state_space, interest_columns)
  bounds$reward = max_reward$reward
  bounds$prec = max_reward$prec
  bounds$cover = max_reward$cover
  # TODO: add a reward history
  return(list(final_anchor = bounds, reward_history = tibble::tibble()))
}
