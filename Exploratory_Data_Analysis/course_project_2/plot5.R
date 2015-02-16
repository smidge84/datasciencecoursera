## Plot5.R
## 

## Required packages
library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)

## Reading in the data sets
cat("\n## Reading in the data sets and converting to data.table object.")
cat("\n## This may take some time.\n")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## COnverting to a data.table object for manipulation
NEI_DT <- data.table(NEI)
SCC_DT <- data.table(SCC)
rm("NEI") ## free up some memory
rm("SCC")

## Sub-setting the data for Baltimore City only (fips=24510)
bal_c <- NEI_DT[fips=="24510"]

## Finding SCC identifiers which are related to Motor Vehicles
## A Motor Vehicle source satisfies the following:
## 1) SCC.Level.One variables contains "Mobile"

motor_scc <- filter(SCC_DT, (str_detect(SCC.Level.One,"[Mm]obile")))

## Sub-setting the main data set based on the matching SCC identifiers
subDT <- bal_c[ SCC %in% motor_scc[, SCC]]

## Calculating the total emissions of our sub-set by year
res <- subDT[, .(Tot_Emi = sum(Emissions)/1000), by=year]

## Need to convert year values to a factor for plotting
res[, year := factor(year)]

cat("\n## Creating plot\n")
file = "plot5.png"

## Plot of total emissions from motor vehicles, Baltimore City, by year
g <- ggplot(res, aes(year, Tot_Emi))

g <- g + geom_bar(stat="identity", aes(fill=year), show_guide=FALSE)

g <- g + labs(title = "PM2.5 Fine Particle Emissions from Motor Vehicle Sources\nBaltimore City") +
  labs(x = "Year") +
  labs(y = "Total Emissions (thousands of tons)")

ggsave(file)
cat("\n## Plot created and output to file:", file, sep = " ")