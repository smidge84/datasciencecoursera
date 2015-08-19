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
      
      conditionalPanel(condition = "input.tabs == 'tab1'",
                       checkboxGroupInput('preds', "Choose Predictors for Model:",
                                          names(iris)[-5], selected = "Sepal.Length"),
                       
                       checkboxInput('setSeed', "Reproducible Results?",
                                     value = TRUE)
                       
                       #submitButton("Run Model") # no submit in conditional panels
      ),
      conditionalPanel(condition = "input.tabs == 'tab2'",
                       p("Sidebar Options for regression tree here")
      ),
      conditionalPanel(condition = "input.tabs == 'tab3'",
                       p("Select variables for axes."),
                       selectInput("xVar1", "Select X Variable", choices = NULL),
                       selectInput("yVar1", "Select Y Variable", choices = NULL)
        
      ),
      conditionalPanel(condition = "input.tabs == 'tab4'",
                       p("Please select variables for axes."),
                       selectInput("xVar2", "Select X Variable", choices = names(iris)[-5], selected = "Sepal.Length"),
                       selectInput("yVar2", "Select Y Variable", choices = names(iris)[-5], selected = "Petal.Length")
        
      )
      
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", value = "tab1",
                 h3("Selected Predictors"),
                 textOutput("oSelected"),
                 hr(),
                 h3("Confusion Matrix"),
                 verbatimTextOutput("oConMat")
        ),
        tabPanel("Tree", value = "tab2",
                 h3("Random Forest Classification Tree"),
                 plotOutput("oTree")
        ),
        tabPanel("Scatter Plot", value = "tab3",
                 h3("Predicting New Values"),
                 plotOutput("oPlot1"),
                 hr(),
                 h3("Table of Predicted Species"),
                 tableOutput("oDT")
        ),
        tabPanel("Correct Outcomes", value = "tab4",
                 plotOutput("oPlot2"),
                 p("The plot above shows the whole data set, coloured by species, to help visually understand the data set."),
                 p("By selecting various combinations of variables, plot with the most distinct clustering will yield better models.")
                 
        ),
        id = "tabs"
      )
    )
    
  )
)
