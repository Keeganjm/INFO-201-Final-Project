US_capitals <- us.cities[us.cities$capital == 1 | us.cities$capital == 2,]
geocodes <- paste0(US_capitals$lat, ",", US_capitals$long, ",50mi")
fcc_date <- "2018-02-22"
day_after_fcc <- "2018-02-23"
tweets <- strip_retweets(searchTwitter('#savetheinternet|#savenetneutrality', 
                                       since = fcc_date, 
                                       until = day_after_fcc, 
                                       n=100, 
                                       resultType = "popular")
                         )
tweets.df <- twListToDF(tweets)
