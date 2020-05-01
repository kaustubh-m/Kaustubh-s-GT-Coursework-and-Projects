setwd("C:/Users/Kaustubh/Documents/polo chau 6242/project")

install.packages("data.table")
install.packages("chron")
require(data.table)


install.packages("klaR")
library(klaR)

dfTest = read.table("doc_clustering2_eventdocs_only.csv", header = TRUE, sep = ",")

dfTest = dfTest[,c("document_id", "source_id", "publisher_id", "topic_id", "category_id")]

dfTest$document_id = as.factor(dfTest$document_id)
dfTest$source_id = as.factor(dfTest$source_id)
dfTest$publisher_id = as.factor(dfTest$publisher_id)
dfTest$topic_id = as.factor(dfTest$topic_id)
dfTest$category_id = as.factor(dfTest$category_id)

dfTest = dfTest[complete.cases(dfTest),]

nrow(dfTest)

dfTest1 = dfTest[sample(1:7146758, 700000),]

kmode10 = kmodes(dfTest1[,c("source_id", "publisher_id", "topic_id", "category_id")], 10)

dfTest = read.table("document_clustering_eventdocs_only.csv", header = TRUE, sep = ",", nrows = 100)

dfTestCat = read.table("document_cat_eventdocs_only.csv", sep = ",", header = TRUE, nrows = 100)

dfTestTopic = read.table("document_topic_eventdocs_only.csv", sep = ",", header = TRUE, nrows = 100)

dfTestEnt = read.table("document_entities_eventdocs_only.csv", sep = ",", header = TRUE, nrows = 100)

dfTestMeta = read.table("document_meta_eventdocs_only.csv", sep = ",", header = TRUE, nrows = 100)


rf_model<-train(V1~source_id + publisher_id + category_id + topic_id,data=dfDataCluster5,method="rf",
                trControl=trainControl(method="cv",number=10),
                prox=TRUE,allowParallel=TRUE)


