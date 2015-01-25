---
title: "READ ME - run_analysis.R"
author: "Rich Robinson"
output: "html_document"
---

***

## File & Directory Structure

Before executing the *run_analysis.R* script, please ensure you have the following files arranged in the following hierarchy.

* working directory/
    + run_analysis.R
    + UCI HAR Dataset/
        + activity_labels.txt
        + featires.txt
        + test/
            + subject_test.txt
            + X_test.txt
            + y_test.txt
        + train/
            + subject_train.txt
            + X_train.txt
            + y_train.txt
            
Your working directory requires the 'run_analysis' script and the folder containing the original data provided from the experiment.

***

## Required R Packages

Packages required to successfully execute this script are:

* __data.table:__ Extension of data.frame
* __dplyr:__ A Grammar of Data Manipulation

Please ensure these packages, along with their dependencing are installed. The script will load them automatically upon execution.

***

## The "Base Data Path"

The relative path to the top level of the data set directory is refered to as the *"base data path"* which has been set as a variable at the top of the script called **baseDataPath**. If your data set is located in a location other than your working direcoty, by re-assigning the value of 'baseDataPath' to your specific path, the script should continue to function correctly.

***

## Script Execution

To execute the script, simply source the R script file into your R session and it will run instantly.
As possible refinement would be to encapsulate the main body of the script into a funtion so that it can be called from the R session when required, avoiding the need to re-source the file every time the user wished to execute the script. This will also allow for argument passing to change the behavior of the code from the default, allowing the code to be more flexible and not 'hard coded'.

During execution, a series of print statments are displayed to help show the progress of the script and if it has become frozen. These statements are:

* Loading training data
* Loading test data
* Merging traing data and test data into a single data set
* Selecting only the mean & standard deviation of each variable
* Improving readablity of data set by replacing activity id values with activity names
* Creating a separate data set summary by participant of mean variable values for each activity
* Writing out tidy data sets to files
* END OF DATA ANALYSIS

***

## Reading in the Exported Data

To read in the data exported to text files by the script for further analysis and maipulation later, using the read.table function with default arguments sould work correctly. This will specify the value separator argument *(sep)* as any 'white space' character (the empty string), but if you wish to be more restrictive, the separator argument should be explicitly set to be a 'white space'.

```
DT <- read.table(path_to_file, header = TRUE, sep="")
DT <- read.table(path_to_file, header = TRUE, sep=" ")
```

***

## Footnotes

run_analysis.R was created in the following environment

* Windows Vista Home Premium, Service PAck 2
* R Version 3.1.2 (2014-10-31) - Pumpkin Helmet
* R Studio Version 0.98.1062
* dplyr package - version 0.4.0
* data.table package - version 1.9.4

***
