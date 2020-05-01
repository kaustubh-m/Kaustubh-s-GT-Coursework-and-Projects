
#Reading the data set
dfSBPData <- read.csv("CP_Data_P4_052114.csv", header = TRUE)

head(dfSBPData)


# matrix scatter plot of all possible input variables
# source: https://www.r-bloggers.com/scatterplot-matrices-in-r/
# panel.smooth function is built in.
# panel.cor puts correlation in upper panels, size proportional to correlation
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

# Plot #2: same as above, but add loess smoother in lower and correlation in upper
pairs(~sbp+sex+dbp+scl+chdfate+followup+age+bmi+month+id, data=dfSBPData,
      lower.panel=panel.smooth, upper.panel=panel.cor, 
      pch=20, main="SBP Scatterplot Matrix")

#Based on the scatter plot, scl and bmi data points are crowded together respectively, hence we transform scl (inverse)
dfSBPData$scl_inv <- (1/dfSBPData$scl)
dfSBPData$bmi_inv <- (1/dfSBPData$bmi)


#Box Cox transformation of the dependent variable sbp
install.packages("car")
library(car)
boxCox(dfSBPData$sbp~1)

#From the graph, we get lambda = -1
#therefore, transformed sbp = 1/sbp

# fit first model - all input variables included

linRegFullSBP <- lm(X1.sbp ~ sex + dbp + scl_inv + chdfate + followup + age + bmi_inv + month + id, data = dfSBPData)
vif(linRegFullSBP)

# Eliminate input variable id, since VIF for month and id are high (very high correlation)
linRegFullSBP <- lm(X1.sbp ~ sex + dbp + scl_inv + chdfate + followup + age + bmi_inv + month, data = dfSBPData)
vif(linRegFullSBP)

# Forward Stepwise variable selection:
linRegNullSBP <- lm(X1.sbp ~ 1, data = dfSBPData)
step(linRegNullSBP, scope=list(lower=linRegNullSBP, upper = linRegFullSBP), direction="forward", trace = 10)

#All subsets variable selection:
install.packages("leaps")
library(leaps)
leaps<-regsubsets(X1.sbp ~ sex + dbp + scl + chdfate + followup + age + bmi + month, data=dfSBPData, nbest=10)

summary(leaps)
summary(leaps)$cp

#Final model
linRegFinSBP <- lm(X1.sbp ~ dbp + chdfate + age , data = dfSBPData)

summary(linRegFinSBP)


#Diagnostics

#Calculate standardised residuals, and use in normal probability plot
simpResid <- rstandard(linRegFinSBP)

qqnorm(simpResid, ylab="Standardized Residuals", xlab="Normal Scores", main="SBP") 
qqline(simpResid)

# Standardised fitted values vs. residuals

plot(fitted.values(linRegFinSBP), simpResid, xlab = "Fitted Value", ylab = "Residual")

#histogram of residual values
hist(simpResid, xlab = "Residual value")

#Observation order vs. standardised residuals
plot(seq(1,199,1), simpResid, xlab = "Observation S.No.", ylab = "Residual", type = "o")

#Plotting the regression line over the data
plot(dfSBPData$chdfate,dfSBPData$X1.sbp, xlab = "chfdate", ylab = "sbp_inv") 
abline(lm(dfSBPData$X1.sbp ~ dfSBPData$chdfate))

plot(dfSBPData$dbp,dfSBPData$X1.sbp, xlab = "dbp", ylab = "sbp_inv") 
abline(lm(dfSBPData$X1.sbp ~ dfSBPData$dbp))


plot(dfSBPData$age,dfSBPData$X1.sbp, xlab = "age", ylab = "sbp_inv") 
abline(lm(dfSBPData$X1.sbp ~ dfSBPData$age))



