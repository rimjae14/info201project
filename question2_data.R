library(dplyr)
library(ggplot2)

crime_data <- read.csv(file = "data/last5_seattle_police_data.csv", stringsAsFactors = FALSE)

## car prowl & auto thefts 
## x - districts
north <- c("N", "L", "U", "J", "B")
west <- c("Q", "D", "M", "K", "H")
east <- c("C", "E", "G")
southwest <- c("W", "F")
south <- c("R", "O", "S")

## y = frequency 

car_crimes <- crime_data %>%
  filter(Event.Clearance.Group == "CAR PROWL" | Event.Clearance.Group == "AUTO THEFTS") 

north_crimes <- car_crimes %>%
  filter(District.Sector %in% north) %>%
  mutate(sea_precinct = "north") %>%
  select(Event.Clearance.Group, District.Sector, sea_precinct, time)

west_crimes <- car_crimes %>%
  filter(District.Sector %in% west) %>%
  mutate(sea_precinct = "west") %>%
  select(Event.Clearance.Group, District.Sector, sea_precinct, time)

east_crimes <- car_crimes %>%
  filter(District.Sector %in% east) %>%
  mutate(sea_precinct = "east") %>%
  select(Event.Clearance.Group, District.Sector, sea_precinct, time)

southwest_crimes <- car_crimes %>%
  filter(District.Sector %in% southwest) %>%
  mutate(sea_precinct = "southwest") %>%
  select(Event.Clearance.Group, District.Sector, sea_precinct, time)

south_crimes <- car_crimes %>%
  filter(District.Sector %in% south) %>%
  mutate(sea_precinct = "south") %>%
  select(Event.Clearance.Group, District.Sector, sea_precinct, time)

sector_data <- rbind(north_crimes, south_crimes, east_crimes, west_crimes, southwest_crimes)
  
