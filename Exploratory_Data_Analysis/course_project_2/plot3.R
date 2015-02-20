## plot3.R
## Plot using the ggplot2 package of total emissions of each
## source by year for Baltimore City only

## Required packages
library(data.table)
library(ggplot2)
library(RColorBrewer) ## For better colour palettes

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

## Calculating the total emissions of each source by year
res <- subDT[, .(Tot_Emi = sum(Emissions)/1000), by = .(type, year)]

## Need to convert year values to a factor for plotting
res[, year := factor(year)]

cat("\n## Creating plot\n")
file = "plot3.png"

## Creating a conditional plot of total emmissions each year by source
g <- ggplot(res, aes(year, Tot_Emi))

## Adding asthetics, bars and facets
g <- g + geom_bar(stat="identity", aes(fill=year)) + facet_grid(. ~ type)

## Using Color Brewer package to improve colours in plot
g <- g + scale_fill_brewer(palette="Spectral")

g <- g + labs(title = "PM2.5 Fine Particle Emissions per Year by Emission Source\nBaltimore City") + labs(x = "Year") + labs(y = "Total Emissions (thousands of tons)")
      
ggsave(file, height=4, width=8, dpi=300)
cat("\n## Plot created and output to file:", file, sep = " ")
