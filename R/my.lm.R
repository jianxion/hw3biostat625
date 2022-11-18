#'Linear Regression Model
#'
#'This my.lm function is used to fit linear models. It can be used to get the coefficients
#'from a linear regression model. In addition this function will also output R squared value,
#'adjusted R-squared value, F statistic with degree of freedom, and three plots to perform residuals
#'diagnostic to check the assumptions of linear regression model.
#'
#'@param x a dataframe contains all observations in selected columns from a dataset. These columns
#'are the covariates that you are interested in.
#'@param y The target variable to fit the linear regression model on.
#'
#'@return \item{coefficients}{a p x 4 matrix with columns for the estimated coefficients, standard
#'error, t-statistic and the p value}
#'@return \item{R-squared value}{A value which is calculated by SSR/SSY. It can be interpreted as the
#'percentage of variance that can be explained by the model. Higher R-squared value means the model
#'fits better.}
#'@return \item{F statistic}{This value shows if there is any of the selected variables in your input
#'x is related to y. This value is calculated by `(R^2/1-R^2)*(df2/df1)`}
#'@return \item{df2}{The degree of freedom of error, which is calculated by n-p}
#'@return \item{df1}{The degree of freedom of regression, which is calculated by p-1}
#'@return \item{Adjusted R-squared value}{When we have too many covariates, the R-squared value will
#'be penalized, this new value is called adjusted R-squared value}
#'@return \item{Residuals squared vs. fitted values plot}{This plot is used to check if
#'the residuals are randomly distributed around 0.}
#'@return \item{Normal Q-Q Plot}{This plot is used to check the assumption of normality}
#'@return \item{Residuals squared vs. fitted values plot}{This plot is used to check if
#'the residuals squared are randomly distributed around 0.}
#'
#'@examples
#'x = mtcars[, c(3,4,5)]
#'y = mtcars$mpg
#'mymodel <- my.lm(x, y)
#'
#'@export
#'

my.lm = function(x, y) {
  N = nrow(x)
  n = length(y)
  if(N != n) {
    print("Dimensions are not corret")
    return(NULL)
  }
  if(length(y) <= 2) {
    print("Not enough observations")
    return(NULL)
  }
  if(nrow(x) <= 2) {
    print("Not enough observations")
    return(NULL)
  }
  for(i in 1:ncol(x)) {
    x[,i] = as.numeric(x[,i])
  }
  if(class(y) == "character") {
    print("Need numeric response")
    return(NULL)
  }
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
  s = (y -  meany)^2
  SST =  sum(s)
  s2 = res^2
  SSE = sum(s2)
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
  pt = pt(abs(tvalues),
          df = df)
  pvalues = 2 * (1 - pt)
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
  colnames(mytable) = c(
    "Estimate",
    "Std. Error",
    "t value",
    "Pr(>|t|)")
  row.names(mytable)[1] = "(Intercept)"
  print("The model estimated coefficients and standard deviations, t values and p values:")
  print(mytable)
  plot(res ~ yhat,
       xlab = "fitted values",
       ylab = "residuals",
       main = "Residuals vs. fitted values plot")
  abline(h = 0, lty = 2)
  qqnorm(res)
  qqline(res)
  plot(res^2 ~ yhat,
       xlab = "fitted values",
       ylab = "residuals squared",
       main = "Residuals squared vs. fitted values plot")
  abline(h = 0, lty = 2)
  print("R-squared value is")
  print(R2)
  df2 = n - p - 1
  df1 = p
  dfr = df2 / df1
  pr = R2 / (1- R2)
  Fstat = pr * dfr
  print("F statistic is")
  print(Fstat)
  print("With degrees of freedom on df1:")
  print(df1)
  print("And df2:")
  print(df2)
  ratio = p / (n - p - 1)
  adjr2 = R2 - (1 - R2) * ratio
  print("Adjusted R-squared value is")
  print(adjr2)
  return(mytable)
}


