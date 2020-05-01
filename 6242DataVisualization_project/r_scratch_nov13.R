vDocSample <- sample(unique(dfDocCat$document_id),300000)
dfDocSample <- as.data.frame(vDocSample)

names(dfDocSample)
names(dfDocSample) = "document_id"

dfFin <- merge(dfDocSample, dfDocCat, by.x="vDocSample", by.y="document_id", all.x = TRUE)

library(readr)
dfEvents <- read_csv("events.csv")
dfEvents$loc <- substr(as.character(dfEvents$geo_location), 1, 2)

dfEvents <- dfEvents[,c("display_id", "uuid", "document_id", "platform", "loc")]
sapply(dfEvents, class)

dfEvents$display_id <- as.character(dfEvents$display_id)
dfEvents$document_id <- as.character(dfEvents$document_id)
dfEvents$platform <- as.factor(dfEvents$platform)
dfEvents$loc <- as.factor(dfEvents$loc)

dfEvents <- dfEvents[complete.cases(dfEvents),]

wssplot <- function(data, nc=5, seed=1234){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(dfEvents, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")}








