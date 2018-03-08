library("shiny")
library("dplyr")

source("workspace.R")

shinyApp(
  
  ui = fluidPage(
    fluidRow(align = 'center',
        helpText("What type of trends would you like to see?"),
        radioButtons('trend.type', '', c('Hashtags', 'Non-Hashtags', 'Both!'), selected = 'Hashtags'),
        br(),
        column(12, dataTableOutput('table'))
    )
  ),
  
  server = function(input, output) {
    what.to.display <- reactive({
      return(input$trend.type)
    })
    
    output$table <- renderDataTable({
      if(what.to.display() == 'Hashtags') {
        us.trends <- filter(us.trends, startsWith(name, "#"))
      } else if(what.to.display() == 'Non-Hashtags') {
        us.trends <- filter(us.trends, !startsWith(name, "#"))
      }
      colnames(us.trends) <- c("Trending", "URL", "Query", "woeid")
      return(us.trends)
    })
  }
)
