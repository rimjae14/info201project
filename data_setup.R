library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(tidyr)


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
#if (substring(data$time, 10, 11) == "PM") {
#  hour <- as.numeric(substring(data$time, 1, 2)) + 12
#} else {
#  hour <- substring(data$time, 1, 2)
#}
#cleaned$time <- as.numeric(paste0(hour, ".", substring(data$time, 4, 5)))

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


# QUESTION 4
accident_data <- data %>%
  filter(Event.Clearance.Group == "MOTOR VEHICLE COLLISION INVESTIGATION")

# WIDGETS
# times for accidents
time_range <- range(accident_data$time)

# districts
districts <- data %>% 
  distinct(District.Sector)
districts <- districts$District.Sector


