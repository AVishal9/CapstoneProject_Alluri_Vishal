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
source("scripts/EDA.R")

server <- function(input, output) {
  # Render the word cloud using prepared 'count_data'
  output$wordCloud <- renderWordcloud2({
    wordcloud2(count_data, size = 0.4)  # Assuming 'count_data' has 'words' and 'freq' columns
  })
  
  # Render the map plot using 'cantons_with_results'
  output$mapPlot <- renderPlot({
    ggplot(cantons_with_results) +
      geom_sf(aes(fill = partei_bezeichnung_en), color = "black", size = 0.5) +
      geom_text(aes(x = x, y = y, label = paste(NAME, round(partei_staerke, 1), "%")),
                size = 3, color = "black", fontface = "bold") +
      scale_fill_manual(values = party_colors, na.value = "grey") + 
      theme_void() +
      labs(title = "National Council Elections 2023: Strongest Party by Canton")
  })
}

shinyApp(ui = ui, server = server)
