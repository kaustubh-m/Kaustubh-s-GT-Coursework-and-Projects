setwd("C:/Users/Kaustubh/Documents/Intro to Analytical Models/HW4")
dfMaxTemp <- read.csv("maxtemperatureF.csv", header = TRUE)

lapply(dfMaxTemp,class)

install.packages(c("qcc", "lubridate"))
library(c(qcc, lubridate))


dfMaxTemp$Year <- year(mdy(dfMaxTemp$Date))
dfMaxTemp$Year <- as.factor(dfMaxTemp$Year)

dfMaxTemp$Month <- month(mdy(dfMaxTemp$Date))
dfMaxTemp$Month <- as.factor(dfMaxTemp$Month)

dfMaxTemp$Day <- day(mdy(dfMaxTemp$Date))
dfMaxTemp$Day <- as.factor(dfMaxTemp$Day)

summary(dfMaxTemp$Year)
summary(dfMaxTemp$Month)

dfMaxTemp <- dfMaxTemp[order(dfMaxTemp$Year, dfMaxTemp$Month, dfMaxTemp$Day),]

dfMaxTemp$CuSum <- rep(0, nrow(dfMaxTemp))
dfMaxTemp$cycleDay <- rep(0, nrow(dfMaxTemp))

for (yr in unique(dfMaxTemp$Year))
{
  

s_old = 0
dfMaxTemp[dfMaxTemp$Year == yr,]$CuSum[1] <- max(0, (80 - dfMaxTemp[dfMaxTemp$Year == yr,]$MaxTemp[i]))
for (i in 1:(nrow(dfMaxTemp[dfMaxTemp$Year == yr,])-1))
{ dfMaxTemp[dfMaxTemp$Year == yr,]$CuSum[i+1] <- max(0, (80 - dfMaxTemp[dfMaxTemp$Year == yr,]$MaxTemp[i]) + s_old) 
s_old <- dfMaxTemp[dfMaxTemp$Year == yr,]$CuSum[i+1]
dfMaxTemp[dfMaxTemp$Year == yr,]$cycleDay[i] <- i
}

}
dfMaxTemp$cycleDay[dfMaxTemp$cycleDay == 0] <- 123

library(ggplot2)

g <- ggplot(data = dfMaxTemp, aes(x = cycleDay, y = CuSum))
g <- g + geom_line(aes(color = Year))
g <- g + geom_hline(yintercept = 42)
g <- g + xlab("Day of the cycle (1-123)") + ylab("Cumulative sum of Fahrenheit figure")
                      #q <- cusum(dfMaxTemp[dfMaxTemp$Year == 1996,], decision.interval = 4, se.shift = 1)

threshBreach <- rep(0, 20)

for (yr in sort(unique(dfMaxTemp$Year)))
{
  threshBreach[as.numeric(yr) - 1995] <- min(dfMaxTemp[(dfMaxTemp$CuSum > 42) & (dfMaxTemp$Year == yr),]$cycleDay)
}


dfThBrch <- data.frame(c(1996:2015))
dfThBrch <- cbind(dfThBrch,threshBreach)
dfThBrch$year <- as.numeric(dfThBrch$year)
colnames(dfThBrch) <- c("Year", "Threshold Breach")

h <- ggplot(data = dfThBrch, aes(x = Year , y = `Threshold Breach`))
h <- h + geom_point()
h <- h + geom_smooth(method = 'lm')
h


