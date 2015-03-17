
test_that("column view function returns a specific input matrix column", {
  x <- matrix(data=c(1,2,3, 3,4,5, 7,8,9), nrow=3, byrow = T)
  
  c1 <- ColumnView(1)
  c2 <- ColumnView(2)
  c3 <- ColumnView(3)
  
  expect_equal(c1(x), c(1,3,7))
  expect_equal(c2(x), c(2,4,8))
  expect_equal(c3(x), c(3,5,9))
  
})


test_that("initialZ returns all column views for the given matrix",{
  x <- matrix(data=c(1,2,3,4, 5,6,7,8), nrow=2, byrow = T)
  
  res <- initialZ(x)
  
  as.list(environment(res[[2]]))

  expect_equal(length(res), 4)
  expect_equal(res[[1]](x), c(1,5))
  expect_equal(res[[2]](x), c(2,6))
  expect_equal(res[[3]](x), c(3,7))
  expect_equal(res[[4]](x), c(4,8))
})

test_that("quadratic function requires a valid parameter vector",{
  c1 <- ColumnView(1)
  
  expect_error(QuadraticFun(c1,c1, c(1,2,3)))
})


test_that("quadratic function respects parameters",{
  x <- matrix(c(2,4),nrow=1)
  
  q <- function(i) {
    w <- rep(0, 6)
    w[[i]] <- 2
    
    QuadraticFun(ColumnView(1), ColumnView(2), w)(x)
  }
  
  expect_equal(q(1), 2)
  expect_equal(q(2), 4)
  expect_equal(q(3), 8)
  expect_equal(q(4), 8)
  expect_equal(q(5), 32)
  expect_equal(q(6), 16)
})


test_that("quadratic function allow nesting",{
  x <- matrix(c(2,4),nrow=1)
  w <- c(0,1,1,0,0,0)
  
  q1 <- QuadraticFun(ColumnView(1), ColumnView(2), w)
  q2 <- QuadraticFun(q1, ColumnView(2), w)
  
  
  expect_equal(q1(x), 6)
  expect_equal(q2(x), 10)
})