library(shiny)
library(ggplot2)
library(dplyr)
library(maps)

# set up data
data <- read.csv("data/cleaned_seattle_police_data.csv", stringsAsFactors = FALSE)

data <- data %>% 
  mutate(
    date = substring(data$Event.Clearance.Date, 1, 10),
    year = substring(data$Event.Clearance.Date, 7, 10),
    time = substring(data$Event.Clearance.Date, 12, 22)
  )

# set up time as numerical value (hour.minute)
if (substring(data$time, 10, 11) == "PM") {
  hour <- as.numeric(substring(data$time, 1, 2)) + 12
} else {
  hour <- substring(data$time, 1, 2)
}
data$time <- as.numeric(paste0(hour, ".", substring(data$time, 4, 5)))

