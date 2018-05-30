library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

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



