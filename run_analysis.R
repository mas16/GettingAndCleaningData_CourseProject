## Getting and Cleaning Data
## Final Project: Cleaning the Samsung Galaxy S Smartphone
## Accelerometer and Gyroscope measures of human activity

## This script will clean the Samsung Galaxy S Smartphone dataset
## and generate a tidy dataset tidy.txt

## When I download the dataset on my computer, it is called: 
## "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip" so this is the filename I use

## Import libraries
library(dplyr)

## Time script
start_time <- Sys.time()

## define filenames for dataset
zipfilename <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
unzipfilename <- "UCI HAR Dataset"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## check if file exists in working directory
## I am using a mac so the method is set to curl
if (!file.exists(unzipfilename)) {
        if (!file.exists(zipfilename)) {
                download.file(url, zipfilename, method='curl')
                unzip(zipfilename)
        } else if (file.exists(zipfilename)) {
                unzip(zipfilename)
        } 
}

#####
## READ ALL DATA
#####

maindir <- "UCI HAR Dataset/"
testdir <- "UCI HAR Dataset/test/"
traindir <- "UCI HAR Dataset/train/"

## define activities and features paths
actloc <- paste(maindir,"activity_labels.txt", sep="")
featloc <- paste(maindir,"features.txt",sep="")

## read activities and features
activities_names <- read.table(actloc, stringsAsFactors = FALSE)
features <- read.table(featloc,  stringsAsFactors = FALSE)

## define test data paths
xtestloc <- paste(testdir,"X_test.txt",sep="")
ytestloc <- paste(testdir,"y_test.txt",sep="")
subtestloc <- paste(testdir,"subject_test.txt",sep="")

## read test data
xtest <- read.table(xtestloc, stringsAsFactors = FALSE)
ytest <- read.table(ytestloc, stringsAsFactors = FALSE)
subtest <- read.table(subtestloc, stringsAsFactors = FALSE)

## define training data paths
xtrainloc <- paste(traindir,"X_train.txt",sep="")
ytrainloc <- paste(traindir,"y_train.txt",sep="")
subtrainloc <- paste(traindir,"subject_train.txt",sep="")

## read training data
xtrain <- read.table(xtrainloc, stringsAsFactors = FALSE)
ytrain <- read.table(ytrainloc, stringsAsFactors = FALSE)
subtrain <- read.table(subtrainloc, stringsAsFactors = FALSE)

#####
## PART 1: MERGE TRAINING AND TEST SETS TO CREATE ONE DATA SET ##
#####

subjects_combined <- rbind(subtest, subtrain)
measures_combined <- rbind(xtest, xtrain)
activities_combined <- rbind(ytest, ytrain)

## Name columns for subjects, measures, and activities data
## measures columns names are given by the second column of the features data
colnames(measures_combined) <- features$V2
## subjects data has just one column which I'll call "Subjects"
colnames(subjects_combined) <- "Subjects"
## activities data has just one column which I'll call "ActivityCode"
colnames(activities_combined) <- "ActivityCode"
## Combine labeled subjects, activities,and measures data
all_combined <- cbind(subjects_combined, activities_combined, measures_combined)
## the combined data has dim = 10299 x 563

#####
## PART 2: EXTRACT ONLY MEAN AND STD MEASURMENTS ##
#####

keep <- grep("mean|std|Subjects|ActivityCode", colnames(all_combined), ignore.case = TRUE)
## The dimensions after extracting only mean and std measures is 10299 x 88
## 86 columns from measures of mean | std + 1 column for Subjects + 1 column for Activities
parsed_combined <- all_combined[,keep]

#####
## PART 3: USE DESCRIPTIVE ACTIVITY NAME TO NAME ACTIVITIES ##
#####

## Make new column for the real names of the activities corresponding to the Activities Codes
parsed_activities <- mutate(parsed_combined, ActivityName = activities_names[ActivityCode,2])
## Remove ActivityCodes column and replace with ActivityName
named_activities <- select(parsed_activities, Subjects, ActivityName, ActivityCode, everything())

#####
## PART 4: APPROPRIATELY LABEL DATA SET WITH DESCRIPTIVE VARIABLE NAMES ##
#####

names(named_activities) <- sub("\\()", "", names(named_activities))
names(named_activities) <- sub("^t", "Time", names(named_activities))
names(named_activities) <- sub("tBody", "TimeBody", names(named_activities))
names(named_activities) <- sub("^f", "Frequency", names(named_activities))
names(named_activities) <- sub("Acc", "Accelerometer", names(named_activities))
names(named_activities) <- sub("Gyro", "Gyroscope", names(named_activities))
names(named_activities) <- sub("Mag", "Magnitude", names(named_activities))
names(named_activities) <- sub("angle", "Angle", names(named_activities))
names(named_activities) <- sub("gravity", "Gravity", names(named_activities))
names(named_activities) <- sub("mean", "Mean", names(named_activities))
names(named_activities) <- sub("std", "StdDeviation", names(named_activities))
names(named_activities) <- gsub("-", "", names(named_activities))

#####
## PART 5: From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable 
## for each activity and each subject.
#####

## Use aggregate function to calculate means of subsets of the data set
## Subsets are determined by the activity name
agg <- aggregate(.~Subjects+ActivityName+ActivityCode, named_activities, mean)
## Order by Subject 
ordered_agg<-agg[order(agg$Subjects),]
## Delete ActivityCode Column
tidy <- select(ordered_agg, -ActivityCode)
## Write to .txt file
write.table(tidy, file = "tidy.txt", row.names = FALSE)

end_time <- Sys.time()

print(end_time-start_time)