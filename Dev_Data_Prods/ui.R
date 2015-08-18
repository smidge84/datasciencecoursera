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
                       p("Options here for scatter plot"),
                       p("Drop down list for x-variable"),
                       p("Drop down list for y-variable")
        
      ),
      conditionalPanel(condition = "input.tabs == 'tab4'",
                       p("Options for another scatter plot here"),
                       p("Probably as tab3 ut maybe some explanitory text")
        
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
                 p("Scatter Plot to appear here")
        ),
        tabPanel("Correct Outcomes", value = "tab4",
                 p("Plot of corrct outcomes here")
        ),
        id = "tabs"
      )
    )
    
  )
)
