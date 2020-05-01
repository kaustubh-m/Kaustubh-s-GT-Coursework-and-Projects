setwd("C:/Users/Kaustubh/Documents/Regression Models/CP2")


x1 <- c(-1, 1, -1, 1, -1.4142136, 1.4142136, 0, 0, 0, 0, 0)

x2 <- c(-1, -1, 1, 1, 0, 0, -1.4142136, 1.4142136, 0, 0, 0)

y <- c(81.3, 85.3, 83.1, 72.7, 82.9, 81.7, 84.7, 57.9, 82.9, 81.2, 82.4)

dfP2 <- data.frame(x1, x2, y)

polyRegModel <- lm(y ~ x1 + x2 + I(x1*x2) + I(x1*x1) + I(x2*x2), data = dfP2)

summary(polyRegModel)


#Calculate standardised residuals, and use in normal probability plot
polyResid <- rstandard(polyRegModel)

qqnorm(polyResid, ylab="Standardized Residuals", xlab="Normal Scores", main="MBT Synthesis") 
qqline(polyResid)

# Standardised fitted values vs. residuals



plot(fitted.values(polyRegModel), polyResid, xlab = "Fitted Value", ylab = "Residual")

#histogram of residual values
hist(polyResid, breaks = seq(-3,3,0.5), xlab = "Residual value")

#Observation order vs. standardised residuals
plot(seq(1,11,1), polyResid, xlab = "Observation S.No.", ylab = "Residual", type = "o")






