library(ggplot2)
library(rattle)
library(caret)
library(datasets)
data(iris)

library(shiny)
cat("... Server Init ...\n", file = stderr())

modelTree <- function(mod, runN){
  cat("... Updating Model Tree for model run", runN,"...\n", file = stderr())
  
  fancyRpartPlot(mod$finalModel)
}

# makePlot1 <- function(predDat, xVar, yVar){
#   if(is.null(xVar)) return()
#   cat("... Making Plot ...\n.xVar =", xVar, "yVar =", yVar, "...\n", file = stderr())
# 
#   g <- ggplot(data = predDat, aes(x = xVar, y = yVar, colour = predRight)) + geom_point()
#   print(g)
# }

shinyServer(
  function(input, output, session){
    cat("... Server Loaded ...\n", file = stderr())
    x <- 0
    
    runModel <- reactive({
      x <<- x + 1
      if(input$setSeed == TRUE) set.seed(7984)
      
      cols <- c(input$preds, "Species")
      inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)
      training <- iris[inTrain, cols]
      testing <- iris[-inTrain, cols]
      
      cat("... Model Run", x, ":", cols, "...\n", file = stderr())
      
      modFit <- train(Species ~ ., method = "rpart", data = training)
      pred <- predict(modFit, testing)
      testing$predRight <- pred == testing$Species
      cm <- confusionMatrix(pred, testing$Species)
      list(mod = modFit, conMat = cm, testDat = testing)
    })
    
    observe({
      updateSelectInput(session, "xVar1", choices = input$preds)
      updateSelectInput(session, "yVar1", choices = input$preds)
    })

    output$oSelected <- renderText({runModel()$mod$coefnames})
    output$oConMat <- renderPrint({runModel()$conMat})
    output$oTree <- renderPlot({modelTree(runModel()$mod, x)})
    # output$oPlot1 <- renderPlot({makePlot1(runModel()$testDat, input$xVar1, input$yVar1)})
    output$oDT <- renderTable({runModel()$testDat})
    output$oPlot1 <- renderPlot({
      qplot(input$xVar1, input$yVar1, colour=predRight, data = runModel()$testDat)
    })
  }
)
