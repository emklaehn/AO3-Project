#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# 

# Used code from: https://github.com/amitvkulkarni/Interactive-Modelling-with-Shiny

library(shiny)
library(stargazer)
library(shinydashboard)
library(maps)
library(dplyr)
library(leaflet)
library(ggplot2)
library(tidyverse)
library(DT)
library(plotly)
library(corrplot)
library(caret)

ao3_new <- read.csv("ao3_new.csv")

# Define UI for application 
ui <- dashboardPage(
    dashboardBody(
    fluidPage(
        box(
            selectInput(
                "SelectX",
                label = "Select variables:",
                choices = names(ao3_new),
                multiple = TRUE,
                selected = names(ao3_new)
            ),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "X variable"
        ),
        box(
            selectInput("SelectY", label = "Select variable to predict:", choices = names(mtcars)),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Y variable"
        )
        
        
        
    )), fluidPage(

    # Application title
    titlePanel("Positive Fan Interaction Model"),

    tabBox(
        id = "tabset1",
        height = "1000px",
        width = 12,
        tabPanel("Data",
                 box(withSpinner(DTOutput(
                     "Data"
                 )), width = 12)),
        tabPanel(
            "Data Summary",
            box(withSpinner(verbatimTextOutput("Summ")), width = 6),
            box(withSpinner(verbatimTextOutput("Summ_old")), width = 6)
        ),
        tabPanel(
            "Model",
            box(
                withSpinner(verbatimTextOutput("Model")),
                width = 6,
                title = "Model Summary"
            )
        )
)))

# Define server logic 
server <- function(input, output) {
    # Dataset
    ao3_data <- reactive({
        ao3
    })
    
    model <- reactive({
        if (is.null(input$SelectX)) {
            dt <- ao3_new
        }
        else{
            dt <- ao3_new[, c(input$SelectX)]
        }
    })
    # Data output
    output$Data <- renderDT(ao3_data())
    
    # split data
    set.seed(24)  
    trainingRowIndex <-
        reactive({
            sample(1:nrow(model()),
                   0.80 * nrow(model()))
        })
    
    trainingData <- reactive({
        tmptraindt <- model()
        tmptraindt[trainingRowIndex(), ]
    })
    
    testData <- reactive({
        tmptestdt <- model()
        tmptestdt[-trainingRowIndex(),]
    })
    
    # summary
    output$Summ <-
        renderPrint(
            stargazer(
                ao3_data(),
                type = "text",
                title = "Descriptive statistics",
                digits = 1,
                out = "table1.txt"
            )
        )
    output$Summ_old <- renderPrint(summary(ao3_data()))
    output$structure <- renderPrint(str(ao3_data()))
    # model
    f <- reactive({
        as.formula(paste(input$SelectY, "~."))
    })
    
    
    Linear_Model <- reactive({
        lm(f(), data = trainingData())
    })
    
    output$Model <- renderPrint(summary(Linear_Model()))
    output$Model_new <-
        renderPrint(
            stargazer(
                Linear_Model(),
                type = "text",
                title = "Model Results",
                digits = 1,
                out = "table1.txt"
            )
        )
}

# Run the application 
shinyApp(ui = ui, server = server)
