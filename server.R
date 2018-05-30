library(shiny)
source("question2_data.R")

my_server <- function(input, output) {
  ##Question 1
  
  
  
  ##Question 2
  question2 <- reactive({
    numhour <- as.numeric(input$q2hour)
    filtered_data <- sector_data %>%
      filter(round(time) == numhour)
    
    return(filtered_data)
  })
  
  output$hours <- renderTable(
    return(question2())
    
  )
  output$question2graph <- renderPlot({
    p <- ggplot(data = question2()) +
      geom_bar(mapping = aes(x = sea_precinct))
    
    return(p)
  })
  
  ##Question 3
  
  
  ##Question 4
}

shinyServer(my_server)