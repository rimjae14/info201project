source("data_setup.R")


my_ui <- fluidPage(
  theme = shinytheme("yeti"),
  titlePanel("title of project"),
  p(em("our names")),
  navbarPage(
    "Introduction of Project",
    p(em("introduction paragraph")),
    p(paste(
      "The data used in this report is from the Seattle Police Department",
      "Incidence 911 Response data set. The data set can be found"
    ), a(
      "here.",
      href = "https://data.seattle.gov/Public-Safety/Seattle-Police-Department-911-Incident-Response/3k2p-39jp"
    )),
    tabPanel(
      "Part 1",
      sidebarLayout(
        sidebarPanel(
          # district selection widget and year slider
          h3("Controls"),
          uiOutput("controls"),
          p(strong("Note:"), "If the district input is empty, both charts will be plotting data from all seattle districts"),
          br(),
          h4("Suggested District Combinations"),
          tags$ul(
            tags$li("South West Precinct: W, F"),
            tags$li("East Precinct: C, G, E"),
            tags$li("South Precinct: O, R, S"),
            tags$li("West Precinct: D, K, M, Q"),
            tags$li("North Precinct: B, L, J, N, U"),
            tags$li("Udistrict: U")
          )
        ),
        mainPanel(
          h1("Crime Over Time"),
          hr(),
          h3("How does crime change over the course of a day and over the course of
             a year in each region?"),
          plotOutput("monthly"), # monthly crime
          plotlyOutput("hourly"), # hourly crime data
          h3("Monthly Analysis"),
          p("Through experimenting with the districts and years in the monthly 
            chart, there has been a couple of patterns that have stood out."),
          p("If we look at Seattle with no district filter, we see a simple crime
            pattern. Crime maxes out in June and July and hits a minimum in 
            December and august. This must be a result of the gradual temperature
            changes during a year. With higher temperatures, there are more open
            windows to increase air flow and there are more outdoor social 
            activities that are natural contributors to a variety of crimes."),
          p("If we switch to District U, University District, we see another
            pattern. When we select district U with any combination of years,
            we find that month #6, June, is a clear outlier in crime count with
            usually 1.25x to 2x the crime compared to any of the other years. The
            end of spring quarter accompanied with drastic increase in temperature
            is the reason for this. The end of spring quarter is when most students
            move out of their apartments, houses and dorms, and new summer interns
            and summer school students move in. Doors are often left open to make
            moving easier.  This opening along with careless new residents and the 
            general summer crime trend mentioned previously must increase crime such
            as burglary and robbery in June."),
          hr(),
          h3("Hourly Analysis"),
          p("Through experimenting with districts and years in the hourly chart we 
            see another general pattern."),
          p("If we observe Seattle with no filter, we see two huge spikes in all 
            crimes excluding homicide and narcotics at 11AM, and 7PM. I think the 
            cause for this is a combination of dinner and lunch peak hour 
            contributing to increased human interaction. The more people are out,
            the more interactions there are that would lead to conflicts like 
            assault, and the more open housing there is, the more likely it is 
            that burglaries and robberies will occur."),
          hr()
        )
      )
    ),
    tabPanel(
      "Part 2",
      sidebarLayout(
        sidebarPanel(
          h3("Control - Hour"),
          sliderInput("q2hour", "Hour - Military time", min = 1, max = 24, value = 1),
          radioButtons("q2district", "District", 
                       c("North Precinct" = "north",
                         "South Precinct" = "south",
                         "Southwest Precinct" = "southwest",
                         "East Precinct" = "east",
                         "West Precinct" = "west"))
        ),
        mainPanel(
          # plot
          h1("Auto Related Crimes in Seattle"),
          h3("How many auto thefts and car prowls happen in each district in various hours?"),
          plotOutput("question2graph"),
          # insert image of precinct and district
          tableOutput("q2table"),
          h3("Analysis of Data"),
          p("This is the data for auto related incidents in the Seattle area. By auto incidents, 
            I am including auto thefts and car prowling, which is when windows are smashed and valuables
            inside the car is stolen. From the graph, no matter the hour, the North precincnt reports the 
            highest number of auto related incidents in the area. The North Precinct comprises of some of
            the most population dense districts such as Nora, Lincoln, Union, John, and Bay. It is also
            the largest area of the 5 precincts. The West precinct reports a similar high numbers of auto 
            related incidents. The West precinct comprises of Queen, David, Mary, King and in this 
            report, the headquarter as well. The least number of auto related incidents happen in the 
            Southwest precinct. It is only comprised of William and Frank districts and the number of 
            auto related incidents are relatively steady across all hours. The East precicnt is the third
            highes number of auto related incidents. It is comprised of Charlie, George and Edward. The 
            last precinct is South precinct, which is comprised of Sam, Robert and Ocean. Map of these
            precincts and districts are available below"),
          hr(),
          p("There are constantly auto related incidents throughout all hours in the Seattle area, but 
            from the bar chart we can see that there are certain hours that the incident spikes up such as
            around and after midnight. But for West precicnt, the number rises in the afternoon around
            3-5pm rather than at night. All the precincts report the a similar low number around 120's at
            4am. The North precicnt reports the highest number of 926 reports at 11am. Keep in mind that 
            this is when the car was discovered to be in trouble, not when the actual crime was happening.
            The lowest number of incidents reported is at Southwest precinct at 1am at 51 reports. At the 
            same time, North precinct reported 256 incidents, East precinct, 111, South precinct, 123,
            West precinct, 235."),
          hr(),
          h3("Reference: Districts of Seattle"),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/Southwest_Precinct.pdf",
            width = "250", height = "285", inline = TRUE),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/WestPrecinct.pdf",
            width = "252", height = "285", inline = TRUE),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/North_Precinct.pdf",
            width = "252", height = "285", inline = TRUE),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/East_Precinct.pdf",
            width = "252", height = "285", inline = TRUE),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/South_Precinct.pdf",
            width = "252", height = "285", inline = TRUE)
          # analysis
        
        )
      )
    ),
    tabPanel(
      "Part 3",
      titlePanel("Crime Frequency"),
      sidebarLayout(
        sidebarPanel(
          sliderInput("year",
            "Choose a year:",
            min = 2014,
            max = 2018,
            value = 2016,
            sep = ""
          ),
          selectInput("crime_type",
            "Select a crime",
            choices = list("Crimes" = c(
              "ASSAULTS", "SHOPLIFTING", "BURGLARY",
              "PROPERTY DAMAGE", "PROSTITUTION", "ROBBERY",
              "AUTO THEFTS", "THREATS, HARASSMENT", "TRESPASS"
            ))
          )
        ),
        mainPanel(
          tabsetPanel(
            type = "tabs",
            tabPanel(
              "Plot",
              h1("Crime Frequency Map"),
              textOutput("plot_description"),
              plotOutput("map", click = "plot_click"),
              verbatimTextOutput("info"),
              p(strong("District:"), textOutput("district_point", inline = TRUE)),
              p(strong("Frequency:"), textOutput("frequency_district", inline = TRUE)),
              br(),
              textOutput("plot_interactive"),
              leafletOutput("interactive_map"),
              p(strong("5 Districts With The Most Crimes:"), tableOutput("most_dangerous")),
              p(strong("5 Districts With The Least Crimes:"), tableOutput("most_safe"))
            )
          )
        )
      )
    ),
    tabPanel("Car Accidents",
      sidebarLayout(
        sidebarPanel(
          sliderInput(
            "time",
            label = "Time (hour.minute)",
            min = 0, max = 24.59, value = c(0, 24.59)
          ),
          checkboxGroupInput(
            "district",
            label = "District",
            choices = districts, selected = "N"
          )
        ),
        mainPanel(
          h1("Seattle Traffic Accidents"),

          h3("Number of Traffic Accidents per Hour of Day"),
          h4("What time of day is it most dangerous to drive in Seattle?"),
          p(em("Click on a data point for its coordinates.")),
          plotOutput("acc_graph_one", click = "plot_click_time"),
          p(strong("Time: "), textOutput("select_time_one", inline = TRUE)),
          p(strong("Number of Accidents: "), textOutput("freq", inline = TRUE)),
          textOutput("acc_time_description"),

          h3("Seattle District Mapping of Accidents"),
          h4("Where is it most dangerous to drive in Seattle?"),
          p(em("Click on a data point for more information.")),
          plotOutput("acc_graph_two", click = "plot_click_map"),
          p(strong("District: "), textOutput("select_dist", inline = TRUE)),
          p(strong("Number of Accidents: "), textOutput("num_selected", inline = TRUE)),
          p(strong("Hundred Block Location: "), textOutput("location", inline = TRUE)),
          p(strong("Time(s): "), textOutput("select_time_two", inline = TRUE)),


          h3("Reference: Districts of Seattle"),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/Southwest_Precinct.pdf",
            width = "250", height = "285", inline = TRUE
          ),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/WestPrecinct.pdf",
            width = "252", height = "285", inline = TRUE
          ),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/North_Precinct.pdf",
            width = "252", height = "285", inline = TRUE
          ),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/East_Precinct.pdf",
            width = "252", height = "285", inline = TRUE
          ),
          img(
            src = "https://www.seattle.gov/Documents/Departments/police/Precincts/maps/South_Precinct.pdf",
            width = "252", height = "285", inline = TRUE
          )
        )
      )
    )
  )
)

shinyUI(my_ui)
