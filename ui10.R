# Loads the required libraries
library("shiny")
library("ggplot2")


shinyUI(fluidPage(
  
  # Gives a title to the shiny app
  titlePanel("What are the top 3 trending hashtags for a selected location"),
  
  # Specifies the type of layout
  sidebarLayout(
    # Generates the widgets for user interaction
    sidebarPanel(
      selectInput("maptype", "Select your map type:", choices = list("World Map" = "world", "USA" = "state", "Italy" = "italy", "New Zeland" = "nz"), selected = "World Map", multiple = FALSE)
    ),
    
    # Displays either a table of data or a Choropleth map
    mainPanel(
              plotOutput("plot", click = "plot_click"), textOutput("info"), tableOutput("trend_table")
      )
    )
  )
)