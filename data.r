set.seed(121)
n <- 100
x <- rnorm(n)
y <- (x*2 + 2 + rnorm(n)) > 0
ans <- glm(y~x, family = binomial(link = "probit"))
z <- predict(ans, type="response")

readr::write_csv(
  data.frame(expected = y, predicted = z), 
  "data.csv"
)