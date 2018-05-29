source("data_setup.R")
library(dplyr)
library(shiny)
library(ggplot2)
library(DT)
library(leaflet)

server <- function(input, output) {
  
  data_filter <- reactive({
    data_type <- data %>%
      filter(year == input$year) %>%
      filter(Event.Clearance.Group == input$crime_type) %>%
      select(District.Sector, Longitude, Latitude)
  })
  
  freq_filter <- reactive({
    freq_table <- as.data.frame(table(data_filter()[ , "District.Sector"]))
  })
  
  district_filter <- reactive({
    district_join <- inner_join(data_filter(), freq_filter(), by = c("District.Sector" = "Var1"))
  })
  
  freq_district <- reactive({
    breakpoints = c(0, 50, 100, 150, 200, 250, 300)
    freq_district <- district_filter() %>%
      mutate(Frequency = cut(district_filter()$Freq, breaks = breakpoints)) %>%
      filter(Freq != 'NA')
  })
  
  
  output$map <- renderPlot({
    plot <- ggplot(freq_district()) +
      geom_point(mapping = aes(x = Longitude, y = Latitude, color = Frequency)) +
      scale_color_brewer(palette = "Blues") +
      
      labs(title = paste(input$crime_type, "Frequency in Different Areas for the year ", input$year))
    return(plot)
  })
  
  output$info <- renderPrint({
    clicked <- nearPoints(freq_district(), input$plot_click)
    paste("District:", clicked$District.Sector[1], "Frequency:", clicked$Freq[1])
  })

  
  output$plot_description <- renderText({
    map_description <- paste0("This map shows the frequency of certain crimes compared in
                              different districts. As the gradient darkens, the frequency
                              of crimes are increased.")
    return(map_description)
  })
  
  output$interactive_map <- renderLeaflet({
    map_interactive <- leaflet() %>%
      addTiles() %>%
      addMarkers(lng = data_filter()$Longitude, lat = data_filter()$Latitude)
    return(map_interactive) 
  })
}
shinyServer(server)