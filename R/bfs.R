#' @keywords internal
#' @noRd
get_reward <- function(
  new_anchor,
  model_func,
  dataset,
  class_ind = 1
) {
  cover <- coverage(new_anchor, dataset)
  prec <- precision(new_anchor, model_func, dataset)
  if (isit("verbose")) {
    logger::log_info("received precisions {prec[1]} , {prec[2]}")
  }
  prec <- prec[class_ind]
  if (is.null(prec) | is.na(prec)) {
    prec <- 0
  }
  if (is.infinite(cover)) {
    cover <- 0
  }
  if (isit("verbose")) {
    logger::log_info(glue::glue(
      "==== {cover} | {prec} | {mean(c(cover, prec), na.rm = TRUE) }====="
    ))
  }
  reward <- mean(c(exp(prec), prec * cover))
  return(list(reward = reward, prec = prec, cover = cover))
}

#' Conveience function to generate a tag for a node
#' @noRd
state_tag <- function(node) {
  return(paste(node, collapse = ':'))
}

#' Builds a function that scores boxes given as node indices
#'
#' The cumulative count tables are built once, so scoring a node needs no
#' model calls or predicate evaluations.
#'
#' @param dataset Perturbations to evaluate the boxes on
#' @param state_space Output of `generate_environment`
#' @param interest_columns Columns of interest
#' @param hits Logical vector. Whether each row of `dataset` is predicted as
#'   the class of the instance
#'
#' @returns A function taking a data frame of nodes (one column per bound,
#'   holding indices into `state_space`) and returning a data frame with the
#'   node tag, reward, precision and coverage of each node.
#' @keywords internal
#' @noRd
make_box_evaluator <- function(dataset, state_space, interest_columns, hits) {
  binned <- bin_index(dataset, interest_columns, state_space)
  tables <- build_count_tables(binned, hits)
  cell_lo <- lapply(seq_along(interest_columns), function(j) {
    2L * match(state_space[[2 * j - 1]], binned$cuts[[j]]) + 1L
  })
  cell_hi <- lapply(seq_along(interest_columns), function(j) {
    2L * match(state_space[[2 * j]], binned$cuts[[j]]) - 1L
  })
  n_rows <- nrow(dataset)
  function(nodes) {
    lo <- lapply(seq_along(cell_lo), \(j) cell_lo[[j]][nodes[[2 * j - 1]]])
    hi <- lapply(seq_along(cell_hi), \(j) cell_hi[[j]][nodes[[2 * j]]])
    counts <- box_counts(lo, hi, tables)
    cover <- counts$total / n_rows
    prec <- ifelse(counts$total > 0, counts$hits / counts$total, 0)
    data.frame(
      node_tag = do.call(paste, c(unname(nodes), sep = ":")),
      reward = (exp(prec) + prec * cover) / 2,
      prec = prec,
      cover = cover
    )
  }
}

#' Evaluates every combination of candidate indices
#'
#' Nodes are visited in breadth first order (by depth from the tightest box)
#' and the first node in that order with the highest reward is selected.
#'
#' @param evaluate Output of `make_box_evaluator`
#' @param candidates List with one vector of candidate indices per bound
#'
#' @returns A list with the selected `node` and the scored `history`.
#' @keywords internal
#' @noRd
search_lattice <- function(evaluate, candidates) {
  nodes <- expand.grid(candidates, KEEP.OUT.ATTRS = FALSE)
  nodes <- nodes[order(rowSums(nodes)), , drop = FALSE]
  scores <- evaluate(nodes)
  best <- which.max(scores$reward)
  return(list(node = unlist(nodes[best, ], use.names = FALSE), history = scores))
}

#' Picks evenly spaced indices out of `seq_len(size)`
#' @keywords internal
#' @noRd
coarse_indices <- function(size, n_coarse) {
  unique(round(seq(1, size, length.out = min(size, n_coarse))))
}

#' Coarse to fine search
#'
#' Searches a coarse lattice exhaustively, then repeatedly halves the spacing
#' between candidates and searches a window of three candidates per bound
#' centred on the current best node, until the spacing reaches one cutpoint.
#'
#' @inheritParams search_lattice
#' @param sizes Number of cutpoints for each bound
#' @param n_coarse Number of cutpoints per bound in the first coarse search
#' @keywords internal
#' @noRd
search_refine <- function(evaluate, sizes, n_coarse = 3) {
  res <- search_lattice(evaluate, lapply(sizes, coarse_indices, n_coarse))
  history <- list(res$history)
  node <- res$node
  steps <- ifelse(sizes > 1, ceiling((sizes - 1) / (pmin(sizes, n_coarse) - 1)), 1)
  while (any(steps > 1)) {
    steps <- ceiling(steps / 2)
    candidates <- lapply(seq_along(node), function(d) {
      unique(pmin(pmax(node[d] + c(-steps[d], 0, steps[d]), 1), sizes[d]))
    })
    res <- search_lattice(evaluate, candidates)
    history <- c(history, list(res$history))
    node <- res$node
  }
  return(list(node = node, history = do.call(rbind, history)))
}

#' Coordinate ascent search
#'
#' Starts from the best node of a coarse exhaustive search, then moves one
#' bound at a time to its best cutpoint while the others stay fixed. A bound
#' only moves when the reward strictly improves, and the search stops once a
#' full sweep over all bounds makes no move.
#'
#' @inheritParams search_refine
#' @keywords internal
#' @noRd
search_coordinate <- function(evaluate, sizes, n_coarse = 3) {
  res <- search_lattice(evaluate, lapply(sizes, coarse_indices, n_coarse))
  history <- list(res$history)
  node <- res$node
  best_reward <- max(res$history$reward)
  repeat {
    moved <- FALSE
    for (d in seq_along(node)) {
      candidates <- as.list(node)
      candidates[[d]] <- seq_len(sizes[d])
      res <- search_lattice(evaluate, candidates)
      history <- c(history, list(res$history))
      if (max(res$history$reward) > best_reward) {
        node <- res$node
        best_reward <- max(res$history$reward)
        moved <- TRUE
      }
    }
    if (!moved) {
      break
    }
  }
  return(list(node = node, history = do.call(rbind, history)))
}

#' Perform the box search
#'
#' @param dataset Perturbations to evaluate the boxes on
#' @param state_space Output of `generate_environment`
#' @param interest_columns Columns of interest
#' @param hits Logical vector. Whether each row of `dataset` is predicted as
#'   the class of the instance
#' @param search One of `"exhaustive"`, `"refine"` or `"coordinate"`
#' @noRd
run_bfs <- function(
  dataset,
  state_space,
  interest_columns,
  hits,
  search = "exhaustive"
) {
  evaluate <- make_box_evaluator(dataset, state_space, interest_columns, hits)
  sizes <- lengths(state_space, use.names = FALSE)
  res <- switch(
    search,
    exhaustive = search_lattice(evaluate, lapply(sizes, seq_len)),
    refine = search_refine(evaluate, sizes),
    coordinate = search_coordinate(evaluate, sizes)
  )
  reward_history <- res$history[!duplicated(res$history$node_tag), ]
  rownames(reward_history) <- NULL
  best <- reward_history[match(state_tag(res$node), reward_history$node_tag), ]
  if (isit("verbose")) {
    logger::log_info(
      "evaluated {nrow(reward_history)} nodes, max reward {best$reward}"
    )
  }
  bounds <- envir_to_bounds(res$node, state_space, interest_columns)
  bounds$reward <- best$reward
  bounds$prec <- best$prec
  bounds$cover <- best$cover
  return(list(final_anchor = bounds, reward_history = reward_history))
}
