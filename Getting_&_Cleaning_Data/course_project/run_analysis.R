## Libraries required
library(dplyr)
library(data.table)

baseDataPath <- "./UCI HAR Dataset/"


#mergeDataSets <- function(){
  
  features <- read.table("./UCI HAR Dataset/features.txt", sep=" ", stringsAsFactors=FALSE)
  
  
  ## loading data from training set
  cat("\n## Loading training data ##\n")
  X_train <- read.table(paste(baseDataPath, "train/X_train.txt", sep=""), header=FALSE, dec=".", colClasses="numeric")
  y_train <- read.table(paste(baseDataPath, "train/y_train.txt", sep=""), header=FALSE, colClasses="numeric")
  subject_train <- read.table(paste(baseDataPath, "train/subject_train.txt", sep=""), header=FALSE, colClasses="numeric")
  
  ## Setting the column names training data tables
  names(X_train) <- features$V2
  names(y_train) <- "activity_id"
  names(subject_train) <- "participant_id"
  
  ## merging the training data into a single data table
  all_train <- bind_cols(list(subject_train, y_train, X_train))
  
  ## loading data from test set
  cat("\n## Loading test data ##\n")
  X_test <- read.table(paste(baseDataPath, "test/X_test.txt", sep=""), header=FALSE, dec=".", colClasses="numeric")
  y_test <- read.table(paste(baseDataPath, "test/y_test.txt", sep=""), header=FALSE, colClasses="numeric")
  subject_test <- read.table(paste(baseDataPath, "test/subject_test.txt", sep=""), header=FALSE, colClasses="numeric")
  
  ## Setting the column names for the test data tables
  names(X_test) <- features$V2
  names(y_test) <- "activity_id"
  names(subject_test) <- "participant_id"
  
  ## Merging the test data into a single data table
  all_test <- bind_cols(list(subject_test, y_test, X_test))
  
  ## merging both traing and test data sets to create a single data set
  cat("\n## Merging traing data and test data into a single data set ##\n")
  comp_data <- rbindlist(list(all_train, all_test), use.names=TRUE)
  
  ## Select data only to do with the mean & standard deviation for each variable
  cat("\n## Selecting only the mean & standard deviation of each variable ##\n")
  data2 <- select(comp_data, participant_id, activity_id, contains("mean"), contains("std"))
  
  ## Making data set more readable by replacing numbers with descriptive text
  ## Replace activity id numbers with descriptive names
  cat("\n## Improving readablity of data set by replacing activity id values with activity names ##\n")
  act_tbl <- read.table(paste(baseDataPath, "activity_labels.txt", sep=""), header=FALSE, colClasses=list("numeric", "character"))
  data2[, activity_name := act_tbl[activity_id,2]]
  
  ## removing the activity_id column as it is no longer necessary
  data2 <- select(data2, -activity_id)
  
  ## Re-ordering the data table columns into a more logical order
  ## so that activity_name is after participant_id
  numCols <- dim(data2)[2]
  setcolorder(data2, c(1, numCols, 2:(numCols-1)))
  
  ## separate data set on averages (mean) by variable, activity & subject
  cat("\n## Creating a separate data set summary by participant of mean variable values for each activity ##\n")
  mean_data <- data2 %>% group_by(participant_id, activity_name) %>% summarise_each(funs(mean))
  
  ## Writing out both original tidy data set and summary tidy data set of means
  cat("\n## Writing out tidy data sets to files ##\n")
  file1 <- "./tidy_dataset_full.txt"
  file2 <- "./tidy_dataset_summary.txt"
  wd <- getwd()

  cat("## Full Data set:", file1, "\n", sep=" ")
  write.table(data2, file=file1)
  cat("## Summary Data Set:", file2, "\n", sep=" ")
  write.table(mean_data, file=file2)

  cat("\n## END OF DATA ANALYSIS ##\n")
  
#}