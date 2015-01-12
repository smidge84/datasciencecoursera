## Libraries required
library(plyr) ## for the 'join_all' function
library(dplyr)
library(data.table)

baseDataPath <- "./UCI HAR Dataset/"


mergeDataSets <- function(){
  #trainFiles <- c("train/X_train.txt", "train/subject_train.txt", "train/y_train.txt")
  #testFiles <- c("test/X_test.txt", "test/subject_train.txt", test/y_test.txt"")
  
  features <- read.table("./UCI HAR Dataset/features.txt", sep=" ", stringsAsFactors=FALSE)
  
  
  ## loading data from training set
  X_train <- read.table(paste(baseDataPath, "train/X_train.txt", sep=""), header=FALSE, dec=".", colClasses="numeric")
  y_train <- read.table(paste(baseDataPath, "train/y_train.txt", sep=""), header=FALSE, colClasses="numeric")
  subject_train <- read.table(paste(baseDataPath, "train/subject_train.txt", sep=""), header=FALSE, colClasses="numeric")
  
  ## Setting the column names training data tables
  names(X_train) <- features$V2
  names(y_train) <- "activity"
  names(subject_train) <- "participant_id"
  
  ## merging the training data into a single data table
  all_train <- bind_cols(list(subject_train, y_train, X_train))
  
  ## loading data from test set
  X_test <- read.table(paste(baseDataPath, "test/X_test.txt", sep=""), header=FALSE, dec=".", colClasses="numeric")
  y_test <- read.table(paste(baseDataPath, "test/y_test.txt", sep=""), header=FALSE, colClasses="numeric")
  subject_test <- read.table(paste(baseDataPath, "test/subject_test.txt", sep=""), header=FALSE, colClasses="numeric")
  
  ## Setting the column names for the test data tables
  names(X_test) <- features$V2
  names(y_test) <- "activity"
  names(subject_test) <- "participant_id"
  
  ## Merging the test data into a single data table
  all_test <- bind_cols(list(subject_test, y_test, X_test))
  
  ## merging both traing and test data sets to create a single data set
  comp_data <- rbindlist(list(all_train, all_test), use.names=TRUE)
  
  ## Making data set more readable by replacing numbers with descriptive text
  ## ... TODO
  
}