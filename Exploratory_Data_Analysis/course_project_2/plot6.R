## Plot6.R
## 

## Required packages
library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)
library(RColorBrewer)

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

## Sub-setting the data for Baltimore City (fips=24510) & Los Angeles County (fips=06037)
bal_la <- NEI_DT[fips %in% c("24510", "06037")]

## Finding SCC identifiers which are related to Motor Vehicles
## A Motor Vehicle source satisfies the following:
## 1) SCC.Level.One variables contains "Mobile"

motor_scc <- filter(SCC_DT, (str_detect(SCC.Level.One,"[Mm]obile")))

## Sub-setting the main data set based on the matching SCC identifiers
subDT <- bal_la[ SCC %in% motor_scc[, SCC]]

## Calculating the total emissions of our sub-set by year
res <- subDT[, .(Tot_Emi = sum(Emissions)/1000), by=.(fips, year)]

## Need to convert year values to a factor for plotting
res[, year := factor(year)]

## Replacing fips codes with location Names
dt <- data.table(c("06037", "24510"), c("Los Angeles County", "Baltimore City"))
setnames(dt, c("fips", "location"))
res2 <- left_join(res, dt, by="fips")


cat("\n## Creating plot\n")
file = "plot6.png"

## Plot of total emissions from motor vehicles, Baltimore City, by year
g <- ggplot(res2, aes(year, Tot_Emi))

g <- g + geom_bar(stat="identity", aes(fill=location), position="dodge")

## Setting plot colours using R Color Brewer palette
g<- g + scale_fill_brewer(palette="Set1")

g <- g + labs(title = "PM2.5 Fine Particle Emissions from Motor Vehicle Sources\nBaltimore City & Los Angeles County") +
  labs(x = "Year") +
  labs(y = "Total Emissions (thousands of tons)")

ggsave(file)
cat("\n## Plot created and output to file:", file, sep = " ")

