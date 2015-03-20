# rGMDH
[![Travis-CI Build Status](https://travis-ci.org/dratewka/rGMDH.png?branch=master)](https://travis-ci.org/dratewka/rGMDH)

An [R](http://www.r-project.org/) implementation of Group Method of Data Handling [1] inspired by [2]. The method can be used for solving regression tasks with numeric input and output variables by creating a high order polynomial.

## Installation
You can install the package directly from github using [devtools](https://github.com/hadley/devtools):
```
  devtools::install_github("dratewka/rGMDH")
```

## Example
You can solve regression tasks as follows:

```
x <- cbind(runif(100), runif(100))
y <- 1 + x[,1]^2 + x[,1]*x[,2]

# Train the model
m <- rGMDH::train(x,y)

# Predict values
yh <- predict(m, x)

# Plot predictions vs actual values
plot(yh, y)
```

## References
1. Ivakhnenko A. G., 1968. The Group Method of Data Handling-A rival of the Method of Stochastic Approximation. Soviet Automatic Control, vol 13 c/c of avtomatika, 1, 3, 43-55. 
2. Farlow, Stanley J. "The GMDH algorithm of Ivakhnenko." The American Statistician 35.4 (1981): 210-215.

