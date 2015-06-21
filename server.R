library(shiny)
library(ggplot2)
library(RColorBrewer)
source('model.R')

shinyServer(function(input, output) {
        
        # populate the state drop-down
        output$choose_state <- renderUI({
                selectInput("state", "State:", list("State" = state.name))
        })
        
        # populate the city drop-down based on the value selected in the state drop-down
        output$choose_city <- renderUI({
                if(is.null(input$state))
                        return()
                
                cities <- getCities(input$state)
                selectInput("city", "City:", cities)
        })
        
        # populate the legend table
        output$legend <- renderTable(getRisks(), 
                                     include.rownames = FALSE,
                                     caption.placement = "top",
                                     caption.width = NULL,
                                     caption = "Pollutant Health Risks")
        
        # if the predict button was pressed, calculate the expected AQI values
        data <- eventReactive(input$goButton, {
                target_date <- format(input$target_date, "%m-%d")
                df <- getData(input$state, input$city, target_date)
        })
        
        # generate a bar plot depicting the four AQI values
        output$aqiplot <- renderPlot({
                df <- data()
                drawPlot(df)
        })
        
        # generate a data table summarizing the AQI values
        output$aqidata <- renderTable(data(), include.rownames = FALSE)
})
