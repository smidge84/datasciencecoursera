pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  
  
  vals <- numeric()
  pol_id <- integer(1)
  
  if (pollutant == "sulfate"){
    pol_id <- 2
  } else if (pollutant == "nitrate"){
    pol_id <- 3
  }
  
  for (i in id){
    
    ## construct file pointer
    fp <- ""
    if (i < 10){
      fp <- paste(directory, "/00", i, ".csv", sep = "")
    } else if (i >= 10 && i < 100){
      fp <- paste(directory, "/0", i, ".csv", sep = "")
    } else if (i >= 100 && i < 1000){
      fp <- paste(directory, "/", i, ".csv", sep = "")
    }
    
    ## open file data
    data <- read.csv(fp)
    ## remove any NA values in out specified column
    data.clean <- data[complete.cases(data[ , pol_id]), ]
    ## append data values to compiled data vector
    vals <- c(vals, data.clean[ ,pol_id])
    
  }
  
  ## calculate & return single mean of all values in compiled data vector
  return(mean(vals))
}

