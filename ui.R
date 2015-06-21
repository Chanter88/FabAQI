library(shiny)

shinyUI(fluidPage(

        # Application title
        titlePanel("FabAQI: An Air Quality Prediction Application"),
        h3("Instructions"),
        p("FabAQI can be used to predict the air quality ratings on a specified date in the future for
        four different air pollutants: Carbon monoxide, Sulfur dioxide, Nitrogen dioxide, and Ozone.
          Pick the date, state, and city for which you would like to predict values in the panel on the 
          left, and click the Predict AQI button. FabAQI will then provide a summary of the predicted AQI values,
          including a health warning for those pollutants which exceed the thresholds defined by the EPA."),
        strong("Note: Data may not be available for all pollutants in all locations. Unknown values will have an AQI value of -1."),
        
        sidebarLayout(
                sidebarPanel(
                        dateInput("target_date", "Target Date:", min = Sys.Date()),
                        uiOutput("choose_state"),
                        uiOutput("choose_city"),
                        actionButton("goButton", "Predict AQI")
                ),
                
                mainPanel(
                        plotOutput("aqiplot"),
                        tableOutput("aqidata")
                )
        )
))
