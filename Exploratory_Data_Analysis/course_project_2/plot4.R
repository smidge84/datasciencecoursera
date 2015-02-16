## plot4.R
## Plot of emissions from Coacl Combustion related sources for whole United States by year

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

## Finding SCC identifiers which are related to Coal Combustion
## A coal combustino source satisfies the following:
## 1) SCC.Level.One variables contains "Combustion"
## 2) SCC.Level.Three variable contains "Coal"

coal_scc <- filter(SCC_DT, ((str_detect(SCC.Level.One,"[Cc]ombustion")) & (str_detect(SCC.Level.Three, "[Cc]oal"))))

## Sub-setting the main data set based on the matching SCC identifiers
subDT <- NEI_DT[ SCC %in% coal_scc[, SCC]]

## Calculating the total emissions of our sub-set by year
res <- subDT[, .(Tot_Emi = sum(Emissions)/1000), by=year]

## Need to convert year values to a factor for plotting
res[, year := factor(year)]

cat("\n## Creating plot\n")
file = "plot4.png"

## Plot of total emissions from coal combustion, whole USA, by year
g <- ggplot(res, aes(year, Tot_Emi))

g <- g + geom_bar(stat="identity", aes(fill=year), show_guide=FALSE)

g <- g + labs(title = "PM2.5 Fine Particle Emissions from Coal Combustion Sources\nWhole United States") +
  labs(x = "Year") +
  labs(y = "Total Emissions (thousands of tons)")

ggsave(file)
cat("\n## Plot created and output to file:", file, sep = " ")
