## The 'rankhospital' function will return the hospital in the specified
## state that is a particular ranking for the feature required.
## The function has three arguements:
## 'state' is the two character abbriviation of the state
## 'outcome' is the feature to anauise
## 'num' is the ranking position to return, this can be a numerical
## value  or 'best' or 'worst'
## The function returns a character array of the hospital name or NA
## if the specified index was beyond the length of the possibilities

rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  raw <- read.csv("./outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  ## By splitting the data by state, then check to see if a matching state exists
  data.by.state <- split(raw, raw$State)
  snames <- names(data.by.state)
  bool <- lapply(snames, function(st) st == state)
  ## converting bool from a list of lists of booleans, to a boolean
  bool2 <- as.logical(bool)
  
  if (sum(bool2) != 1){
    ## state arguement is invalid
    stop("invalid state")
  }
  ## else continue to check if outcome arguement is valid
  ## to be valid it must be one of "heart attack", "heart failure" 
  ## or "pheumonia".
  ## Because there are only a few outcome, I will simply hard code
  ## the corresponding column numbers to analyise.
  
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
  
  ## selecting only the data of the required state
  data.of.state <- data.by.state[[state]]
  ## converting required column data to numerics from characters
  data.of.state[, col] <- as.numeric(data.of.state[, col])
  ## using complete.cases to remove entries with NA or NAN values
  data.clean <- data.of.state[complete.cases(data.of.state[ , col]), ]
  ## sorting the data first by 'col', then by 'Hospital Name'
  sorted.data <- data.clean[order(data.clean[ , col], data.clean[ , hos.name]), ]
  
  ## parsing the 'num' arguement
  rank <- 0 ## rank is the index to return from the sorted data
  if (num == "best"){ # The first row in the data frame
    rank <- 1
  } else if (num == "worst"){ # The last row in the data frame
    rank <- dim(sorted.data)[1]
  } else {
    rank <- num ## if it's an integer, just assign it
  }
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  return(sorted.data[ rank, hos.name])
}