#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Offer options on which column to show for X, then options for Y
    # Have two sliders for user to input values to predict (using the columns selected)
    # Show Species spread according to selection
    # Show Plot AND Spread per Species
    # Predict which type of flower based on the user's input
    
    # Application title
    titlePanel("Analyzing and predicting flower species (Iris Dataset)"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            radioButtons("xAxis",
                         label = "Choose your X Axis for the Main Plot:",
                         choices = list("Sepal Length" = "Sepal.Length","Sepal Width" = "Sepal.Width","Petal Length" = "Petal.Length","Petal Width" = "Petal.Width"),
                         selected = "Sepal.Length"),
            radioButtons("yAxis",
                         label = "Choose your Y Axis for ALL Plots:",
                         choices = list("Sepal Length" = "Sepal.Length","Sepal Width" = "Sepal.Width","Petal Length" = "Petal.Length","Petal Width" = "Petal.Width"),
                         selected = "Sepal.Width"),
            
            sliderInput("xAxisPred", "X Axis value of flower to predict", 0, 8, value = 4, step = 0.1),
            sliderInput("yAxisPred", "Y Axis value of flower to predict", 0, 8, value = 4, step = 0.1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            p("Choose the two features you would like to use as an X and Y axis."),
            p("Once those features have been chosen, choose the value of those features using the two sliders"),'',
            
            plotOutput("mainPredPlot"),
            plotOutput("boxPlot"),
            h4("Predicted flower type from input data:"),
            textOutput("Prediction")
        )
    )
))
