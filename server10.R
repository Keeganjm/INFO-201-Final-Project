library(twitteR)
library(dplyr)

consumer_key <- "PmTJihCUOVhyB6PW3MZ8Ae4yA"
consumer_secret <- "V5FmgTQje3berMTBplHipo5IEkEX40W8NluZDfhl3mroBuQdhl"
access_token <- "966089477134286849-4SuzpqD3dsMZrUcII2cfkp0SuRbiS3b"
access_secret <- "2hv5UOQoq28uZ1cnbPfqYNRv5sXwuM1vabRL3XqUfC5QE"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

input.location <- closestTrendLocations(47.658195, -122.313171)


library("shiny")
library("ggplot2")
source("spatial_utils.R")

# Sources a file that allows us to find a country given its lat and long
#source("spatial_utils.R")

shinyServer(
  function(input, output) {
    
    reactive.function <- reactive({
      world <- map_data(input$maptype)
     return(world)
    })
    
    reactive.function.two <- reactive({
      input.location <- closestTrendLocations(input$plot_click$y, input$plot_click$x)
      return(input.location)
    })
    

    # Generates the Choropleth map
    output$plot <- renderPlot({
      gg <- ggplot(data = reactive.function()) + 
        geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
        coord_fixed(1.3) +
        guides(fill=FALSE)
      return(gg)
    })
    
    # Generates information to make the map interactive
    output$info <- renderText({
      if(is.null(input$plot_click$y) & is.null(input$plot_click$x)) {
        return(NULL)
      }
       input.location <- reactive.function.two()

       output.text <- paste0("The region you have choesen is ", input.location$name[1],", ",
                            input.location$country[1], ". The following are the trending hashtags in your
                             chosen location:")
    })
    
    output$trend_table <- renderTable({
      if(is.null(input$plot_click$y) & is.null(input$plot_click$x)) {
        return(NULL)
      }
      input.location <- reactive.function.two()
      trending <- getTrends(input.location$woeid[1]) %>% head(5) %>%
        select("name", "url")
      
      return(trending)
    })
    
    
  })
