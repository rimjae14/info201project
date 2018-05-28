library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(tidyr)

# set up data
data <- read.csv("data/cleaned_seattle_police_data.csv", stringsAsFactors = FALSE)

data <- data %>% 
  mutate(
    date = substring(data$Event.Clearance.Date, 1, 10),
    year = substring(data$Event.Clearance.Date, 7, 10),
    time = substring(data$Event.Clearance.Date, 12, 22)
  )

# set up time as numerical value (hour.minute)
suppressWarnings(
  if (substring(data$time, 10, 11) == "PM") {
    hour <- as.numeric(substring(data$time, 1, 2)) + 12
  } else {
    hour <- substring(data$time, 1, 2)
  }
)
suppressWarnings(data$time <- as.numeric(paste0(hour, ".", substring(data$time, 4, 5))))

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


