library(twitteR)
library(maps)
library(dplyr)

server <- function(input, output, sessions) {
  most.retweet <- reactive({
    if (input$searchString != "Enter Hashtag" & input$searchString != "" & input$searchString != "#") {
      tweets <- searchTwitter(input$searchString, 
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
  
  output.dates <- reactive({
    return(input$dates)
  })
  
  output$pop.tweets <- renderTable({
    if (!is.null(most.retweet())) {
      return(most.retweet())
    }
  })
  
  output$datesOutput <- renderText({
    output.dates()
  })
}