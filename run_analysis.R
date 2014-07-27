# Coursera, Getting and Cleaning Data
# Course Project 

# Read in data from:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# Create a smaller, tidy subset of the available data.

#setwd("~/R")

# Read in lists to label both the training and test data
# Find the subset of features which are means and stds of
# other variables in the list

activities <- read.table("./data/UCI_HAR_Dataset/activity_labels.txt", 
                         colClasses=c("integer","character"),
                         col.names= c("ActivityLabel","ActivityName"))

features <- read.table("./data/UCI_HAR_Dataset/features.txt", 
                       colClasses=c("integer","character"),
                       col.names= c("FeatureLabel","FeatureName"))
feat <- grep("*-mean\\(|-std\\(*", features[,2])
features[,2] <- gsub("-", ".", features[,2])
features[,2] <- gsub("\\(\\)", "", features[,2])

# Read in the test data and format the test data frame.

testraw <- read.table("./data/UCI_HAR_Dataset/test/X_test.txt",
                      col.names=features$FeatureName)

testlab <- read.table("./data/UCI_HAR_Dataset/test/y_test.txt",
                      col.names="ActivityLabel")

testsub <- read.table("./data/UCI_HAR_Dataset/test/subject_test.txt",
                      col.names="Subject")

SetName <- rep("test",nrow(testlab))

# Replace Activity Label with Activity Name
TestData <- cbind(SetName,testsub,testlab,testraw[,feat])
Test <- merge(TestData,activities, by.x="ActivityLabel",by.y="ActivityLabel")
Test$ActivityLabel <- Test$ActivityName
Test <- Test[,c(1:69)]


# Read in the training data and format the training data frame.

trainraw <- read.table("./data/UCI_HAR_Dataset/train/X_train.txt",
                      col.names=features$FeatureName)

trainlab <- read.table("./data/UCI_HAR_Dataset/train/y_train.txt",
                       col.names="ActivityLabel")

trainsub <- read.table("./data/UCI_HAR_Dataset/train/subject_train.txt",
                       col.names="Subject")
SetName <- rep("train",nrow(trainlab))


# Replace Activity Label with Activity Name
TrainData <- cbind(SetName,trainsub,trainlab,trainraw[,feat])
Train <- merge(TrainData,activities, by.x="ActivityLabel",by.y="ActivityLabel")
Train$ActivityLabel <- Train$ActivityName
Train <- Train[,c(1:69)]


# Merge the data sets.
AllData <- rbind(Test,Train)
                      
nrow(AllData)
ncol(AllData)
nrow(Train)+nrow(Test)
names(AllData)

# Calculate means for each feature for each activity

avgOut <- aggregate(AllData, by=list(AllData$Subject,AllData$ActivityLabel),FUN=mean, na.rm=TRUE)
avgOut <- avgOut[,!(names(avgOut) %in% c("ActivityLabel","SetName","Subject"))]
names(avgOut) <- c("Subject","Activity",paste("avg",names(avgOut[3:68]),sep="."))

# Calculate standard deviations for each feature for each activity

stdOut <- aggregate(AllData, by=list(AllData$Subject,AllData$ActivityLabel),FUN=sd, na.rm=TRUE)
stdOut <- stdOut[,!(names(stdOut) %in% c("ActivityLabel","SetName","Subject"))]
names(stdOut) <- c("Subject","Activity",paste("std",names(stdOut[3:68]),sep="."))

# Merge the means and standard deviations and write it out to a file

Out <- merge(avgOut,stdOut,by.x=c("Subject","Activity"),by.y=c("Subject","Activity"))
Out <- Out[order(Out$Activity,Out$Subject),]

write.table(Out,file="HUA_AvgStd.txt", sep=" ",row.names=F)
