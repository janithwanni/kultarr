d <- data.frame(x = rnorm(5), y = rnorm(5), z = rnorm(5))

describe("define_bin_edges", {
  it("should give a list for each interest column", {
    # Arrange
    test_case_1 <- c("x", "y")
    test_case_2 <- c("x", "y", "z")
    # Act
    e_1 <- define_bin_edges(d, test_case_1)
    e_2 <- define_bin_edges(d, test_case_2)
    # Assert
    expect_equal(names(e_1), test_case_1)
    expect_equal(names(e_2), test_case_2)
  })
  it("gives a list with each containing a vector of edges with length of num_bins - 1", {
    # Arrange
    d <- data.frame(x = round(rnorm(20, 10, 5), 2))
    nbins <- 3
    # Act
    e_1 <- define_bin_edges(d, "x", num_bins = nbins)
    # Assert
    expect_equal(length(e_1$x), nbins + 1)
  })
  it("should warn when the number of bins is equal to the number of values", {})
  it("should give the correct bin edges for the number of bins", {
    # Arrange
    d <- data.frame(
      x = c(1, 1, 2, 2, 3, 3),
      y = c(2, 3, 1, 3, 1, 2),
      z = factor(c("U", "U", "D", "U", "D", "D"))
    )
    nbins <- 3
    target_bins <- c(1, 1.67, 2.33, 3)
    # Act
    e <- define_bin_edges(d, c("x", "y"), num_bins = nbins)
    # Assert
    expect_equal(e$x, target_bins, tolerance = 1e-1)
    expect_equal(e$y, target_bins, tolerance = 1e-1)
  })
})

describe("generate_environment", {
  it("should give a list of upper and lower bounds for each interest column", {
    # Arrange
    e <- define_bin_edges(d, c("x", "y", "z"))
    # Act
    Env <- generate_environment(
      d,
      2,
      interest_columns = c("x", "y", "z"),
      bin_edges = e
    )
    # Assert
    expect_equal(names(Env), c("x_l", "x_u", "y_l", "y_u", "z_l", "z_u"))
  })
  it("contains at least one element", {})
})

describe("generate_perturbations", {
  # Act
  p <- generate_perturbations(d, 1, c("x", "y"))
  it("should return a dataframe", {
    # Assert
    expect_s3_class(p, "tbl_df")
  })
  it("should contain the interest columns", {
    # Assert
    expect_equal(colnames(p), c("x", "y"))
  })
})

# describe("define_actions", {
#   # Arrange
#   cols <- c("x", "y")
#   it("should give a list with the tested characteristics", {
#     # Act
#     acts <- define_actions(cols)
#     # Arrange
#     expect_type(acts, "list")
#     expect_equal(length(acts), 2^length(cols))
#   })
# })
#
# describe("select_action", {
#   it("should return an action within the set of actions", {
#     # Arrange
#     nacts <- 4
#     probs <- rep(0.5, nacts)
#
#     # Act
#     sact <- select_action(nacts, probs, probs)
#
#     # Assert
#     expect_true(sact %in% seq(nacts))
#   })
# })
#
describe("update_bounds", {
  # Arrange
  # Act
  # Assert
})

describe("envir_to_bounds", {
  # Arrange
  # Act
  # Assert
})
