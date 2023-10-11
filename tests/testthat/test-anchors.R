describe("anchors", {
  it("should satisfy all data points in a dataset if no predicates is present", {
    # Arrange
    A <- anchors()
    data <- data.frame(x1 = rnorm(10), x2 = rnorm(10))
    # Act
    result <- satisfies(A, data)
    # Assert
    expect_true(all(result))
  })
  it("should be extendable", {
    # Arrange
    A <- anchors()
    B <- anchors(c(predicate("B", `<=`, 8)))
    # Act
    extend_pred <- predicate("A", `>=`, 4)
    A_ex <- extend(A, extend_pred)
    B_ex <- extend(B, extend_pred)
    # Assert
    expect_true(S7_inherits(A_ex, anchors))
    expect_true(S7_inherits(B_ex, anchors))
    expect_true(length(A_ex@predicates) == 1)
    expect_true(length(B_ex@predicates) == 2)
  })
  it("should satisfy the correct data points that are specific to predicates", {
    # Arrange
    A <- anchors(c(predicate("B", `<=`, 8), predicate("A", `>=`, 3)))
    data <- data.frame(A = seq(1,10), B = seq(1,10) * 2)
    # Act
    result <- satisfies(A, data)
    # Assert
    expect_equal(result, c(F,F,T,T,F,F,F,F,F,F))
  })
  it("should calculate some precision for some anchor", {
    # Arrange
    A <- anchors(c(predicate("B", `<=`, 8), predicate("A", `>=`, 3)))
    model_func <- function(data) {
      sample(c("Y", "N"), nrow(data), replace = TRUE)
    }
    dist_func <- function(n) {
      return(
        data.frame(
          A = runif(n, min = 4.5, max = 5.5),
          B = runif(n, min = 4.5, max = 5.5))
      )
    }
    # Act
    prec <- precision(A, model_func, dist_func)
    # Assert
    expect_vector(prec, ptype = double())
  })
  it("should calculate the coverage for a given anchor", {
    # Arrange
    A <- anchors(c(predicate("B", `<=`, 8), predicate("A", `>=`, 3)))
    dist_func <- function(n) {
      return(
        data.frame(
          A = c(4,6,7,8,0,2,1,2,2),
          B = c(2,3,4,5,1,9,9,9,8)
        )
      )
    }
    # Act
    covr <- coverage(A, dist_func)
    # Assert
    expect_vector(covr, ptype = double())
  })
})
