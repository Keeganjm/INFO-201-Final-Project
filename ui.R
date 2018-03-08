library(shiny)
library(twitteR)
library(dplyr)
library(shiny)
library(ggplot2)
source("server.R")

ui <- fluidPage(
 tabsetPanel(
    tabPanel("Introduction", includeMarkdown("README.md")),
    tabPanel("Trends", fluidRow(align = 'center',
                                helpText("What type of trends from the US would you like to see?"),
                                radioButtons('trend.type', '', c('Hashtags', 'Non-Hashtags', 'Both!'), selected = 'Hashtags'),
                                br(),
                                column(12, dataTableOutput('table'))
    )),
    tabPanel("Map", 
             # Gives a title to the shiny app
             titlePanel("What are the top 3 trending topics for a selected location"),
             
             # Specifies the type of layout
             sidebarLayout(
               # Generates the widgets for user interaction
               sidebarPanel(
                 selectInput("maptype", "Select your map type:", choices = list("World Map" = "world", "USA" = "state", "Italy" = "italy", "New Zeland" = "nz"), selected = "World Map", multiple = FALSE)
               ),
               
               # Displays either a table of data or a Choropleth map
               mainPanel(
                 plotOutput("plot", click = "plot_click"), textOutput("info")
               )
             )
    ),
    tabPanel("Search",titlePanel("Most Retweeted Tweet with a Specific HashTag"),
             sidebarLayout(
               sidebarPanel(
                 textInput("searchString", "Search for a hashtag", value = "Enter Hashtag"),
                 sliderInput("maxNum", "Max number of tweets returned",
                             min = 1, max = 100, value = 10),
                 h4("Dates later than 1 week ago will have no results"),
                 dateRangeInput("dates", "Date Range", format = "yyyy-mm-dd",
                                start = Sys.Date() - 7, end = Sys.Date())
               ),
               mainPanel(
                 tableOutput("pop.tweets")
               )
             ))
  )
  )