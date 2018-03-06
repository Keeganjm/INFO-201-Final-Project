library(shiny)
source("server.R")

ui <- fluidPage(
  titlePanel("Most Retweeted Tweet with a Specific HashTag"),
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
      verbatimTextOutput("datesOutput"),
      tableOutput("pop.tweets")
    )
  )
)