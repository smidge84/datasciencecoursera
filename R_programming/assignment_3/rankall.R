## This function will return a data frame containing hospital name
## in each state which is ranked at the specified level for a given
## feature of the hospital.
## There are two arguments:
## 'outcome' is the feature to be compared
## 'num' is the ranking position to return, this can be a numerical
## value  or 'best' or 'worst'
## The function returns a 2 column data frame:
## [ , 1] - Hospital Name
## [ , 2] - State

rankall <- function(outcome, num = "best") {
  ## Read outcome data
  raw <- read.csv("./outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that outcome is a valid argument
  col <- 0 ## The column to analyise
  hos.name <- 2 ## The column to find the hospital name
  
  ## checking outcome arguement and assigning corresponding column number to col
  if (outcome == "heart attack"){
    col <- 11
  } else if (outcome == "heart failure"){
    col <- 17
  } else if (outcome == "pneumonia"){
    col <- 23
  } else {
    stop("invalid outcome") ## outcome arguement is invalid
  }
  
  ## Processing the raw data, splitting it into groups by state
  data.by.state <- split(raw, raw$State)
  snames <- names(data.by.state)
  
  ## parsing the 'num' arguement
  rank <- 0 ## rank is the index to return from the sorted data
  if (num == "best"){ # The first row in the data frame
    rank <- 1
  } else {
    rank <- num ## if it's an integer, just assign it
  }
  ## if num = "worst", this will be handled later so that rank isn't
  ## repeatedly evaluated
  
  ## For each state, find the hospital of the given rank
  N <- length(snames)
  ## pre-allocating the space for the results data frame
  res <- data.frame(hospital=rep(".", N), state=rep(".", N), stringsAsFactors=FALSE)
  
  idx <- 1 # index counter so we know where to append in data frame
  for(state in snames){
    ## selecting only the data of the required state
    data.of.state <- data.by.state[[state]]
    ## converting required column data to numerics from characters
    data.of.state[, col] <- as.numeric(data.of.state[, col])
    ## using complete.cases to remove entries with NA or NAN values
    data.clean <- data.of.state[complete.cases(data.of.state[ , col]), ]
    ## sorting the data first by 'col', then by 'Hospital Name'
    sorted.data <- data.clean[order(data.clean[ , col], data.clean[ , hos.name]), ]
    
    ## evaluate value for 'rank' if seeking "worst" result
    if(num == "worst"){ # The last row in the data frame
      rank <- dim(sorted.data)[1]
    }
    
    ## appending desired record to results data frame
    res[idx, 1] <- sorted.data[rank, hos.name]
    res[idx, 2] <- state
    idx <- idx + 1 # incriment counter
  }
  
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  return(res)
}