setwd("C:\\Users\\rongq\\OneDrive\\0 Rong\\06 COURSES\\Data Science Specialization (John Hopkins)\\02 R Programming\\")
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, dest="HAR.zip", full.names=TRUE, mode='wb')
unzip("HAR.zip", exdir ="HAR")
library(dplyr)
library(reshape2)

features<- read.table("./HAR/UCI HAR Dataset/features.txt")
activityLabels<- read.table("./HAR/UCI HAR Dataset/activity_labels.txt")
View(features)
View(activityLabels)

features[,2]<- as.character(features[,2])
indexMeanStd<- grep("-(mean|std)\\(\\)",features[,2])
namesMeanStd<- features[indexMeanStd,2]

X_train<- read.table("./HAR/UCI HAR Dataset/train/X_train.txt")[indexMeanStd]
y_train<- read.table("./HAR/UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("./HAR/UCI HAR Dataset/train/subject_train.txt")

y_train<- left_join(y_train, activityLabels)
train<- cbind(subject_train, y_train, X_train)
View(train)

X_test<- read.table("./HAR/UCI HAR Dataset/test/X_test.txt")[indexMeanStd]
y_test<- read.table("./HAR/UCI HAR Dataset/test/y_test.txt")
subject_test<- read.table("./HAR/UCI HAR Dataset/test/subject_test.txt")

y_test<- left_join(y_test, activityLabels)
test<- cbind(subject_test, y_test, X_test)
View(test)

allData<- rbind(train,test)
colnames(allData)<- c("subjectID", "activityId", "activityType", namesMeanStd)
View(allData)

allData$activityId<- as.factor(allData$activityId)
allData$activityType<- as.factor(allData$activityType)
allData$subjectID<- as.factor(allData$subjectID)
View(allData)

molten<- melt(allData, c("subjectID", "activityId", "activityType"))
View(molten)

average<- dcast(molten, subjectID + activityId + activityType ~ variable, mean)
View(average)

write.table(average, "tidy.txt", row.names= FALSE, quote= FALSE)
