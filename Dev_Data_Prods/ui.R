## Developing Data Products Course Project
## SHINY USER INTERFACE
library(datasets)
data(iris)

library(shiny)

## User Interface Creation
shinyUI(
  pageWithSidebar(

    headerPanel("Regression Tree Model Evaluator"),
    
    sidebarPanel(
      
      checkboxGroupInput('preds', "Choose Predictors for Model:",
                          names(iris)[-5], selected = "Sepal.Length"),
      
      checkboxInput('setSeed', "Reproducible Results?",
                    value = TRUE),
      
      submitButton("Run Model")
      
    ),
    
    mainPanel(
      h3("Selected Predictors"),
      textOutput("oSelected"),
      hr(),
      h3("Confusion Matrix"),
      verbatimTextOutput("oConMat")
    )
    
  )
)
