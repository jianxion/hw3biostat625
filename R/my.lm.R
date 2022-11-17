#'Linear Regression Model
#'
#'Gets the coefficient from a linear regression model
#'
#'@param x input value (a dataframe contains all observations in selected columns from a dataset)
#'@param y input value the target variable to fit the linear regression model on
#'
#'@return the table contains all coefficients of the linear regression model
#'
#'@examples
#'x = mtcars[, c(3,4,5)]
#'y = mtcars$mpg
#'mymodel = my.lm(x, y)
#'mymodel
#'
#'@export
#'

my.lm = function(x, y) {

  X = cbind(1, x)

  X = as.matrix(X)

  y = as.numeric(y)

  XT = t(X)

  XTX = XT %*% X

  INVXTX = solve(XTX)

  XTy = t(X) %*% y

  betahat = INVXTX %*% XTy

  yhat =  X %*% betahat

  res = y - yhat

  meany = mean(y)

  SST =  sum((y -  meany)^2)

  SSE = sum(res^2)

  SSR = SST - SSE

  R2 = SSR / SST

  n = length(y)

  p = ncol(X) - 1

  df = (n - p - 1)

  MSE = SSE / df

  sigma = sqrt(MSE)

  sdsmat = sigma^2 * INVXTX

  diags = diag(sdsmat)

  ses = sqrt(diags)

  tvalues = betahat / ses

  pvalues = 2 * (1 - pt(abs(tvalues),
                        df = df))

  betahat =  betahat[,1]

  sds = ses

  ts = tvalues

  ps = pvalues

  mytable = data.frame(
    betahat,
    sds,
    ts,
    ps
  )
  mytable = as.matrix( mytable )

  colnames( mytable) = c(
    "Estimate",
    "Std. Error",
    "t value",
    "Pr(>|t|)")

  row.names(mytable)[1] = "(Intercept)"

  return(mytable)

}
