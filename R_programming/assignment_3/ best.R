## The 'best' function will return the best hospitals in a particular
## state for a specified category.
## The 'state' arguement is a 2 character abbreviation for the state
## The 'outcome' arguement specified what feature of the hospitals we
## want to compare and find the best of.
## The function will return the hospital name of the top value
best <- function(state, outcome) {
  ## Read outcome data
  raw <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  ## By splitting the data by state, then check to see if a matching state exists
  data.by.state <- split(raw, raw.State)
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
  data.of.state <- data.by.state$state
  ## using complete.cases to remove entries with NA or NAN values
  data.clean <- data.of.state[complete.cases(data.of.state[ , col]), ]
  ## sorting the data first by 'col', then by 'Hospital Name'
  sorted.data <- data.clean[order(data.clean[ , col], data.clean[ , hos.name]), ]
      
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  return(sorted.data[ 1, hos.name])
}