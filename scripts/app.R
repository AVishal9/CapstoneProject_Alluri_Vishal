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

