# This R script creates a SQL Lite Database containing the Daily Summary Data from the EPA website.
library(RSQLite)
sqlite <- dbDriver("SQLite")
fabaqi.db <- dbConnect(sqlite, "fabaqi.db")

# load all the data in the CSV files into the database
file_patterns <- c('daily_42101*', 'daily_42401*', 'daily_42602*', 'daily_44201*')

columns <- c('Date.Local', 'State.Name', 'City.Name', 'Parameter.Name', 'AQI')

for(pattern in file_patterns) {
        files <- list.files('data', pattern, full.names = TRUE)
        
        for(file in files) {
                cat("Processing", file, "...\n")
                
                # load the data into a data frame
                data <- read.csv(file)
                data <- data[, columns]
                
                # rename the columns to something more human readable
                names(data) <- c('Date', 'State', 'City', 'Parameter', 'AQI')
                
                # add the data to the observations table (append if necesssary)
                dbWriteTable(fabaqi.db, 'observations', data, append = TRUE)
        }
}

dbListTables(fabaqi.db)

dbDisconnect(fabaqi.db)