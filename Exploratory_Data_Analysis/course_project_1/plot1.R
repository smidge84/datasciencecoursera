## R script for creating plot 1

## Required packages
library(dplyr)
library(data.table)

dataFile <- "household_power_consumption.txt"

## reading in the eintire data set
cat("\n## Reading in the Power Consumption Data Set.\n## This may take a long time.\n")
data <- read.table(dataFile, header = TRUE, sep = ";", na.strings = "?")

## Creating a data.table from the original data frame
data <- data.table(data)

## Changing the values in the Date variable from strings to Date objects
data[, Date := as.Date(Date, "%d/%m/%Y")]

## Selecting on the required observations
start_d <- as.Date("01/02/2007", "%d/%m/%Y")
end_d <- as.Date("02/02/2007", "%d/%m/%Y")

cat("\n## Subsetting data between dates", as.character(start_d), "and", as.character(end_d), "\n", sep=" ")

sample <- data[ (Date >= start_d & Date <= end_d) ]
#sample <- filter(data, (Date >= start_d & Date <= end_d))

rm("data") ## Just to tidy things up and free some memory

#### CODE TO CREATE PLOT 1 BELOW ####

## Set output device to PNG file device
cat("\n## Creating plot\n")
file = "plot1.png"
png(filename = file, width = 480, height = 480, units = "px")

## Create histogram
hist(sample[, Global_active_power], col = "red", main = "Global Active Power", xlab = "Global Active Power (killowatts)")

## close output file device
dev.off()

cat("\n## Plot created and output to file:", file, sep = " ")
