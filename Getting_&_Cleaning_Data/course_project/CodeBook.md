---
title: "Code Book  - run_analysis.R"
author: "Rich Robinson"
output: "html_document"
---

***

## Variables of the Data Set

The features included in the data set are as follows;

* tBodyAcc-X
* tBodyAcc-Y
* tBodyAcc-&
* tGravityAcc-X
* tGravityAcc-Y
* tGravityAcc-Z
* tBodyAccJerk-X
* tBodyAccJerk-Y
* tBodyAccJerk-Z
* tBodyGyro-X
* tBodyGyro-Y
* tBodyGyro-Z
* tBodyGyroJerk-X
* tBodyGyroJerk-Y
* tBodyGyroJerk-Z
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-X
* fBodyAcc-Y
* fBodyAcc-Z
* fBodyAccJerk-X
* fBodyAccJerk-Y
* fBodyAccJerk-Z
* fBodyGyro-X
* fBodyGyro-Y
* fBodyGyro-Z
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

For each of the above, the following variables were estimated by calculation;

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional variables calculated include;

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

This creates a total of 561 variables in the data set. In the tidy data set these are representated as the column headings of the data tables.
Two additional columns were included at the start of the data for participant ID and the activity performed that the recordings were recorded from.

The above data set was condenced into a summary data set where by only the mean value of each variable was selected. This created a smaller data set with only 86 variables, and the additional two beginning columns for participant ID and activity.

***

## Transformations

The data was originally presentated in many separate files. These were further subdivided into a traing and test data set.

* features.txt - The names of the variables in the data set
* Training Data:
    + X_train.txt - The data recorded and calculated
    + y_train.txt - The activity performed producing the data
    + subject_train.txt - The participant performing the experiment
* Test Data:
    + X_test.txt - The data recorded and calculated
    + y_test.txt - The activity performed producing the data
    + subject_test.txt - The participant performing the experiment
* activity_lables.txt - The names of the activities performed

***

Each of these were read into the R script and joined together to create two separate data tables for both the traing and test data. This was focused around the main body of data contained withing *X_...txt* and the values in *fatures.txt* were assigned to the names of this data frame. The data frame contain the values from *y_...txt* was given the name "activity_id" and the data frame containing the values from *subject_...txt* was given the name "Participant_id".
These data frames were all bound together column-wise using "bind_cols" so that the data was in the order of "participant_id", "activity_id" then the features from X.
Following this the two data sets of training and test data were joined together row-wise using the "rowbindlist" function to create the final, complete data set of 10299 observations of the 561 variables, plus columns for participant ID and activity ID.

***

A more condenced form of the data set was required whereby only the mean and standard deviation values for the features were necessary. These were included as part of the data set so were extracted into the condenced data set using the "select" function/verb from the 'dplyr' package. This data set contains the same 10299 observations but now for only 86 variables, those labled *'mean'* or *'std'* (plus the columns for participant ID and activity ID).
The variables in the condenced data set are:

* tBodyAcc-mean()-X
* tBodyAcc-mean()-Y
* tBodyAcc-mean()-Z
* tGravityAcc-mean()-X
* tGravityAcc-mean()-Y
* tGravityAcc-mean()-Z
* tBodyAccJerk-mean()-X
* tBodyAccJerk-mean()-Y
* tBodyAccJerk-mean()-Z
* tBodyGyro-mean()-X
* tBodyGyro-mean()-Y
* tBodyGyro-mean()-Z
* tBodyGyroJerk-mean()-X
* tBodyGyroJerk-mean()-Y
* tBodyGyroJerk-mean()-Z
* tBodyAccMag-mean()
* tGravityAccMag-mean()
* tBodyAccJerkMag-mean()
* tBodyGyroMag-mean()
* tBodyGyroJerkMag-mean()
* fBodyAcc-mean()-X
* fBodyAcc-mean()-Y
* fBodyAcc-mean()-Z
* fBodyAcc-meanFreq()-X
* fBodyAcc-meanFreq()-Y
* fBodyAcc-meanFreq()-Z
* fBodyAccJerk-mean()-X
* fBodyAccJerk-mean()-Y
* fBodyAccJerk-mean()-Z
* fBodyAccJerk-meanFreq()-X
* fBodyAccJerk-meanFreq()-Y
* fBodyAccJerk-meanFreq()-Z
* fBodyGyro-mean()-X
* fBodyGyro-mean()-Y
* fBodyGyro-mean()-Z
* fBodyGyro-meanFreq()-X
* fBodyGyro-meanFreq()-Y
* fBodyGyro-meanFreq()-Z
* fBodyAccMag-mean()
* fBodyAccMag-meanFreq()
* fBodyBodyAccJerkMag-mean()
* fBodyBodyAccJerkMag-meanFreq()
* fBodyBodyGyroMag-mean()
* fBodyBodyGyroMag-meanFreq()
* fBodyBodyGyroJerkMag-mean()
* fBodyBodyGyroJerkMag-meanFreq()
* angle(tBodyAccMean,gravity)
* angle(tBodyAccJerkMean),gravityMean)
* angle(tBodyGyroMean,gravityMean)
* angle(tBodyGyroJerkMean,gravityMean)
* angle(X,gravityMean)
* angle(Y,gravityMean)
* angle(Z,gravityMean)
* tBodyAcc-std()-X
* tBodyAcc-std()-Y
* tBodyAcc-std()-Z
* tGravityAcc-std()-X
* tGravityAcc-std()-Y
* tGravityAcc-std()-Z
* tBodyAccJerk-std()-X
* tBodyAccJerk-std()-Y
* tBodyAccJerk-std()-Z
* tBodyGyro-std()-X
* tBodyGyro-std()-Y
* tBodyGyro-std()-Z
* tBodyGyroJerk-std()-X
* tBodyGyroJerk-std()-Y
* tBodyGyroJerk-std()-Z
* tBodyAccMag-std()
* tGravityAccMag-std()
* tBodyAccJerkMag-std()
* tBodyGyroMag-std()
* tBodyGyroJerkMag-std()
* fBodyAcc-std()-X
* fBodyAcc-std()-Y
* fBodyAcc-std()-Z
* fBodyAccJerk-std()-X
* fBodyAccJerk-std()-Y
* fBodyAccJerk-std()-Z
* fBodyGyro-std()-X
* fBodyGyro-std()-Y
* fBodyGyro-std()-Z
* fBodyAccMag-std()
* fBodyBodyAccJerkMag-std()
* fBodyBodyGyroMag-std()
* fBodyBodyGyroJerkMag-std()

***

Making the data more readable and satifying the criteria for a 'tidy data set' the id values representing which activity was performed as part of the experiment need to be replaced with names. These were provided in the "activity_lables" data set adn were merged into a new column in the data set by using the value in 'activity_id' to select the appropriate lable. Following this the 'activity_id' column was removed as it was no longer necessary.

***

This data set was the exported to a text file using the default values for the "write.table" function. This means the values are separated by 'white space'. The name of this exported data is "tidy_dataset_full.txt"

***

## Summarising

Each of the 30 participants in the experiment were asked to perform 6 different activities multiple times and record the values generated during execution. To make the data easier to compare between participants and average value would be more useful than comparing the raw values. The activities performed were:

* walking
* walking upstairs
* walking downstairs
* sitting
* standing
* laying

This created a much smaller data set of only 180 observations which were the mean values of the 86 variables for each participant and each activity.

This data set was exported to a text file using the 'write.table' functino and default arguments, where each value is separated by 'white space'. The file name is "tidy_dataset_summary.txt"

***

