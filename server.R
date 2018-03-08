library(twitteR)
library(maps)
library(dplyr)
library(markdown)
source("API_keys.R")
options(shiny.sanitize.errors = FALSE)

server <- function(input, output, sessions) {
  # Shiva's map tab
  ####################################
  reactive.function <- reactive({
    input.location <- closestTrendLocations(input$plot_click$y, input$plot_click$x)
    return(input.location)
  })
  
  
  # Generates the map
  output$plot <- renderPlot({
    
    data <- map_data(input$maptype) 
    gg <- ggplot(data = data) + 
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
    input.location <- reactive.function()
    trending <- getTrends(input.location$woeid[1]) %>% head(5)
    output.text <- paste0("The region you have choesen is ", input.location$name[1],", ",
                          input.location$country[1], ". The following are the trending topics in your
                            chosen location: ", trending$name[1], ", ", trending$name[2], ", ", trending$name[3])
  })
  
  # Teddy's trends tab
  #####################################
  what.to.display <- reactive({
    return(input$trend.type)
  })

  output$table <- renderDataTable({
    trend.location <- availableTrendLocations()
    us.woeid <- trend.location[461,3]
    us.trends <- getTrends(us.woeid)
    if(what.to.display() == 'Hashtags') {
      us.trends <- filter(us.trends, startsWith(name, "#"))
    } else if(what.to.display() == 'Non-Hashtags') {
      us.trends <- filter(us.trends, !startsWith(name, "#"))
    }
    us.trends <- us.trends[,-3:-4]
    colnames(us.trends) <- c("Trending", "URL")
    return(us.trends)
  })
  
  # Keegan's search tab
  ####################################
  
  # A reactive dataframe of the most retweeted tweets
  # with the input hashtag
  most.retweet <- reactive({
    if (input$searchString != "Enter Hashtag" & input$searchString != "" & input$searchString != "#") {
      searchString <- input$searchString
      if (!startsWith(input$searchString, "#")) {
        searchString <- paste0('#', input$searchString)
      }
      tweets <- searchTwitter(searchString,
                              n= input$maxNum,
                              resultType = "popular",
                              since = as.character(input$dates[1]),
                              until = as.character(input$dates[2]))
      if(length(tweets) > 0) {
        tweets.df <- twListToDF(tweets) %>% arrange(desc(retweetCount))%>%
          select(text, screenName, retweetCount)
        colnames(tweets.df) <- c("Tweet", "User", "Retweet Count")
        return(tweets.df)
      }
    }
    return(NULL)
  })

  # Reactive date
  output.dates <- reactive({
    return(input$dates)
  })
  
  # Renders the most.retweet dataframe
  output$pop.tweets <- renderTable({
    if (!is.null(most.retweet())) {
      return(most.retweet())
    } else {
      return(NULL)
    }
  })
}