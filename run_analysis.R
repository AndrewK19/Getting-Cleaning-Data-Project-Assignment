#GETTING AND CLEANING DATA - PROJECT ASSIGNMENT, May 2020

#Setting Working Directory
setwd("C:/Users/frost/OneDrive/Desktop/Online Courses/Data Science/1. Modules/Module 3 - Getting and Cleaning Data/2. Assignments/Getting-Cleaning-Data-Project-Assignment")

#Loading required packages
library(dplyr)
library(data.table)

#Checking for .zip file then downloading Data file
filename <- "SamsungGalaxy_Dataset.zip"

if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  

#Checking if folder exists and extracting data from .zip file
if(!file.exists("UCI HAR Dataset")) {
        unzip(filename)
}

#reading in all the required tables into R and assigning as data frames and assigning variable names to data
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activites <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

#STEP 1 - Merge the training and test sets to create one data set

xdata <- bind_rows(x_train, x_test)
ydata <- bind_rows(y_train, y_test)
subjectdata <- bind_rows(subject_train, subject_test)
names(xdata) <- features$functions 
mergeddata <- bind_cols(subjectdata, xdata, ydata)

#STEP 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

featuresnames <- features$functions[grep("mean\\(\\)|std\\(\\)", features$functions)]
tidydata <- select(mergeddata, subject, code, as.character(featuresnames))
#check that the proper variables were pulled from merged data frame
dim(tidydata)
names(tidydata)

#STEP 3 - Uses descriptive activity names to name the activities in the data set and rename column.
tidydata$code <- activites[tidydata$code, 2]
tidydata <- rename(tidydata, activity = code) 

#STEP 4 - Appropriately labels the data set with descriptive variable names.
# prefix t is replaced by time
# Acc is replaced by Accelerometer
# Gyro is replaced by Gyroscope
# prefix f is replaced by frequency
# Mag is replaced by Magnitude
# BodyBody is replaced by Body
names(tidydata) <- gsub("^t","Time-", names(tidydata))
names(tidydata) <- gsub("^f","Frequency-", names(tidydata))
names(tidydata) <- gsub("Acc","Acclerometer", names(tidydata))
names(tidydata) <- gsub("Gyro","Gyroscope", names(tidydata))
names(tidydata) <- gsub("Mag","Magnitude", names(tidydata))
names(tidydata) <- gsub("BodyBody","Body", names(tidydata))
names(tidydata)

# STEP 5 - From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

finaldata <- tidydata %>% 
        group_by(subject, activity) %>%
        summarize_all(funs(mean))
if(!file.exists("./averagedata.txt")) {
        write.table(finaldata, file = "./averagedata.txt", row.names = FALSE)
}

#Produce Codebook
library(knitr)
knit2html("codebook.md");
