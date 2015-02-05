## R script for creating plot 4

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

#### CODE TO CREATE PLOT 4 BELOW ####

## Set output device to PNG file device
cat("\n## Creating plot\n")
file = "plot4.png"
png(filename = file, width = 480, height = 480, units = "px")

## Creating 4 graph plot 2x2
## setting global plot attributes
par(mfrow = c(2, 2), mar = c(4, 4, 2, 2))

## 1 - Line plot of global active power (aka plot 2)
cat("\n## Creating sub-plot 1 - Global Active Power\n")
plot(sample[, DateTime], sample[, Global_active_power], type = "l", xlab = "Date & Time", ylab = "Global Active Power (kilowatts)")

## 2 - Line plot of voltage
cat("\n## Creating sub-plot 2 - Voltage\n")
plot(sample[, DateTime], sample[, Voltage], type = "l", xlab = "Date & Time", ylab = "Voltage")

## 3 - Creating empty plot 3 with axes names
cat("\n## Creating sub-plot 3 - Energy Sub Metering\n")
plot(sample[, DateTime], sample[, Sub_metering_1], type = "n", xlab = "Date & Time", ylab = "Energy Sub Metering")

## Adding lines to the plot
cat("\n## Creating sub-plot 4 - Global Reavtive Power\n")
lines(sample[, DateTime], sample[, Sub_metering_1])
lines(sample[, DateTime], sample[, Sub_metering_2], col = "red")
lines(sample[, DateTime], sample[, Sub_metering_3], col = "blue")

## Adding legend to plot
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## 4 - Creating plot 4
plot(sample[, DateTime], sample[, Global_reactive_power], type = "l", xlab = "Date & Time", ylab = "Global Reactive Power (kilowatts)")

## close output file device
dev.off()

cat("\n## Plot created and output to file:", file, sep = " ")