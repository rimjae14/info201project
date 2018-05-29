source("data_setup.R")
library(dplyr)
library(shiny)
library(ggplot2)
library(DT)

my_ui <- fluidPage(
    titlePanel("Crime Frequency"),
    sidebarLayout(
      sidebarPanel(
        sliderInput('year',
                    "Choose a year:",
                    min = 2013,
                    max = 2018,
                    value = 2015,
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
                             plotOutput('map', click = "plot_click"),
                             verbatimTextOutput("info"),
                             textOutput("plot_description")
                             )
                    )
                )
            )
        )

shinyUI(my_ui)