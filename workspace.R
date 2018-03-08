library('twitteR')

source('apikeys.R')

trend.location <- availableTrendLocations()
us.woeid <- trend.location[461, 3]
us.trends <- getTrends(us.woeid)
