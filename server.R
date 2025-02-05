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
    if (!is.null(input$q1district)) {
      filtered <- filtered %>% filter(District.Sector %in% input$q1district)
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
      selectizeInput("q1district", label = "Select District", choices = unique_districts, options = list(maxItems = 5))
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
  
  question2graph1 <- reactive({
    numhour <- as.numeric(input$q2hour)
    filtered_data <- sector_data %>%
      filter(round(time) == numhour)
    
    return(filtered_data)
  })
  
  #Prints a table of different precincts and their auto incidents according to input hour
  output$q2table <- renderTable({
    numhour <- as.numeric(input$q2hour)
    tableq2 <- question2graph1() %>%
      group_by(sea_precinct) %>%
      summarize(count = n())
    
    return(tableq2)
  })
  
  output$hourgraph <- renderPlot({
    filterdata <- sector_data %>%
      filter(sea_precinct == input$q2district) %>%
      group_by(round(time)) %>%
      mutate(count = n())
    
    q <- ggplot(data = filterdata) +
      geom_point(mapping = aes(x = round(time), y = count), color = "blue") +
      geom_smooth(mapping = aes(x = round(time), y = count)) + 
      labs(title = paste(input$q2district, "Precinct and number of reports by hour"),
           x = "Hour", y = "Count of incidents")
    
    return(q)
  })
  
  #Makes the bar graph of different precincts and their auto according to input hour
  output$question2graph <- renderPlot({
    p <- ggplot(data = question2graph1()) +
      geom_bar(mapping = aes(x = sea_precinct, fill = sea_precinct)) +
      labs(title = "Precincts reporting auto incidents by hour",
        x = "Precincts", y = "Count") +
      scale_fill_manual("legend", values = c("east" = "blue", "north" = "purple",
                                             "west" = "green", "south" = "red",
                                             "southwest" = "yellow"))
    
    return(p)
  })
  
  #################### Question 3 ####################
  ####################################################
  #Takes the user's inputs and filters the appropriate data for it
  data_filter <- reactive({
    data_type <- data %>%
      filter(year == input$year) %>%
      filter(Event.Clearance.Group == input$crime_type) %>%
      select(District.Sector, Longitude, Latitude)
    return(data_type)
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
    return(freq_district)
  })
  
  #creates the scatterplot map with the given inputs
  output$map <- renderPlot({
    plot <- ggplot(freq_district()) +
      geom_point(mapping = aes(x = Longitude, y = Latitude, color = Frequency)) +
      scale_color_brewer(palette = "Blues") +
      
      labs(title = paste(input$crime_type, " Crime Frequency in Different Districts of Seattle For The Year ", input$year))
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
  
  #creates an interactive map with a geographic map of the city
  output$interactive_map <- renderLeaflet({
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
  
  #selects most dangerous districts with the user inputs
  output$most_dangerous <- renderTable({
    most_dangerous <- freq_filter() %>%
      arrange(desc(Freq)) %>%
      select(District, Freq)
    head(most_dangerous, 5)
  })
  
  #selects most safest districts with the user inputs
  output$most_safe <- renderTable({
    most_safe <- freq_filter() %>%
      arrange(Freq) %>%
      select(District, Freq)
    head(most_safe, 5)
  })
  
  #Data analysis of selected data
  output$selected_analysis <- renderText({
    paste0("The total amount of ", input$crime_type, " crimes that have occured in ", input$year, " is ",
           sum(freq_filter()[,'Freq']), ". The mean frequency of crimes of all the districts is ", round(mean(freq_filter()[,'Freq'])),
           ", with the median of ", round(median(freq_filter()[,'Freq'])), " for the given selections. The outliers are also
           displayed in the two tables above, indicating the most dangerous and safest districts in Seattle 
           for a given crime and year. With this data, those who are planning to move to seattle can compare the districts 
           with their frequency count to the average frequency of that certain year.")
  })
  
  #overall analysis of the data
  output$overall_analysis <- renderText({
    paste0("Crime rate in Seattle over the ", nrow(crime_rate_data), " years is ", crime_rate, " per year. 
           We can predict that the crime rate will continue to increase at this rate over 
           the upcoming years. However, crimes that happened in the year 2014 are insufficient compared to the later years.
           This is because the data does not provide many reports during this year, thus, may affect the accuracy of the
           crime rates stated above. The district with the most crimes overall is ", max_district[1], " with a total of ", max_crime, 
           " crimes. The district with the least crimes overall is ", min_district[1], " with a total of ", min_crime, " crimes.
           This may indicate the type of area that makes up the district. For example, districts with lower crime rates may be
           of suburban areas or gated communities, and districts with higher crime rates may compose of more public and open areas. 
           By comparing the total crimes that occurred in these districts, the user can infer whether or not 
           the change in data will be drastic or slow given the overall crime rate. As a result, future settlers in Seattle can use this data
           to predict changes in crimes over the next years, and the change in frequency of crimes corresponding to certain districts.")
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
  
  acc_plot_one_min <- reactive({
    min_val <- filtered_acc_plot_one() %>% 
      filter(n == min(filtered_acc_plot_one()$n))
    min_val$vars
  })
  
  acc_plot_one_max <- reactive({
    max_val <- filtered_acc_plot_one() %>% 
      filter(n == max(filtered_acc_plot_one()$n))
    max_val$vars
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
    
  
  
  output$graph_descriptions <- renderText({
    paste0(
      "This analysis is done given the range of time between ", floor(input$time[1]),
      " and ", floor(input$time[2]), " hours of the day, and the following district(s): ",
      paste(input$district, collapse = ", "), "."
    )
  })
  
  output$acc_time_analysis <- renderText({
    paste0(
      "According to the graph, the most dangerous time of day to drive for the given
      district(s) is hour ", acc_plot_one_min(), " and the least dangerous 
      time of day to drive is hour ", acc_plot_one_max(), ". Using this
      information, it is best to avoid driving in the given district(s) within hour ",
      acc_plot_one_max(), "!"
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