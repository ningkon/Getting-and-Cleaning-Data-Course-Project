# Getting-and-Cleaning-Data-Course-Project

## Hello 

### run_analysis.R is required script to generate final output file: "finaldata_GCD_Course_Project.txt"
 
### Method followed in the script file is as described below:

### 1) Test and Training data sets are first loaded from the UCI HAR Dataset folder

Test data: X_test.txt from test folder, Training data: X_train.txt from the train folder
Training dataset is loaded first followed by Test dataset

### 2) Columns names in the files are renamed by using the features.txt file from UCI HAR Dataset folder

For Training and Test files, metadata for each Column names is: ./UCI HAR Dataset/features.txt

### 3) Only those columns are selected from each dataframe that measures the mean and standard deviation for each variable

test_data <- test_data[, grepl("mean[()]|std[()]", colnames(test_data))] ### 66 columns selected
train_data <- train_data[, grepl("mean[()]|std[()]", colnames(train_data))]  ### 66 columns selected

### 4) To each dataframes, Subject who performed the test and the Activity performed are appended for further analysis

For each Training record, the Training subjects data is: ./UCI HAR Dataset/train/subject_train.txt (7352 observations)
For each Test record, the Test subjects data is: ./UCI HAR Dataset/test/subject_test.txt (2947 observations)

For each Training record and subject, training activity data is: ./UCI HAR Dataset/train/y_train.txt
For each Test record and subject, test activity data: ./UCI HAR Dataset/test/y_test.txt

E.g. test_data$Subject <- subject_test$V1

### 5) Training and Test data frame are rbind-ed to create masterdata

masterdata <- rbind(train_data, test_data)

### 6) Activity lables file is used to manually rename activity labels

masterdata$Activity[masterdata$Activity == 1] <- "WALKING"
masterdata$Activity[masterdata$Activity == 2] <- "WALKING_UPSTAIRS"
masterdata$Activity[masterdata$Activity == 3] <- "WALKING_DOWNSTAIRS"
masterdata$Activity[masterdata$Activity == 4] <- "SITTING"
masterdata$Activity[masterdata$Activity == 5] <- "STANDING"
masterdata$Activity[masterdata$Activity == 6] <- "LAYING"

### 7) Descriptive variable names are used to renamed the variable names in the masterdata dataframe

Please refer Code book for translations

### 8) Melt and cast technique is used to derive the averages of each subject and activity

1. Melt masterdata dataframe by specifying the subject and activity as IDs and rest as variables
2. Cast melted data into new dataframe with Subject as ID and applying mean function over each variable
    dcast_subject_mean <- dcast(dmelt, Subject~variable, mean)
3. Cast melted data into another dataframe with Activity as ID and applying mean function over each variable
    dcast_activity_mean <- dcast(dmelt, Activity~variable, mean)
4. Rename Subject and Activty in each dataframe to common name to prepare for binding
    colnames(dcast_subject_mean)[colnames(dcast_subject_mean) == "Subject"] <- "Subject_Activity"
    colnames(dcast_activity_mean)[colnames(dcast_activity_mean) == "Activity"] <- "Subject_Activity"
5. Write final data to a dataframe by binding above two dataframes:
    finaldata <- rbind(dcast_subject_mean, dcast_activity_mean)
6. Generate output file as text doc:
    if(!file.exists("./Coursera/data")){dir.create("./Coursera/data")}
    write.table(finaldata, file = "./Coursera/data/finaldata_GCD_Course_Project.txt", row.names = FALSE, sep = ",")
    
### 9) finaldata_GCD_Course_Project.txt, when loaded to a dataframe should have 67 variables and 36 observations

  <li> ID: Subject_Activity</li> <li> Variables: as provided in file</li><li> Data: mean value of each variable for each subject and activity </li>
