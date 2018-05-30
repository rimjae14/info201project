source("data_setup.R")
library(shiny)
library(plotly)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      # district selection widget and year slider
      h3("controls"),
      uiOutput("controls"),
      p(strong("Note:"),"If the district input is empty, both charts will be plotting data from all seattle districts"),
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
      plotOutput("monthly"),# monthly crime
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
)
shinyUI(ui) # create the UI
