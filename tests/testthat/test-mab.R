describe("make_single_anchor", {
  # Arrange
  d <- data.frame(
    x = c(1, 1, 2, 2, 3, 3),
    y = c(2, 3, 1, 3, 1, 2),
    z = factor(c("U", "U", "D", "U", "D", "D"))
  )
  cols <- c("x", "y")
  instance <- c(1)
  model_func <- carrier::crate(function(data) {
    return(factor(ifelse(data$x > data$y, "U", "D")))
  })
  class_col <- "z"
  mock_bin_edges <- list(x = c(1.5, 2.5), y = c(1.5, 2.5))

  # Act
  a <- make_single_anchor(
    d,
    cols,
    instance,
    model_func,
    class_col,
    bin_edges = mock_bin_edges
  )
  it("should return a list containing the final anchor and the history", {
    # Assert
    expect_equal(names(a), c("final_anchor", "history"))
    expect_s3_class(a$history, "tbl_df")
    expect_s3_class(a$final_anchor, "tbl_df")
  })
  it("should give the correct final anchor", {})

  it("should work for a series of test cases", {
    # Arrange
    data <- data.frame(
      x = runif(50, -1, 1),
      y = runif(50, -1, 1)
    )
    data$cls <- factor(ifelse(data$x > data$y, "up", "down"))
    # Act

    # Assert
  })
})
