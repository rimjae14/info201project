source("data_setup.R")

my_ui <- fluidPage(
  titlePanel("title of project"),
  p(em("our names")),
  navbarPage(
    "Introduction of Project",
    p(em("introduction paragraph")),
    p(paste(
      "The data used in this report is from the Seattle Police Department",
      "Incidence 912 Response data set. The data set can be found" 
    )),
    a(
      "here.",
      href = 'https://data.seattle.gov/Public-Safety/Seattle-Police-Department-911-Incident-Response/3k2p-39jp'
    ),
    tabPanel("Part 1"),
    tabPanel("Part 2",
      sidebarLayout(
        sidebarPanel(
          sliderInput("q2hour", "Hour", min = 1, max = 24, value = 1)
        ),
        mainPanel(
          #plot
        )
      )
    ),
    tabPanel("Part 3"),
    tabPanel("Part 4",
      sidebarLayout(
        sidebarPanel(
          sliderInput(
            'time', label = "Time (hour.minute)",
             min = 0, max = 24.59, value = c(0, 24.59)
          ),
          checkboxGroupInput(
            'district', label = "District",
            choices = districts, selected = "N"
          )
        ),
        mainPanel(
          h1("Seattle Traffic Accidents"),
          
          h3("Number of Traffic Accidents per Hour of Day"),
          h4("What time of day is it most dangerous to drive in Seattle?"),
          p(em("Click on a data point for its coordinates.")),
          plotOutput('acc_graph_one', click = "plot_click_time"),
          p(strong("Time: "), textOutput('select_time_one', inline = TRUE)),
          p(strong("Number of Accidents: "), textOutput('freq', inline = TRUE)),
          textOutput('acc_time_description'),
           
          h3("Seattle District Mapping of Accidents"),
          h4("Where is it most dangerous to drive in Seattle?"),
          p(em("Click on a data point for more information.")),
          plotOutput('acc_graph_two', click = "plot_click_map"),
          p(strong("District: "), textOutput('select_dist', inline = TRUE)),
          p(strong("Number of Accidents: "), textOutput('num_selected', inline = TRUE)),
          p(strong("Hundred Block Location: "), textOutput('location', inline = TRUE)),
          p(strong("Time(s): "), textOutput('select_time_two', inline = TRUE)),
          
          
          h3("Reference: Districts of Seattle"),
          img(
            src = 'https://www.seattle.gov/Documents/Departments/police/Precincts/maps/Southwest_Precinct.pdf',
            width = "250", height = "285", inline = TRUE
          ),
          img(
            src = 'https://www.seattle.gov/Documents/Departments/police/Precincts/maps/WestPrecinct.pdf',
            width = "252", height = "285", inline = TRUE
          ),
          img(
            src = 'https://www.seattle.gov/Documents/Departments/police/Precincts/maps/North_Precinct.pdf',
            width = "252", height = "285", inline = TRUE
          ),
          img(
            src = 'https://www.seattle.gov/Documents/Departments/police/Precincts/maps/East_Precinct.pdf',
            width = "252", height = "285", inline = TRUE
          ),
          img(
            src = 'https://www.seattle.gov/Documents/Departments/police/Precincts/maps/South_Precinct.pdf',
            width = "252", height = "285", inline = TRUE
          )
        )
      )
    )
  )
)

shinyUI(my_ui)