corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
  comp_obs <- complete(directory) ## data frame of complete obs count
  corr <- numeric() ## return values
  
  ## loop over comp_obs then do stuff if nobs is above threshold
  for (i in 1:nrow(comp_obs)){
    row <- comp_obs[i, ]
    if (row$nobs >= threshold){
      
      ## construct file pointer
      fp <- ""
      j <- row$id
      if (j < 10){
        fp <- paste(directory, "/00", j, ".csv", sep = "")
      } else if (j >= 10 && j < 100){
        fp <- paste(directory, "/0", j, ".csv", sep = "")
      } else if (j >= 100 && j < 1000){
        fp <- paste(directory, "/", j, ".csv", sep = "")
      }
      
      ## open file data
      data <- read.csv(fp)
      ## remove any NA values in entire data set
      data.clean <- data[complete.cases(data[ , ]), ]
      ## calculate the correlation between sulfate & nitrate, store in corr
      corr[i] <- cor(data.clean$sulfate, data.clean$nitrate)
    }
    
  }
  
  return(corr)
}