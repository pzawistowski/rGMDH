library(plyr)

ColumnView <- function(col.idx){
  
  idx <- col.idx
  function(x){
    x[,idx]
  }
}

QuadraticFun <- function(uFun, vFun, w){
  if(length(w)!=6){
    stop("Invalid w vector length for quadratic function")  
  }
  
  function(x){
    u <- uFun(x)
    v <- vFun(x)
    
    w[1] + w[2]*u + w[3]*v + w[4]*u^2 + w[5]*v^2 + w[6]*u*v
  }
}

initialZ <- function(x){
  lapply(1:ncol(x), ColumnView)
}

evaluateZ <- function(zList, x, y){
  sapply(zList, FUN=function(z) mse(z(x), y) )
}

mse <- function(v1, v2){
  mean((v1-v2)^2)
}


fitQuadraticFun <- function(u,v, x, y){
  res <- optim(rep(1,6), function(w){
    mse(QuadraticFun(u,v, w)(x), y)
  }, method = "BFGS")
  
  QuadraticFun(u,v, res$par)
}


generateQuadraticFuns <- function(zLst, x, y){
  llply( combn(zLst, m = 2, simplify = F), function(l){
    fitQuadraticFun(l[[1]], l[[2]], x, y)
  })
}

doIteration <- function(xTrain, yTrain, xVal, yVal, zLst, M){
  zNew <- c(zLst, generateQuadraticFuns(zLst, xTrain, yTrain))
  sortedIndices <- sort(evaluateZ(zNew, xVal, yVal), index.return=T)$ix
  
  zNew[sortedIndices[1:min(M, length(zNew))]]
}


doTrain <- function(xTrain, yTrain, xVal, yVal, M){
  
  z <- initialZ(xTrain)  
  bestErr <- function(z) min(evaluateZ(z, xVal, yVal)) 
  
  err <- Inf
  currErr <- bestErr(z)
  
  while(currErr<err){
    
    z <- doIteration(xTrain, yTrain, xVal, yVal, z, M)
    err <- currErr
    currErr <- bestErr(z)
  }
  
  m <- z[[1]]
  class(m) <- 'gmdh'
  
  m
}



#' @export
predict.gmdh <- function(object, data,...){
  object(data)
}

#' @export
train <- function(x, y, M=4, val.size = 0.25){
  if(is.numeric(x) && is.numeric(y)){
    idx <- sample(nrow(x), size = ceiling(nrow(x)*val.size) )
    
    doTrain(x[idx,],y[idx], x[-idx,], y[-idx], M)
    
  }else{
    stop("GMDH requires numerical inputs")
  }
}
