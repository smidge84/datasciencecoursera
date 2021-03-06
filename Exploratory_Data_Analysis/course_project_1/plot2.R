## R script for creating plot 2

## Required packages
library(dplyr)
library(data.table)
library(lubridate)

dataFile <- "household_power_consumption.txt"

## reading in the entire data set
cat("\n## Reading in the Power Consumption Data Set.\n## This may take a long time.\n")
data <- read.table(dataFile, header = TRUE, sep = ";", na.strings = "?")

## Creating a data.table from the original data frame
data <- data.table(data)

## Changing the values in the Date variable from strings to Date objects
##data[, Date := as.Date(Date, "%d/%m/%Y")]

## Using lubridate to combine date and time info a single variable
data[, DateTime := dmy_hms(paste(Date, Time, sep = " "))]

## Selecting on the required observations
start_d <- dmy_hms("01/02/2007 00:00:00")
end_d <- dmy_hms("03/02/2007 00:00:00")

cat("\n## Subsetting data between dates", as.character(start_d), "and", as.character(end_d), "\n", sep=" ")

sample <- data[ (DateTime >= start_d & DateTime < end_d) ]
#sample <- filter(data, (Date >= start_d & Date <= end_d))

rm("data") ## Just to tidy things up and free some memory

#### CODE TO CREATE PLOT 2 BELOW ####

## Set output device to PNG file device
cat("\n## Creating plot\n")
file = "plot2.png"
png(filename = file, width = 480, height = 480, units = "px")

## Creating line plot
plot(sample[, DateTime], sample[, Global_active_power], type = "l", xlab = "Date & Time", ylab = "Global Active Power (kilowatts)")

## close output file device
dev.off()

cat("\n## Plot created and output to file:", file, sep = " ")
