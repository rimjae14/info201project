library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(tidyr)
library(plotly)
library(DT)
library(leaflet)
library(shinythemes)


######## DATA CLEANING: results in dataset on GitHub

#data <- read.csv(
#  file = "data/Seattle_Police_Department_911_Incident_Response.csv",
#  stringsAsFactors = FALSE
#)

#cleaned <- data %>%
#  select(Event.Clearance.Group, Event.Clearance.Date, Zone.Beat, Hundred.Block.Location,
#         District.Sector, Longitude, Latitude)

#cleaned <- cleaned %>% 
#  mutate(
#    date = substring(data$Event.Clearance.Date, 1, 10),
#    year = substring(data$Event.Clearance.Date, 7, 10),
#    time = substring(data$Event.Clearance.Date, 12, 22)
#  )

# set up time as numerical value (hour.minute)
#hour_24 <- function(time) {
#  if (substring(time, 10, 11) == "PM") {
#    hour <- as.numeric(substring(time, 1, 2)) + 12
#  } else {
#    hour <- substring(time, 1, 2)
#  }
#  as.numeric(paste0(hour, ".", substring(time, 4, 5)))
#}
#cleaned$time <- sapply(cleaned$time, hour_24)

#clean <- cleaned %>%
#  filter(year == "2014" | year == "2015" | year == "2016" | year == "2017"| year == "2018")

#random <- round(runif(200000, min = 0, max = nrow(clean)))

#cleaning <- clean[-random,]

#write.csv(cleaning, file = "data/last5_seattle_police_data.csv", na = "", row.names = FALSE)

##### END OF DATA CLEANING



data <- read.csv("data/last5_seattle_police_data.csv", stringsAsFactors = FALSE)

# set up sector data: exclude sector H
data <- data %>% 
  filter(District.Sector %in% c(
    "N", "L", "J", "B", "U", "O", "R","S", "K",
    "M", "D", "Q", "C", "E", "G", "F", "W")
  )


# QUESTION 1
major_crimes <- c(
  "ASSAULTS",
  "BURGLARY",
  "HOMICIDE",
  "NARCOTICS COMPLAINTS",
  "PROSTITUTION",
  "PROPERTY DAMAGE",
  "ROBBERY"
)
unique_districts <- unique(data$District.Sector)
major_crime_data <- data %>% filter(Event.Clearance.Group %in% major_crimes)
min_year <- min(as.numeric(data$year), na.rm = TRUE)
max_year <- max(as.numeric(data$year), na.rm = TRUE)



# QUESTION 4
accident_data <- data %>%
  filter(Event.Clearance.Group == "MOTOR VEHICLE COLLISION INVESTIGATION")

# WIDGETS
# districts
districts <- data %>% 
  distinct(District.Sector)
districts <- districts$District.Sector


