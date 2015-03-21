# United States Storm Analysis and Effects on Population and Economy
Rich Robinson  

# Synopsis
This analysis is going to use storm data provided by NOAA from 1950 to November 2011 to assess the impact these storms have had on the health of the population and the consequences to the economy.

# Data Processing

## Downloading & Reading the Data
The [NOAA Storm Database][1] tracks characteristics of major storms and weather events across the United States. It includes information on where and when they occur and estimates for fatalities, injuries and damage to properties. This data set containes information from 1950 to November 2011. At the start of the data set there are considerably records, however more recent entries are more complete.

[1]: https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2 "NOAA Storm Database"  

The data file is downloaded as part of this document (if not already available in the working directory), is named **"StormData.csv.bz2"** and is read into R by opening a bz file connection into the `read.csv` function. 


```r
zip_url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
bz_file <- "StormData.csv.bz2"

## Checking to see if required files are present
if (!file.exists(bz_file)){
  download.file(zip_url, destfile = bz_file)
}  
if (!exists("noaa_data")){
  noaa_data <- read.csv(bzfile(bz_file), header = TRUE, stringsAsFactors = FALSE)
}
```

## Analysing the Data Set

The data set is large and requires quite a lot of time to read in. There are a total of 902297 records and 37 variables.


```r
dim(noaa_data)
```

```
## [1] 902297     37
```

The heading for these variables are:

```r
names(noaa_data)
```

```
##  [1] "STATE__"    "BGN_DATE"   "BGN_TIME"   "TIME_ZONE"  "COUNTY"    
##  [6] "COUNTYNAME" "STATE"      "EVTYPE"     "BGN_RANGE"  "BGN_AZI"   
## [11] "BGN_LOCATI" "END_DATE"   "END_TIME"   "COUNTY_END" "COUNTYENDN"
## [16] "END_RANGE"  "END_AZI"    "END_LOCATI" "LENGTH"     "WIDTH"     
## [21] "F"          "MAG"        "FATALITIES" "INJURIES"   "PROPDMG"   
## [26] "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP" "WFO"        "STATEOFFIC"
## [31] "ZONENAMES"  "LATITUDE"   "LONGITUDE"  "LATITUDE_E" "LONGITUDE_"
## [36] "REMARKS"    "REFNUM"
```
The variables of particular interest include:  

* BGN_DATE
* EVTYPE
* FATALITIES
* INJURIES
* PROPDMG
* CROPDMG

## Event Severity with respect to Public Health
To assess which events are most harmful to public health lets look at those events which have the highest number fatalities and injuries. First lets subset our data for the required fields and look into the different event types.


```r
library(dplyr)

health_d <- noaa_data %>% select(EVTYPE, FATALITIES, INJURIES)

n_evt <- length(unique(health_d$EVTYPE))
n_evt
```

```
## [1] 985
```

```r
head(unique(health_d$EVTYPE), n=10)
```

```
##  [1] "TORNADO"                   "TSTM WIND"                
##  [3] "HAIL"                      "FREEZING RAIN"            
##  [5] "SNOW"                      "ICE STORM/FLASH FLOOD"    
##  [7] "SNOW/ICE"                  "WINTER STORM"             
##  [9] "HURRICANE OPAL/HIGH WINDS" "THUNDERSTORM WINDS"
```
There are 985 different types of meteological events on record. The first ten of them are lsted above. Upon quick analysis of this list, some of the event types appear to be summaries of events of specific events. Examples are shown below.

```r
library(stringr)
## extract examples of 'summary' event types

reg_exp <- "^[Ss]ummary"
sum_evts <- health_d %>% filter(str_detect(EVTYPE, reg_exp))
num_sum_evts <- length(sum_evts$EVTYPE)
uni_num_sum_evts <- length(unique(sum_evts$EVTYPE))
head(sum_evts$EVTYPE, n=9)
```

```
## [1] "Summary Jan 17"       "Summary of March 14"  "Summary of March 23" 
## [4] "Summary of March 24"  "Summary of April 3rd" "Summary of April 12" 
## [7] "Summary of April 13"  "Summary of April 21"  "Summary August 11"
```

```r
num_sum_evts
```

```
## [1] 72
```

```r
uni_num_sum_evts
```

```
## [1] 63
```
The code chunk above shows the first nine *"summary"* records within our data set. There are a total of 72 summary records, of which 63 are unique.  
We will omit these records from our analysis as it is likely they will be a replication of data already in our subset under the specific meteological event's record. Duplication of values would skew our results.

```r
options(scipen=1)
## we negate the outcome of 'str_detect' because we want records which are
## not 'summary' records.
health_d2 <- health_d %>% filter(!str_detect(EVTYPE, reg_exp))

res_health <- health_d2 %>% group_by(EVTYPE) %>% summarise(harm = sum(FATALITIES)+sum(INJURIES))
res_health <- res_health %>% arrange(desc(harm))
head(res_health, n=10)
```

```
## Source: local data frame [10 x 2]
## 
##               EVTYPE  harm
## 1            TORNADO 96979
## 2     EXCESSIVE HEAT  8428
## 3          TSTM WIND  7461
## 4              FLOOD  7259
## 5          LIGHTNING  6046
## 6               HEAT  3037
## 7        FLASH FLOOD  2755
## 8          ICE STORM  2064
## 9  THUNDERSTORM WIND  1621
## 10      WINTER STORM  1527
```
To assess the level of *harm* for each event type, the number of fatalities and injuries were added together. The above table shows the top 10 most harmful event types. The number one most harmful evet type is **TORNADO** with a total of **96979** fatalities and injuries.  

## Economic Consequences of Severe Weather Events
To investigate which severe weather events have greatest economic consequences, let us consider the values of damage done to property and to crops. As before, first lets subset our complete data set for the following variabes of intrest:

* BGN_DATE
* EVTYPE
* PROPDMG
* CROPDMG

The date of the event can be of interest so we can look at changes in economic damage over time. Of all the date information available in the data set, we will only conside the date when the event started to categorise the time period the event belongs in. This will remove problems when an event persists across years.  
To investigate this query, the data processing has been completed using the `data.table` package as it is very efficient and concise when coding.


```r
library(data.table)
## creating a data.table version of the original data for efficient processing

noaa_dt <- data.table(noaa_data)

## Selecting only the required variables
eco1_dt <- noaa_dt[, .(BGN_DATE, EVTYPE, PROPDMG, CROPDMG)]

## Removing the 'summary' records as definer earlier
#eco_dt <- eco1_dt[ EVTYPE == sum_evts$EVTYPE] #<- not working correctly
eco_dt <- eco1_dt %>% filter(!str_detect(EVTYPE, reg_exp))
```
Again the *'summary'* event records were removed as their values will be duplicated in the associated event record.  
In the original data set, the dates are `string` arrays. To copute them easier, it is better that they are variables of the `Date` class.

```r
## converting the date variable from a string to the Date class
eco_dt[, BGN_DATE := as.Date(BGN_DATE, "%m/%d/%Y")]
```

```
##           BGN_DATE     EVTYPE PROPDMG CROPDMG
##      1: 1950-04-18    TORNADO    25.0       0
##      2: 1950-04-18    TORNADO     2.5       0
##      3: 1951-02-20    TORNADO    25.0       0
##      4: 1951-06-08    TORNADO     2.5       0
##      5: 1951-11-15    TORNADO     2.5       0
##     ---                                      
## 902221: 2011-11-30  HIGH WIND     0.0       0
## 902222: 2011-11-10  HIGH WIND     0.0       0
## 902223: 2011-11-08  HIGH WIND     0.0       0
## 902224: 2011-11-09   BLIZZARD     0.0       0
## 902225: 2011-11-28 HEAVY SNOW     0.0       0
```

```r
## Grouping Dates into Decades for later comparison
decs_seq <- seq(as.Date("01/01/1950", "%m/%d/%Y"), length.out=8, by="10 year")
dec_labs <- c("1950s", "1960s", "1970s", "1980s", "1990s", "2000s", "2010s")
eco_dt[, DECADE := cut(BGN_DATE, decs_seq, labels = dec_labs)]
```

```
##           BGN_DATE     EVTYPE PROPDMG CROPDMG DECADE
##      1: 1950-04-18    TORNADO    25.0       0  1950s
##      2: 1950-04-18    TORNADO     2.5       0  1950s
##      3: 1951-02-20    TORNADO    25.0       0  1950s
##      4: 1951-06-08    TORNADO     2.5       0  1950s
##      5: 1951-11-15    TORNADO     2.5       0  1950s
##     ---                                             
## 902221: 2011-11-30  HIGH WIND     0.0       0  2010s
## 902222: 2011-11-10  HIGH WIND     0.0       0  2010s
## 902223: 2011-11-08  HIGH WIND     0.0       0  2010s
## 902224: 2011-11-09   BLIZZARD     0.0       0  2010s
## 902225: 2011-11-28 HEAVY SNOW     0.0       0  2010s
```

```r
d1 <- eco_dt[, BGN_DATE][1] ## First date
dx <- eco_dt[, BGN_DATE][dim(eco_dt)[1]] ## Last date
yrs <- length(seq(d1, dx, by="year")) ## Calculate number of years
```
The first record date is: 1950-04-18 and the last record date is: 2011-11-28 which spans a total of 62. Since this spans a long time period, it might be more convenient for a quick analysis to reduce the resolution by looking at the values across each decade. In order to achieve this the continuous dates values were converted into descrite decade values using a factor variable. The code chunck below shows the first six records and illustrates how a new factor variable `DECADE` has been created.

```r
head(eco_dt)
```

```
##      BGN_DATE  EVTYPE PROPDMG CROPDMG DECADE
## 1: 1950-04-18 TORNADO    25.0       0  1950s
## 2: 1950-04-18 TORNADO     2.5       0  1950s
## 3: 1951-02-20 TORNADO    25.0       0  1950s
## 4: 1951-06-08 TORNADO     2.5       0  1950s
## 5: 1951-11-15 TORNADO     2.5       0  1950s
## 6: 1951-11-15 TORNADO     2.5       0  1950s
```
Two new data tables are created below. The first computes the total (economic) destruction for each event type for by decade. The total destruction is defined as the sum of property damage and crop damage *(combined destruction)*. The second data table is the total destruction, defined similarly, over the whole of the data set *(total destruction)*.

```r
## Computing the total destruction of each event type by decade
dest_decs <- eco_dt[, .(COMB_DEST = sum(PROPDMG) + sum(CROPDMG)), by=.(EVTYPE, DECADE)][order(DECADE, -COMB_DEST)]
## used data.table chaining to re-order the results for readability

## Computing the total (economic) destruction for each event type over whole date range
dest_all <- eco_dt[, .(TOTAL_DEST = sum(PROPDMG) + sum(CROPDMG)), by=EVTYPE][order(-TOTAL_DEST)]

head(dest_decs)
```

```
##       EVTYPE DECADE COMB_DEST
## 1:   TORNADO  1950s  237689.4
## 2: TSTM WIND  1950s       0.0
## 3:      HAIL  1950s       0.0
## 4:   TORNADO  1960s  328469.4
## 5: TSTM WIND  1960s       0.0
## 6:      HAIL  1960s       0.0
```

```r
head(dest_all)
```

```
##               EVTYPE TOTAL_DEST
## 1:           TORNADO  3312276.7
## 2:       FLASH FLOOD  1599325.1
## 3:         TSTM WIND  1445168.2
## 4:              HAIL  1268289.7
## 5:             FLOOD  1067976.4
## 6: THUNDERSTORM WIND   943635.6
```


# Results

Analysis of effect on public health could include a plot with facets by event type of stacked bar plots (to show total of harm and proportion fatalaties/health). Certainly this shoud be for only non-zero event types, of which there are 220. But 220 is a lot of plots, so maybe we should focus on a sub-set (10, 15, 20???). By using stacked bar plots we can discuss which events have the overal most harm, but also look into those which have the most fatalities or most injuries. 


```r
library(ggplot2)
library(tidyr) ## required to reshape data from wide to long format

res_health2 <- health_d2 %>% group_by(EVTYPE) %>% summarise(Fatalities = sum(FATALITIES), Injuries = sum(INJURIES))

## selecting data to plot from the top 10 most 'harmful' event types as in res_health from earlier.
top10 <- res_health2 %>% filter((Fatalities + Injuries) >= res_health$harm[10])
top10
```

```
## Source: local data frame [10 x 3]
## 
##               EVTYPE Fatalities Injuries
## 1     EXCESSIVE HEAT       1903     6525
## 2        FLASH FLOOD        978     1777
## 3              FLOOD        470     6789
## 4               HEAT        937     2100
## 5          ICE STORM         89     1975
## 6          LIGHTNING        816     5230
## 7  THUNDERSTORM WIND        133     1488
## 8            TORNADO       5633    91346
## 9          TSTM WIND        504     6957
## 10      WINTER STORM        206     1321
```

```r
## This data is in a wide format. It would be better for plotting in a long format.
top10_long <- gather(top10, "harm", "count", Fatalities:Injuries)
g1 <- ggplot(top10_long, aes(x=EVTYPE, y=count, fill=harm)) + geom_bar(stat="identity")
g1 <- g1 + theme(axis.text.x = element_text(angle=90, vjust=1))
g1 <- g1 + labs(title = "Top 10 most Harmful Event Types") + xlab("Type of Event") + ylab("Total Number of Casulties") + theme(plot.title = element_text(face="bold"))
g1
```

![](noaa_analysis_files/figure-html/res_health-1.png) 
