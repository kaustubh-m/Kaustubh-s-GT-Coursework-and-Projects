set.seed(54321)

#Generating random errors - normal with mean 0 and sd = 1
e <- rnorm(10, 0, 1)

#Generating vector of input values
x <- seq(1,10,1)

#Calculating Y by formula: Y = 2.5 - 1.8 x + e
Y <- vector(mode = "numeric", length = 10)
Y <- 2.5 - (1.8*x) - e

dfProb3 <- data.frame(x,e,Y)
 
#Fitting a simple regression model
simpRegModel <- lm(Y~x)

# examining the regression model
summary(simpRegModel)

#Calculate standardised residuals, and use in normal probability plot
simpResid <- rstandard(simpRegModel)

qqnorm(simpResid, ylab="Standardized Residuals", xlab="Normal Scores", main="Y = 2.5 - 1.8 x + e") 
qqline(simpResid)

# Standardised fitted values vs. residuals

plot(fitted.values(simpRegModel), simpResid, xlab = "Fitted Value", ylab = "Residual")

#histogram of residual values
hist(simpResid, breaks = seq(-3,3,0.5), xlab = "Residual value")

#Observation order vs. standardised residuals
plot(seq(1,10,1), simpResid, xlab = "Observation S.No.", ylab = "Residual", type = "o")

#Plotting the regression line over the data
plot(x,Y) 
abline(lm(Y ~ x))



###########################################
#Finding alternative sigma
###########################################

set.seed(54321)

#Generating random errors - normal with mean 0 and sd = 1
e <- rnorm(10, 0, 8)

#Generating vector of input values
x <- seq(1,10,1)

#Calculating Y by formula: Y = 2.5 - 1.8 x + e
Y <- vector(mode = "numeric", length = 10)
Y <- 2.5 - (1.8*x) - e

dfProb3b <- data.frame(x,e,Y)

#Fitting a simple regression model
simpRegModel <- lm(Y~x)

# examining the regression model
summary(simpRegModel)

#Calculate standardised residuals, and use in normal probability plot
simpResid <- rstandard(simpRegModel)

qqnorm(simpResid, ylab="Standardized Residuals", xlab="Normal Scores", main="Y = 2.5 - 1.8 x + e") 
qqline(simpResid)

# Standardised fitted values vs. residuals

plot(fitted.values(simpRegModel), simpResid, xlab = "Fitted Value", ylab = "Residual")

#histogram of residual values
hist(simpResid, breaks = seq(-3,3,0.5), xlab = "Residual value")

#Observation order vs. standardised residuals
plot(seq(1,10,1), simpResid, xlab = "Observation S.No.", ylab = "Residual", type = "o")

#Plotting the regression line over the data
plot(x,Y) 
abline(lm(Y ~ x))
