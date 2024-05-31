library(shiny)
library(shinydashboard)
library(dplyr)
library(sf)
library(ggplot2)
library(wordcloud2)

ui <- dashboardPage(
  dashboardHeader(title = "Election Insights"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(title = "Word Cloud of Worries", status = "primary", solidHeader = TRUE, 
          width = 6, wordcloud2Output("wordCloud")),  
      box(title = "Map of Strongest Party by Canton", status = "primary", solidHeader = TRUE, 
          width = 6, plotOutput("mapPlot"))
    )
  )
)

# prepare 'count_data' and 'cantons_with_results'
source("scripts/map_viz.R")

server <- function(input, output) {
  # Render the word cloud using prepared 'count_data'
  output$wordCloud <- renderWordcloud2({
    wordcloud2(count_data, size = 0.4)  # Assuming 'count_data' has 'words' and 'freq' columns
  })

}

shinyApp(ui = ui, server = server)
