source("data_setup.R")
library(dplyr)
library(shiny)
library(ggplot2)
library(DT)

server <- function(input, output) {
  
  filter_crimes <- reactive({
    crime_type <- input$crime_type
    return(crime_type)
  })

  filter_year <- reactive({
    filter_year <- input$year
    return(filter_year)
  })
  
  output$map <- renderPlot({
    data_type <- data %>%
      filter(year == !!filter_year()) %>%
      filter(Event.Clearance.Group == !!filter_crimes()) %>%
      select(District.Sector, Longitude, Latitude)
    freq_table <- as.data.frame(table(data_type[ , "District.Sector"]))
    freq_district <- inner_join(data_type, freq_table, by = c("District.Sector" = "Var1"))
    breakpoints = c(0, 50, 100, 150, 200, 250, 300)
    freq_district <- freq_district %>%
      mutate(Frequency = cut(freq_district$Freq, breaks = breakpoints))
    
    plot <- ggplot(freq_district) +
      geom_point(mapping = aes(x = Latitude, y = Longitude, color = Frequency)) +
      scale_color_brewer(palette = "Blues") +
      
      labs(title = paste(input$crime_type, "Frequency in Different Areas for the year ", input$year))
    return(plot)
  })
  
  output$info <- renderText({
    data_type <- data %>%
      filter(year == !!filter_year()) %>%
      filter(Event.Clearance.Group == !!filter_crimes()) %>%
      select(District.Sector, Longitude, Latitude)
    
    spot <- function(input) {
      
      if (input == data_type$Latitude) {
        click_data <- data_type %>%
          filter(input == Latitude) %>%
          select(District.Sector)
          View(data_type1)
         string <- paste(click_data$District.Sector[[1]])
        return(string)
      }
    }
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y, spot(input$plot_click$x))
  })
  
  output$plot_description <- renderText({
    map_description <- paste0("This map shows the frequency of certain crimes compared in
                              different districts. As the gradient darkens, the frequency
                              of crimes are increased.")
    return(map_description)
  })
}
click_data <- data_type1 %>%
  filter(Latitude == 47.49843) %>%
  select(District.Sector)
string <- paste(click_data$District.Sector[[1]])
shinyServer(server)