complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1 117
  ## 2 1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  
  vals <- data.frame(id, integer(length(id)))
  colnames(vals) <- c("id", "nobs") ## set column names
  idx <- 1 ## loop counter for indexing into data frame
  
  
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
    data.clean <- data[complete.cases(data[ , ]), ]
    ## set the number of complete rows in the vals DF
    vals[idx, 2] <- nrow(data.clean)
    ## incriment the loop counter
    idx <- idx + 1
    
  }
  
  ## return the data frame of complete observations
  return(vals)
  
}