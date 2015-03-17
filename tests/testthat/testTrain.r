
test_that("training should fail in case of non-numeric data", {
  x <- rep("A", 100)
  y <- rep(1, 100)
  
  expect_error(gmdh::train(x,y))
})



test_that("training construct simple regression models", {
  x <- matrix(1:1020, ncol=2)
  y <- x[,1]*x[,2]
  
  set.seed(9020)
  m <- gmdh::train(x,y)
  
  expect_less_than(mse(predict(m,x),y), 0.0001)
})

test_that("MSE returns correct values",{
  expect_equal(mse(c(1,2,3), c(3,4,5)), 4)
})

test_that("evaluateZ calculates MSE values for all given functions",{
  x <- matrix(1:100, ncol=1)
  y <- x^2
  
  z <- list(function(x) x^2, function(x) 0*x)
  expect_equal(evaluateZ(z,x,y), c(0, mean(y^2))) 
})


test_that("fitQuadraticFun fits quadratic function parameters to data",{
  x <- matrix(1:100, ncol=2)
  y <- 2*x[,1] + x[,1]*x[,2] + 3*x[,2]
  set.seed(9080)
  q <- fitQuadraticFun(ColumnView(1), ColumnView(2), x,y)
  
  expect_less_than(mse(q(x),y), 0.00001)
  
})


test_that("generateQuadraticFuns fits quadratic functions parameters to data",{
  x <- matrix(1:90, ncol=3)
  y <- 2*x[,1] + x[,1]*x[,2] + 3*x[,3]
  set.seed(9080)
  q <- generateQuadraticFuns(list(ColumnView(1), ColumnView(2), ColumnView(3)), x,y)
  
  expect_equal(length(q), 3)
  expect_less_than(mse(q[[1]](x),y), 0.1)
  expect_less_than(mse(q[[2]](x),y), 0.1)
  expect_less_than(mse(q[[3]](x),y), 0.1)
})


