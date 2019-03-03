


## load the data.table and dplyr packages
library(dplyr)
library(data.table)


######## 1) Merge Training & Test datasets and 2) Extract only mean and standard deviation for each measurement ########


## load the training dataset
train_data <- read.table("./Coursera/data/UCI HAR Dataset/train/X_train.txt")

## to rename the columns names of training dataset, load the features file
features <- read.table("./Coursera/data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

## set old names and new names as:
old_names <- colnames(train_data)
new_names <- as.character(c(features$V2))

## renames column names of training dataset
setnames(train_data, old = old_names, new = new_names)

## select subset of training data with only mean and standard deviation varibles for each measurement
train_data <- train_data[, grepl("mean[()]|std[()]", colnames(train_data))]

## add the Training Subjects and Activity columns to above table by loading subject_train and y_train and appending
y_train <- read.table("./Coursera/data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Coursera/data/UCI HAR Dataset/train/subject_train.txt")

## adding columns to training table
train_data$Activity <- y_train$V1
# ensure that name for subject column is common between training and test subjects to help in merge
train_data$Subject <- subject_train$V1
  

## Repeat the same steps for test data set


## load the test dataset
test_data <- read.table("./Coursera/data/UCI HAR Dataset/test/X_test.txt")

## set old names
old_names <- colnames(test_data)

## renames column names of test dataset
setnames(test_data, old = old_names, new = new_names)

## select subset of test data with only mean and standard deviation varibles for each measurement
test_data <- test_data[, grepl("mean[()]|std[()]", colnames(test_data))]

## add the Test Subjects and Activity columns to above table by loading subject_train and y_train and appending
y_test <- read.table("./Coursera/data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Coursera/data/UCI HAR Dataset/test/subject_test.txt")

## adding columns to test table
test_data$Activity <- y_test$V1
# ensure that name for subject column is common between training and test subjects to help in merge
test_data$Subject <- subject_test$V1

## Merge training and test datasets to create master dataset
masterdata <- rbind(train_data, test_data)

## re-order column positions as Subject, Activity and everything else
masterdata <- select(masterdata, Subject, Activity, everything())


################## 3) Use descriptive names to name the activities in the data set ##################

masterdata$Activity[masterdata$Activity == 1] <- "WALKING"
masterdata$Activity[masterdata$Activity == 2] <- "WALKING_UPSTAIRS"
masterdata$Activity[masterdata$Activity == 3] <- "WALKING_DOWNSTAIRS"
masterdata$Activity[masterdata$Activity == 4] <- "SITTING"
masterdata$Activity[masterdata$Activity == 5] <- "STANDING"
masterdata$Activity[masterdata$Activity == 6] <- "LAYING"


################## 4) Appropriately label the data set with descriptive variable names ##################

## Rename columns of masterdata table as:
## t = Time, f = Frequency, "-" = blank, mean() = Mean, std() = Std

names(masterdata) <- gsub("^t","T", names(masterdata),)
names(masterdata) <- gsub("^f","F", names(masterdata),)
names(masterdata) <- gsub("mean[(][)]","Mean", names(masterdata),)
names(masterdata) <- gsub("std[(][)]","Std", names(masterdata),)
names(masterdata) <- gsub("-","", names(masterdata),)


################ 5) Creates a second independent tidy dataset with the average of each #################
################    variable for each activity and each subject                        #################


# melt the data by specifying the subject and activity as IDs and rest as variables
dmelt <- melt(masterdata, id = c("Subject","Activity"), measures.vars= c(names(masterdata)[3:68]) )

# cast melted data into new dataframe with Subject as ID and applying mean function over each variable
dcast_subject_mean <- dcast(dmelt, Subject~variable, mean)

# cast melted data into new dataframe with Subject as ID and applying mean function over each variable
dcast_activity_mean <- dcast(dmelt, Activity~variable, mean)

# rename Subject and Activty in each dataframe to common name to prepare for binding
colnames(dcast_subject_mean)[colnames(dcast_subject_mean) == "Subject"] <- "Subject_Activity"
colnames(dcast_activity_mean)[colnames(dcast_activity_mean) == "Activity"] <- "Subject_Activity"

# write final data to dataframe by binding above two dataframes
finaldata <- rbind(dcast_subject_mean, dcast_activity_mean)

# Generate output file as text doc:
if(!file.exists("./Coursera/data")){dir.create("./Coursera/data")}
write.table(finaldata, file = "./Coursera/data/finaldata_GCD_Course_Project.txt", row.names = FALSE, sep = ",")



################                      END                       #################


