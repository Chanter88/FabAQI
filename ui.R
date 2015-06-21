library(shiny)

# generate the color coded box plot
drawPlot <- function(df) {
        ggplot(df, aes(x = Parameter, y = AQI, fill = HealthConcern)) + 
                xlab("") + 
                ylab("AQI") +
                ggtitle("Predicted Pollutant Values") +
                geom_bar(stat = "identity") + 
                scale_fill_manual(values = c("Good" = "green", 
                                             "Moderate" = "yellow",
                                             "Unhealthy for Sensitive Groups" = "orange",
                                             "Unhealthy" = "red",
                                             "Very Unhealthy" = "purple",
                                             "Hazardous" = "maroon",
                                             "Unknown" = "blue")) +
                coord_flip()
}

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
        p("Data source: http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html#Daily"),
        sidebarLayout(
                sidebarPanel(
                        dateInput("target_date", "Target Date:", min = Sys.Date()),
                        uiOutput("choose_state"),
                        uiOutput("choose_city"),
                        actionButton("goButton", "Predict AQI"),
                        hr(),
                        tableOutput('legend'),
                        tags$head(tags$style("#legend table {background-color: #F0FAFF; }", media="screen", type="text/css"))
                ),
                
                mainPanel(
                        plotOutput("aqiplot"),
                        tableOutput("aqidata"),
                        tags$head(tags$style("#aqidata table { margin: auto; }", media="screen", type="text/css"))
                )
        )
))
