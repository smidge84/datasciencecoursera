---
title: "Code Book  - run_analysis.R"
author: "Rich Robinson"
output: "html_document"
---

## Variables of the Data Set

The features included in the data set are as follows;

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
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

Each of these were read into the R script and joined together to create two separate data tables for both the traing and test data. This was focused around the main body of data contained withing *X_...txt* and the values in *fatures.txt* were assigned to the names of this data frame. The data frame contain the values from *y_...txt* was given the name "activity_id" and the data frame containing the values from *subject_...txt* was given the name "Participant_id".
These data frames were all bound together column-wise using "bind_cols" so that the data was in the order of "participant_id", "activity_id" then the features from X.

