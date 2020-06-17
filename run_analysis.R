# Download the file
if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./getcleandata/analysisdataset.zip")

# unzip the file
unzip(zipfile ="./getcleandata/analysisdataset.zip",exdir = "./getcleandata")

# 1. Merge the training and test datasets
# 1.1 Read files
# 1.1.1 Read training datasets
x_train <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")


# 1.1.2 Read test datasets
x_test <- read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")


# 1.1.3 read features and activity labels datasets
features <- read.table("./getcleandata/UCI HAR Dataset/features.txt")
activitylabels <- read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")

# 1.2 assign column names to datasets
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityno_"
colnames(subject_train) <-"subjectno_"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityno_"
colnames(subject_test) <- "subjectno_"

colnames(activitylabels) <- c("activityno_","activityType")

# 1.3 merging all datasets
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
mergedDataset <- rbind(alltrain,alltest)


# 2. Extracting only the measurements on the mean and std for each measurement
# 2.1 reading column names
columns <- colnames(mergedDataset)

# 2.2 Creating vector for defining the activityno_, subjectno_, mean and std
mean_and_std <- (grepl("activityno_",columns)| grepl("subjectno_",columns) |
                   grepl("mean..",columns) | grepl("std...",columns))

# 2.3 Final extract
meanandstd_dataset <- mergedDataset[,mean_and_std == TRUE]


# 3. Using descriptive activity names to name the activities in the dataset
activitynames<- merge(meanandstd_dataset, activitylabels, by = "activityno_", all.x = TRUE)


# 4. Appropriately labelling the the dataset with descriptive variable names, see 1.2, 1.3, 2.2, 2.3

# 5.  Create a second, independent tidy dataset with the average of each variable for each activity and each subject   

# 5.1 making second independent tidy dataset
tidydata<- aggregate(. ~subjectno_ + activityno_, activitynames, mean)
tidydata<- tidydata[order(tidydata$subjectno_, tidydata$activityno_),]
