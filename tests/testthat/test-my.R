test_that("my.lm works", {
  x = mtcars[, c(3,4,5)]
  y = mtcars$mpg
  mymodel <- my.lm(x, y)
  model = lm(mpg ~ disp + hp + drat, data = mtcars)
  expect_equal(mymodel, summary(model)$coef)
  m = mtcars[, c(6,7,8)]
  n = mtcars$mpg
  mymodel2 <- my.lm(m, n)
  model2 = lm(mpg ~ wt + qsec + vs, data = mtcars)
  expect_equal(mymodel2, summary(model2)$coef)
})
