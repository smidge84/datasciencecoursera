library(caret)
library(datasets)
data(iris)

library(shiny)
cat("... Server Init ...\n", file = stderr())

shinyServer(
  function(input, output){
    cat("... Server Loaded ...\n", file = stderr())
    x <- 0
    
    runModel <- reactive({
      x <<- x + 1
      if(input$setSeed == TRUE) set.seed(7984)
      
      cols <- c(input$preds, "Species")
      inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)
      training <- iris[inTrain, cols]
      testing <- iris[-inTrain, cols]
      
      cat("... Model Run: ", x, " ...\n", file = stderr())
      
      modFit <- train(Species ~ ., method = "rpart", data = training)
      cm <- confusionMatrix(predict(modFit, testing), testing$Species)
      list(mod = modFit, conMat = cm)
    })

    output$oSelected <- renderText({runModel()$mod$coefnames})
    output$oConMat <- renderPrint({runModel()$conMat})
  }
)
