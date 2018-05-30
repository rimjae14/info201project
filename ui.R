library(shiny)

my_ui <- fluidPage(
  titlePanel("title of project"),
  p(em("our names")),
  navbarPage("Introduction of Project",
      p(em("introduction paragraph")),
      tabPanel("Part 1"),
      tabPanel("Part 2",
        sidebarLayout(
          sidebarPanel(
            sliderInput("q2hour", "Hour", min = 1, max = 24, value = 1)
          ),
          mainPanel(
            #plot
            plotOutput("question2graph"),
            tableOutput('hours')
          
          )
        
          )
      ),
      tabPanel("Part 3"),
      tabPanel("Part 4"))
)

shinyUI(my_ui)