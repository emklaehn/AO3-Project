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
library(caret)
library(shinycssloaders)

ao3_new <- read.csv("ao3_new.csv")
# change date into Date type
ao3_new$Date_updated <- as.Date(ao3_new$Date_updated, format="%d %B %Y")
# change categorical variables like Rating and Complete into factors
ao3_new$Complete <- as.factor(ao3_new$Complete)
ao3_new$Rating <- as.factor(ao3_new$Rating)
ao3_new$Pairing <- as.factor(ao3_new$Pairing)
ao3_new$Warning <- as.factor(ao3_new$Warning)
choice = c("Rating", "Pairing","Complete","Word_count","Num_chapters", "Num_comments",
           "Num_kudos","Num_bookmarks","Num_hits","Is_crossover","Has_romance",
           "Has_platonic","Num_romance","Num_platonic","Num_character","Fluff",
           "Angst","Hurt_comfort","AU","Fluff_angst","Five_tags","hits2","comments2")
descript <- "This R shiny app will let you create a regression using the different variables given."

# Define UI for application 
ui <- dashboardPage(
  dashboardHeader(title = "AO3 Regression"), dashboardSidebar(descript),
        dashboardBody(
        fluidPage(
        box(
            selectInput(
                "SelectX",
                label = "Select variables:",
                choices = choice,
                multiple = TRUE,
                selected = NULL
            ),
            solidHeader = TRUE,
            width = "10",
            status = "primary",
            title = "X variable"
        ),
        box(
            selectInput("SelectY", label = "Select variable to predict:", choices = choice),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Y variable"
        )
        
        
        
    ), fluidPage(

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
))))

# Define server logic 
server <- function(input, output) {
    # Dataset
    ao3_data <- reactive({
        ao3_new
    })
    
    model <- reactive({
        if (is.null(input$SelectX)) {
            dt <- ao3_new
        }
        else{
            dt <- ao3_new[, c(input$SelectX,input$SelectY)]
        }
    })
    # Data output
    output$Data <- renderDT(ao3_data(),options = list(scrollX = TRUE))
    
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
