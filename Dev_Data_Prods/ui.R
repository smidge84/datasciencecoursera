## Developing Data Products Course Project
## SHINY USER INTERFACE
library(datasets)
data(iris)
require(e1071)
library(shiny)

## User Interface Creation
shinyUI(
  pageWithSidebar(

    headerPanel("Regression Tree Model Evaluator"),
    
    sidebarPanel(
      
      conditionalPanel(condition = "input.tabs == 'tab1'||input.tabs == 'tab0'",
                       checkboxGroupInput('preds', "Choose Predictors for Model:",
                                          names(iris)[-5], selected = "Sepal.Length"),
                       
                       checkboxInput('setSeed', "Reproducible Results?",
                                     value = TRUE),
                       
                       numericInput("seedVal", "Input Seed Value:", value = 7984, min = 0, step = 1)
                       
                       #submitButton("Run Model") # no submit in conditional panels
      ),
      conditionalPanel(condition = "input.tabs == 'tab2'",
                       p("The classification tree shows how best the data is separatable at each stage of the model, bu which variable."),
                       p("At each stage (node) the data is split into two groups (leaves) by the variable which best does so."),
                       p("The step of choosing a variable which best splits the outcomes continues until the groups are too small or the outcomes are homogenous.")
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
        tabPanel("Instructions", value = "tab0",
                 h3("What Do I DO?"),
                 p("This app is designed to help users understand through a interactive and visual way what is happening with basic prediction algorithms."),
                 p("Currently the app only uses simple classification or regression trees."),
                 p("The app is hard coded using the iris data set from the R datasets package, and the model configured to use selected predictors to predict the species as the outcome."),
                 p("Using the options in the sidebar to the left, select the variables you would like to use from the data set to predict the species. Each time you change the model, the results will change automatically. If you would like the model to always produce the same results, please check the Reporducible Results box and provide a seed number."),
                 p("WARNING: Please ensure at least one predictor is selected at all times, otherwise the app will throw an error."),
                 p("Use the tabs above to see output and results from the model.")
          
        ),
        tabPanel("Summary", value = "tab1",
                 h3("Selected Predictors"),
                 textOutput("oSelected"),
                 hr(),
                 h3("Confusion Matrix"),
                 verbatimTextOutput("oConMat")
        ),
        tabPanel("Tree", value = "tab2",
                 h3("Classification Tree"),
                 #plotOutput("oTree")
                 p("The classification tree is cirrently not available because the Rattle package is not supported by shinyapps.io")
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
