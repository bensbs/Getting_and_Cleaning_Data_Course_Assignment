## Getting and Cleaning Data Course Assignment

## Get the data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" ## file URL

if(!file.exists("./data/")) {dir.create("./data/")} ## create a directory

download.file(fileUrl, "./data/activity.zip") ## download the file

unzip("./data/activity.zip") ## unzip the file

## read in train data, subject, and activity labels

train <- read.table("./UCI HAR Dataset/train/X_train.txt") ## train data
trainlabels <- read.table("./UCI HAR Dataset/train/y_train.txt") ## train labels i.e. rownames
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt") ## read in subjects

colnames(trainlabels) <- "activitycode" ## assign a meaninful column names

## read in test data and labels

test <- read.table("./UCI HAR Dataset/test/X_test.txt") ## test data
testlabels<- read.table("./UCI HAR Dataset/test/y_test.txt") ## test labels i.e. rownames
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt") ## read in subjects

colnames(testlabels) <- "activitycode" ## assign a meaninful column names

## decode the labels

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE) ## read activity label descriptions 

colnames(activitylabels) <- c("activitycode","activity") ## assign some meaningful column names 

## merge labels and activity description sort = FALSE because order needs to be preserved to bind to data

trainlabels <- merge(trainlabels, activitylabels, by = "activitycode", all = TRUE, sort = FALSE) 
testlabels <- merge(testlabels, activitylabels, by = "activitycode", all = TRUE, sort = FALSE)

## bind the subject and activity lables to test and train data

testdata <- cbind(testsubject, testlabels, test)
traindata <- cbind(trainsubject, trainlabels, train)

## merge train and test into one data set

activity <- rbind(testdata, traindata)

## assign meaningful column names to the data set

features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE) ## read in feature (column) names
colnames(features) <- c("feature","featurename")

colnames(activity)[4:564] <- features$featurename ## assign names to columns
colnames(activity)[1] <- "subject"


## create a data set that just comntains the standard deviations and means of the measurements

## subset the data by using grepl to find columns with names matching std, mean subject, and activity (so we keep the activity labels)

activitymeanstd <- activity[grepl("std\\(\\)-[XYZ]|mean\\(\\)-[XYZ]|activity|subject", names(activity))] 

## Create an independent tidy data set with the average of each variable for each activity and each subject

library(data.table) ## data table .SD to apply a function through a subset of columns

activitydt <- data.table(activitymeanstd) ## turn activity dataframe into a data table

meanbyactivity <- activitydt[,lapply(.SD, mean),by = list(subject, activity)] ## apply mean through columns by activity

## write to text file for submission

write.table(meanbyactivity, file = "./data/tidydata.txt", row.names = FALSE)

## view tidy data

data <- read.table("./data/tidydata.txt", header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
View(data)
