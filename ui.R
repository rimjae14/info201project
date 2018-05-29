source("data_setup.R")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        'time', label = "Time (hour.minute)",
        min = time_range[1], max = time_range[2], value = time_range
      ),
      checkboxGroupInput(
        'district', label = "District",
        choices = districts, selected = "S"
      )
    ),
    mainPanel(
      h3("Number of Traffic Accidents per Hour of Day"),
      plotOutput('acc_graph_one', click = "plot_click_time"),
      p(strong("Time: "), textOutput('select_time_one', inline = TRUE)),
      p(strong("Number of Accidents: "), textOutput('freq', inline = TRUE)),
      
      h3("Seattle District Mapping of Accidents"),
      plotOutput('acc_graph_two', click = "plot_click_map"),
      p(strong("District: "), textOutput('select_dist', inline = TRUE)),
      p(strong("Number of Accidents: "), textOutput('num_selected', inline = TRUE)),
      p(strong("Hundred Block Location: "), textOutput('location', inline = TRUE)),
      p(strong("Time(s): "), textOutput('select_time_two', inline = TRUE))
    )
  )
)

shinyUI(ui)