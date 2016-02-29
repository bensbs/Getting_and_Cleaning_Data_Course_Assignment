## Getting and Cleaning Data Course Assignment

## Get the data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" ## file URL

if(!file.exists("./data/")) {dir.create("./data/")} ## create a directory

download.file(fileUrl, "./data/activity.zip") ## download the file

unzip("./data/activity.zip") ## unzip the file

## read in train in data and labels

train <- read.table("./UCI HAR Dataset/train/X_train.txt") ## train data
trainlabels <- read.table("./UCI HAR Dataset/train/y_train.txt") ## train labels i.e. rownames

colnames(trainlabels) <- "activitycode" ## assign a meaninful column names

## read in test data and labels

test <- read.table("./UCI HAR Dataset/test/X_test.txt") ## test data
testlabels<- read.table("./UCI HAR Dataset/test/y_test.txt") ## test labels i.e. rownames

colnames(testlabels) <- "activitycode" ## assign a meaningful column name

## decode the labels

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE) ## read activity label descriptions 

colnames(activitylabels) <- c("activitycode","activity") ## assign some meaningful column names 

## merge labels and activity description sort = FALSE because order needs to be preserved to bind to data

trainlabels <- merge(trainlabels, activitylabels, by = "activitycode", all = TRUE, sort = FALSE) 
testlabels <- merge(testlabels, activitylabels, by = "activitycode", all = TRUE, sort = FALSE)

## bind the label data to test and train data

testdata <- cbind(test, testlabels)
traindata <- cbind(train, trainlabels)

## merge train and test into one data set

activity <- rbind(testdata, traindata)

## assign meaningful column names to the data set

features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE) ## read in feature (column) names
colnames(features) <- c("feature","featurename")

colnames(activity)[1:561] <- features$featurename ## assign names to columns


## create a data set that just comntains the standard deviations and means of the measurements

## subset the data by using grepl to find columns with names matching std mean and activity (so we keep the activity labels)

activitymeanstd <- activity[grepl("std|mean|activity", names(activity))] 


## Create an independent tidy data set with the average of each variable for each activity and each subject

library(data.table) ## data table has a good function for applying a function through a subset of columns

activitydt <- data.table(activity) ## turn activity dataframe into a data table

meanbyactivity <- activitydt[,lapply(.SD, mean),by = activity] ## apply mean through columns by activity

## write to text file for submission

write.table(meanbyactivity, file = "./data/meanbyactivity.txt", row.names = FALSE)






