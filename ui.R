source("data_setup.R")
library(dplyr)
library(shiny)
library(ggplot2)
library(DT)
library(leaflet)

ui <- fluidPage(
  titlePanel("Crime Frequency"),
  sidebarLayout(
    sidebarPanel(
      sliderInput('year',
                  "Choose a year:",
                  min = 2014,
                  max = 2018,
                  value = 2016,
                  sep = ""),
      selectInput('crime_type',
                  "Select a crime",
                  choices = list('Crimes' = c("ASSAULTS", "SHOPLIFTING", "BURGLARY",
                                              "PROPERTY DAMAGE", "PROSTITUTION", "ROBBERY",
                                              "AUTO THEFTS", "THREATS, HARASSMENT", "TRESPASS")))
    ),
    mainPanel(
      tabsetPanel(type = 'tabs',
                  tabPanel('Plot',
                           h1("Crime Frequency Map"),
                           textOutput("plot_description"),
                           plotOutput('map', click = "plot_click"),
                           verbatimTextOutput("info"),
                           p(strong("District:"), textOutput("district_point", inline = TRUE)),
                           p(strong("Frequency:"), textOutput("frequency_district", inline = TRUE)),
                           br(),
                           textOutput("plot_interactive"),
                           leafletOutput('interactive_map'),
                           p(strong("5 Districts With The Most Crimes:"), tableOutput("most_dangerous")),
                           p(strong("5 Districts With The Least Crimes:"), tableOutput("most_safe"))
                  )
      )
    )
  )
)

shinyUI(ui)