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
  data <- split(raw, raw.State)
  snames <- names(date)
  
  
  
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  
}