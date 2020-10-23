#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(caret)
library(e1071)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Fetch selected features for each axis
    xAxis <- reactive({
        switch(input$xAxis,
               Sepal.Length = iris$Sepal.Length,
               Sepal.Width = iris$Sepal.Width,
               Petal.Length = iris$Petal.Length,
               Petal.Width = iris$Petal.Width
        )
    })
    
    yAxis <- reactive({
        switch(input$yAxis,
               Sepal.Length = iris$Sepal.Length,
               Sepal.Width = iris$Sepal.Width,
               Petal.Length = iris$Petal.Length,
               Petal.Width = iris$Petal.Width
        )
    })
    
    # Build model and predict flower Species based off of user input
    modelPred <- reactive({
        
        xAxisName <- input$xAxis
        yAxisName <- input$yAxis
        
        control <- trainControl(method='cv', number=10)
        
        # Build model formula
        test1 <- paste("Species ~ ", input$xAxis)
        test2 <- paste(test1, "+")
        test3 <- paste(test2, input$yAxis)
        
        # Build model
        model <- train(formula(test3), data=iris, method='lda', trControl=control)
        
        # Get user inputs
        xPredInput <- input$xAxisPred
        yPredInput <- input$yAxisPred
        
        newData <- data.frame(xPredInput,yPredInput)
        names(newData)[names(newData) == "xPredInput"] <- input$xAxis
        names(newData)[names(newData) == "yPredInput"] <-  input$yAxis
        
        modelPred <- predict(model, newData)
    })
    
    
    # Build main plot
    output$mainPredPlot <- renderPlot({

        plotTitle <- paste(input$yAxis,"distribution by", input$xAxis)
        
        ggplot(data = iris) + 
            geom_point(mapping = aes(x = xAxis(), y = yAxis(), color = Species)) + 
            xlab(input$xAxis) + 
            ylab(input$yAxis) +  
            ggtitle(plotTitle) + geom_point(aes(color = modelPred(), x = input$xAxisPred, y = input$yAxisPred), size = 5)

    })
    
    # Box plot with both features' distributions
    output$boxPlot <- renderPlot({
        
        plotTitle <- paste(input$yAxis,"distribution by Flower species")
        
        ggplot(data = iris, aes(Species, yAxis())) + 
            geom_boxplot(varwidth=T, fill="#D55E00") + 
            labs(title= plotTitle, 
                 x="Species",
                 y=input$yAxis)
        
    })
    
    # Display predicted species
    output$Prediction <- renderText({
        as.character(modelPred())
    })
    

})
