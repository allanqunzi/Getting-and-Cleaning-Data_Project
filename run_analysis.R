setwd("C:/Users/Qunzi/Desktop/R/CleaningData/UCI HAR Dataset")
# read train set, add y_train as a column named by "activity_id", add subject_train as a column named by "subject_id"
train = read.csv("./train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("./train/y_train.txt", sep="", header=FALSE, col.names=c("activityid"))
train[,563] = read.csv("./train/subject_train.txt", sep="", header=FALSE, col.names=c("subjectid"))

# read test set, add y_train as a column named by "activity_id", add subject_train as a column named by "subject_id"
test = read.csv("./test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("./test/y_test.txt", sep="", header=FALSE, col.names=c("activityid"))
test[,563] = read.csv("./test/subject_test.txt", sep="", header=FALSE, col.names=c("subjectid"))

# merge train and test together
data = rbind(train, test)

# Extracts only the measurements on the mean and standard deviation for each measurement.
features = read.csv("./features.txt", sep="", header=FALSE)
activityLabels = read.csv("./activity_labels.txt", sep="", header=FALSE)

features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

colsWanted <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[colsWanted,]
colsWanted <- c(colsWanted, 562, 563)
data <- data[,colsWanted]

colnames(data)[1] <- c(features$V2)
colnames(data) <- tolower(colnames(data))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  data$activityid <- gsub(currentActivity, currentActivityLabel, data$activityid)
  currentActivity <- currentActivity + 1
}

data$activityid <- as.factor(data$activityid)
data$subjectid <- as.factor(data$subjectid)

finaldata = aggregate(data, by=list(activity = data$activityid, subject=data$subjectid), mean)
# Remove the subject and activity column, since a mean of those has no use
finaldata[,90] = NULL
finaldata[,89] = NULL
#write.csv(file="finaldata.csv", x=finaldata)
write.table(finaldata, "final.txt", row.name=FALSE)