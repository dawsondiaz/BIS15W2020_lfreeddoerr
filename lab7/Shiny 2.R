library(tidyverse)
library(shiny)
library(shinydashboard)

UC_admit <- readr::read_csv("data/UC_admit.csv")

UC_admit2 <- UC_admit %>% mutate(Academic_Yr = as_factor(Academic_Yr))

ui <- 
  dashboardPage(
    dashboardHeader(title = "Plot UC by Year"),
    dashboardSidebar(),
    dashboardBody(
      fluidRow(
        box(
          selectInput("fill", "Select Fill", choices = c("Ethnicity", "Campus", "Category"),
                      selected = "Ethnicity"),
        ), # close the first box
        box(
          plotOutput("plot", width = "500px", height = "400px")
        ) # close the second box
      ) # close the row
    ) # close the dashboard body
  ) # close the ui

server <- function(input, output, session) { 
  
  # the code to make the plot of iris data grouped by species
  output$plot <- renderPlot({
    ggplot(UC_admit2, aes_string(x = "Academic_Yr", y = "FilteredCountFR", fill = input$fill)) + 
      geom_col(position = "dodge") + 
      coord_flip() +
      theme_light(base_size = 18)
  })
  
  # stop the app when we close it
  session$onSessionEnded(stopApp)
  
}

shinyApp(ui, server)