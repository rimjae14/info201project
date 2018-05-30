library(shiny)
library(dplyr)

# Question 2 set up
source("question2_data.R")

# Question 1 and 4 set up
source("data_setup.R")


my_server <- function(input, output) {

  
  #################### Question 1 ####################
  ####################################################
  filtered_major_crime_data <- reactive({
    if (length(input$year) == 1) {
      filtered <- major_crime_data %>%
        filter(year == input$year[1])
    }else{
      filtered <- major_crime_data %>%
        filter(year >= input$year[1] &
                 year <= input$year[2])
    }
    if (!is.null(input$district)) {
      filtered <- filtered %>% filter(District.Sector %in% input$district)
    }
    filtered
  })
  
  hourly_data <- reactive({
    filtered_major_crime_data() %>%
      mutate(hr = floor(time)) %>%
      group_by(hr, Event.Clearance.Group) %>%
      summarize(
        count = n()
      )
  })
  
  output$controls <- renderUI({
    tagList(
      sliderInput("year", "Year Range", value = c(min_year + 1, max_year - 1), min = min_year, max = max_year),
      selectizeInput("district", label = "Select District", choices = unique_districts, options = list(maxItems = 5))
    )
  })
  
  output$monthly <- renderPlot(
    ggplot(data = filtered_major_crime_data(), aes(month)) +
      geom_bar(aes(fill = District.Sector)) +
      labs(title = "Crime frequency vs Month", x = "Month of Year", y = "Crime Count")
  )
  
  output$hourly <- renderPlotly({
    ggplot(hourly_data(),aes(hr, count, color = Event.Clearance.Group)) +
      geom_line(size = 2) +
      geom_point() +
      labs(title = "Crime frequency vs Hour", x = "Hours after 12AM", y = "Crime Count")
  })
  
  
  #################### Question 2 ####################
  ####################################################
  question2 <- reactive({
    numhour <- as.numeric(input$q2hour)
    filtered_data <- sector_data %>%
      filter(round(time) == numhour)
    
    return(filtered_data)
  })
  
  output$question2graph <- renderPlot({
    p <- ggplot(data = question2()) +
      geom_bar(mapping = aes(x = sea_precinct, color = sea_precinct)) +
      labs(title = "Auto Related Crimes in Seattle by Hour",
           x = "Precincts",
           y = "Count")
    
    return(p)
  })
  
  #################### Question 3 ####################
  ####################################################
  
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
  
  #################### Question 4 ####################
  ####################################################
  
  filtered_acc_plot <- reactive({
    accident_graph_data <- accident_data %>% 
      filter(input$time[1] < time, input$time[2] > time) %>% 
      filter(input$district ==  District.Sector) %>% 
      mutate(time.round = floor(time))
  })
  
  filtered_acc_plot_one <- reactive({
    count(filtered_acc_plot(), vars = time.round)
  })
  
  q4data <- reactiveValues()
  
  # click interaction: graph one
  q4data$selected_time_one <- ""
  q4data$selected_freq <- ""
  q4data$selected_time <- ""
  
  # click interaction: graph two
  q4data$selected_location <- ""
  q4data$selected_time_two <- NULL
  q4data$selected_dist <- ""
  
  # GRAPH ONE
  output$acc_graph_one <- renderPlot({
    if (!is.null(input$district)) {  
      ggplot(data = filtered_acc_plot_one()) +
        geom_point(mapping = aes(
          x = vars, y = n,
          color = (vars == q4data$selected_time)
        ), size = 3) +
        guides(color = FALSE) +
        labs(
          y = "Count of traffic accidents",
          x = "Time (hour)"
        ) 
    }
  })
  
  # click interaction: graph one
  output$select_time_one <- renderText({
    q4data$selected_time_one
  })
  
  output$freq <- renderText({
    q4data$selected_freq
  })
    
  output$acc_time_description <- renderText({
    paste(
      "This analysis is done given the range of time between ", input$time[1],
      "and", input$time[2], "times of day (hour.minute), and the following district(s):",
      paste(input$district, collapse = ", "), "."
    )
  })
  
  observeEvent(input$plot_click_time, {
    selected <- nearPoints(filtered_acc_plot_one(), input$plot_click_time)
    q4data$selected_time_one <- paste0(selected$vars, ":00")
    q4data$selected_time <- selected$vars
    q4data$selected_freq <- selected$n
  })
  
  
  # GRAPH TWO
  output$acc_graph_two <- renderPlot({
    if (!is.null(input$district)) {
      ggplot(data = filtered_acc_plot()) +
        geom_point(mapping = aes(
          x = Longitude, y = Latitude,
          color = (Hundred.Block.Location == q4data$selected_location)
        ), size = 1.5) +
        guides(color = FALSE) +
        coord_equal()
    }
  })
  
  #click interaction: graph two
  output$location <- renderText({
    paste(unique(tolower(q4data$selected_location)), collapse = ", ")
  })
  
  output$num_selected <- renderText({
    if (!is.null(q4data$selected_time_two)) {
      length(q4data$selected_time_two)
    }
  })
  
  output$select_time_two <- renderText({
    paste(sort(q4data$selected_time_two), collapse = ", ")
  })
  
  output$select_dist <- renderText({
    q4data$selected_dist[1]
  })
  
  observeEvent(input$plot_click_map, {
    selected <- nearPoints(filtered_acc_plot(), input$plot_click_map)
    q4data$selected_location <- selected$Hundred.Block.Location
    q4data$selected_time_two <- selected$time
    q4data$selected_dist <- selected$District.Sector[1]
  })
}

shinyServer(my_server)