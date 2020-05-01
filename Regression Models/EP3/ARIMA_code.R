install.packages("forecast")
library(forecast)

#Reading the dataset
volcanodust <- scan("http://robjhyndman.com/tsdldata/annual/dvi.dat", skip=1)

#creating and plotting the volcano dust veil levels as a time series
volcanodustseries <- ts(volcanodust,start=c(1500))

plot.ts(volcanodustseries)


#autocorrelation values and plot

acf(volcanodustseries, lag.max=20)             # plot a correlogram
acf(volcanodustseries, lag.max=20, plot=FALSE) # get the values of the autocorrelations


#partial autocorrelation and plot

pacf(volcanodustseries, lag.max=20)
pacf(volcanodustseries, lag.max=20, plot=FALSE)


#fitting an ARIMA(2,0,0) model
volcanodustseriesarima <- arima(volcanodustseries, order=c(2,0,0))
volcanodustseriesarima


#forecasting for 31 years with the model obtained
volcanodustseriesforecasts <- forecast(volcanodustseriesarima, h=31)
volcanodustseriesforecasts


#comparing past and forecast values
plot.forecast(volcanodustseriesforecasts)

#error diagnostics - correlation
acf(volcanodustseriesforecasts$residuals, lag.max=20)
Box.test(volcanodustseriesforecasts$residuals, lag=20, type="Ljung-Box")


#error diagnostics - normal distribution and mean


