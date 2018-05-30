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
    colnames(freq_table) <- c("District", "Freq")
    return(freq_table)
  })
  
  district_filter <- reactive({
    district_join <- inner_join(data_filter(), freq_filter(), by = c("District.Sector" = "District"))
    return(district_join)
  })
  
  freq_district <- reactive({
    breakpoints = c(0, 50, 100, 150, 200, 250, 300)
    freq_district <- district_filter() %>%
      mutate(Frequency = cut(district_filter()$Freq, breaks = breakpoints)) %>%
      filter(Frequency != 'NA')
  })
  
  
  output$map <- renderPlot({
    plot <- ggplot(freq_district()) +
      geom_point(mapping = aes(x = Longitude, y = Latitude, color = Frequency)) +
      scale_color_brewer(palette = "Blues") +
      
      labs(title = paste(input$crime_type, "Frequency in Different Areas for the year ", input$year))
    return(plot)
  })
  
  clicked <- reactive({
    clicked <- nearPoints(freq_district(), input$plot_click)
  })
  
  output$district_point <- renderText({
    paste(clicked()$District.Sector[1])
  })
  
  output$frequency_district <- renderText({
    paste(clicked()$Freq[1])
  })

  
  output$plot_description <- renderText({
    map_description <- paste0("This map shows the frequency of certain crimes compared in
                              different districts. As the gradient darkens, the frequency
                              of crimes are increased. Using this data, determining the safest
                              areas around Seattle can be inferred by the frequency of crimes in 
                              the districts. Users are able to click on the points 
                              to view the frequency count of crime in different districts.")
    return(map_description)
  })
  
  output$interactive_map <- renderLeaflet({
    districts <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))
    map_interactive <- leaflet() %>%
      addTiles() %>%
      addCircleMarkers(fillOpacity = 0.5,
        lng = data_filter()$Longitude, lat = data_filter()$Latitude, popup = data_filter()$District.Sector)
    return(map_interactive) 
  })
  
  output$plot_interactive <- renderText({
    interactive_description <- paste0("This map also shows the frequency of certain crimes compared in
                              different districts. However, this map provides a different visualization
                              by providing a map of the city. Each point on the map represents a data point,
                              and the density of points in certain locations of the map provides users with
                              a visual of the crime counts. Users are able to click on the points 
                              to view the different districts.")
    return(interactive_description)
  })
  
  output$most_dangerous <- renderTable({
    most_dangerous <- freq_filter() %>%
      arrange(desc(Freq)) %>%
      select(District, Freq)
    head(most_dangerous, 5)
  })
  
  output$most_safe <- renderTable({
    most_safe <- freq_filter() %>%
      arrange(Freq) %>%
      select(District, Freq)
    head(most_safe, 5)
  })
}
shinyServer(server)