# FabAQI

FabAQI is a Shiny application that can be used to predict the air quality values for a given day based on the values from the previous two years' values for the date.  The application uses the daily summary values for the Air Quality Index (AQI) for 2013 and 2014 from the [EPA Air Quality](http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html#Daily) website for
four pollutants:  
* Carbon monoxide
* Sulfur dioxide
* Nitrogen dioxide
* Ozone

## Files ##  
* fabaqi.db:  A SQLite database containing the daily AQI values for various locations from 2013 and 2014.
* fabaqi_db.R:  Script to build the fabaqi.db file.
* server.R:  The Shiny server functions.
* ui.R:  The Shiny UI functions.

## Data Files ##  
Due to file storage constraints in GitHub, the data files are not contained within this repository.  They can be downloaded from the following [link](http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html#Daily).