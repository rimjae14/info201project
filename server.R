source("data_setup.R")
library(plotly)
# crime hourly line graph

major_crimes <- c(
  "ASSAULTS",
  "BURGLARY",
  "HOMICIDE",
  "NARCOTICS COMPLAINTS",
  "PROSTITUTION",
  "PROPERTY DAMAGE",
  "ROBBERY"
)
unique_districts <- unique(data$District.Sector)
major_crime_data <- data %>% filter(Event.Clearance.Group %in% major_crimes)
min_year <- min(as.numeric(data$year), na.rm = TRUE)
max_year <- max(as.numeric(data$year), na.rm = TRUE)

server <- function(input, output) {
  filtered_major_crime_data <- reactive({
    if(length(input$year) == 1){
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
  
}
shinyServer(server)
