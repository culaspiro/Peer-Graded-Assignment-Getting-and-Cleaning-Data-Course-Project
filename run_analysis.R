
#Downloading and unzipping dataset

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Create one R script called run_analysis.R that does the following:

#1.Merges the training and the test sets to create one data set.

#Reading files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subj_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subj_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features_data <- read.table('./data/UCI HAR Dataset/features.txt')

activity_labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assign column names:
colnames(x_train) <- features_data[,2]
colnames(y_train) <-"activityId"
colnames(subj_train) <- "subjectId"

colnames(x_test) <- features_data[,2] 
colnames(y_test) <- "activityId"
colnames(subj_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

#Merge all data in one set:

cmb_train <- cbind(y_train, subj_train, x_train)
cmb_test <- cbind(y_test, subj_test, x_test)
cmb_total <- rbind(cmb_train, cmb_test)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.

#Reading column names:
colNames <- colnames(cmb_total)

#Create vector for defining ID, mean and standard deviation:

mean_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#Making nessesary subset from cmb_total:

set_cmbtotal <- cmb_total[ , mean_std == TRUE]


#3.Uses descriptive activity names to name the activities in the data set

set_ActivityNames <- merge(set_cmbtotal, activityLabels,
                              by='activityId',
                              all.x=TRUE)


#4. Appropriately labels the data set with descriptive variable names.
#Done in previous steps


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Making a second tidy data set

tempTidySet <- aggregate(. ~subjectId + activityId, set_ActivityNames, mean)
tempTidySet <- tempTidySet[order(tempTidySet$subjectId, tempTidySet$activityId),]

#Writing second tidy data set in txt file

write.table(tempTidySet, "TidySet.txt", row.name=FALSE)