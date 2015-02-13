## Plot2.R
## Plot of total emissions for Baltimore City only by year

## Required Libraries
library(data.table)


## Reading in the data sets
cat("\n## Reading in the data sets and converting to data.table object.")
cat("\n## This may take some time.\n")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## COnverting to a data.table object for manipulation
NEI_DT <- data.table(NEI)
rm("NEI") ## free up some memory

## Sub-setting the data for Baltimore City only (fips=24510)
subDT <- NEI_DT[fips=="24510"]

## Calculating the total emissions by year for Baltimore City
res <- subDT[, .(Tot_Emi = sum(Emissions)/1000), by=year]

## Set output device to PNG file device
cat("\n## Creating plot\n")
file = "plot2.png"
png(filename = file, width = 480, height = 480, units = "px")

## Creating bar plot & annotating
barplot(res$Tot_Emi, res$year, ylim = c(0, max(res$Tot_Emi)+1), col = rainbow(4), axisnames = TRUE, names.arg = res$year)
title(main = "PM2.5 Fine Partical Emissions by Year\nBaltimore City")
title(ylab = "Total Emissions (thousands of tons)")
title(xlab = "Year")

## close output file device
dev.off()

cat("\n## Plot created and output to file:", file, sep = " ")