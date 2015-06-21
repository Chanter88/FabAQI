library(RSQLite)

# getCities generates a unique list of the cities for a given state contained
# within the the fabaqi.db database  
getCities <- function(state) {
        # load the city data from the database
        con <- dbConnect(dbDriver("SQLite"), "fabaqi.db")
        sql <- "
        SELECT DISTINCT 
        City 
        FROM 
        observations 
        WHERE 
        State = ?
        ORDER BY
        City"
        bind.vars <- data.frame(state)
        df <- dbGetPreparedQuery(con, sql, bind.vars)
        dbDisconnect(con)
        
        # if only one row is returned, convert the data set to an array
        if(NROW(df) == 1)
                df <- array(df)
        
        list("City" = df)
}

# getData is the main interface for the fabaqi.db database.  It determines the expected AQI
# value on a target date for a given state and city by calculating the average AQI value for that
# date in 2013 and 2014.
getData <- function(state, city, target_date) {
        # load the data from the database
        con <- dbConnect(dbDriver("SQLite"), "fabaqi.db")
        sql <- "
        SELECT
        Parameter,
        AVG(AQI) AS AQI
        FROM
        observations
        WHERE
        State = ?
        AND
        City = ?
        AND
        strftime('%m-%d', Date) = ?
        GROUP BY
        strftime('%m-%d', Date),
        Parameter"
        
        bind.vars <- data.frame(state, city, target_date)
        df <- dbGetPreparedQuery(con, sql, bind.vars)
        dbDisconnect(con)
        
        # calculate the EPA  health rating to each AQI value
        df$HealthConcern <- assessAQI(df$AQI)
        
        # verify that all the parameters are contained within the data set
        params <- c('Carbon monoxide', 'Sulfur dioxide', 'Nitrogen dioxide (NO2)', 'Ozone')
        diff.param <- setdiff(params, df$Parameter)
        
        # if any parameters are missing, add filler values so the ggplot and data table
        # will contain the right number of rows
        if(NROW(diff.param) > 0) {
                df <- rbind(df, data.frame(Parameter = diff.param, 
                                           AQI = -1,
                                           HealthConcern = "Unknown")) 
        }
        
        # convert the Parameter variable to a factor
        df$Parameter <- as.factor(df$Parameter)
        
        df
}

# analyze the AQI value and assign the EPA health rating
assessAQI <- function(AQI) {
        aqiRange <- c(-1, 0, 50, 100, 150, 200, 300, 500)
        aqiLevel <- c('Good', 'Moderate', 'Unhealthy for Sensitive Groups', 'Unhealthy', 
                      'Very Unhealthy', 'Hazardous') 
        aqiLevel[findInterval(AQI, aqiRange)]
}

# determine the health conditions that are affected by the pollutant type
getRisks <- function() {
        data.frame(
                Pollutant = c('Carbon monoxide', 'Sulfur dioxide', 'Nitrogen dioxide (NO2)',
                              'Ozone'),
                Risk_Group = c('Heart Disease', 'Asthma', 'Asthma/Respiratory Diseases', 
                               'Asthma')
        )
}