library(twitteR)
library(dplyr)
library(stringi)


credentials <- c(
  "twitter_api_key=nnvIj82KUaUfBQGHAhU1iOLgs",
  "twitter_api_secret=Bu1CajHOaE4OnqhTHFCD53e5JM6vW9LM1b2MypfczesTE6RXvf",
  "twitter_access_token=2221658849-aCukIh8jAiWBNQk4MRXkmaADTYfa0eO2CRWfrWL",
  "twitter_access_token_secret=NwvueZ4U1ZGaaFWtROf4MnQ3N21sAYNzZHO1BMBqt1DoW"
)

fname <- paste0(normalizePath("~/"),".Renviron")
writeLines(credentials, fname)

#browseURL(fname)

api_key <- Sys.getenv("twitter_api_key")
api_secret <- Sys.getenv("twitter_api_secret")
access_token <- Sys.getenv("twitter_access_token")
access_token_secret <- Sys.getenv("twitter_access_token_secret")

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


user <- getUser("RDataCollection")
user$getFollowersCount()





x <- searchTwitter('piwo|beer', geocode='52.227872,21.008039,7km',  n=50, retryOnRateLimit=1)


craft_beer <- searchTwitter('beer', geocode='40.714353,-74.005973,10000mi', n=50000, retryOnRateLimit=1)

craft_beer_dt <- t(sapply(craft_beer, function(x) c(latitude = x$latitude, 
                                                    longitude = x$longitude, 
                                                    date = as.character(as.Date(x$created)), 
                                                    text =  x$text ))) %>% tbl_dt()

m <- leaflet() %>% addTiles()

(m2 <- m %>%
   setView(lng = -74.005973, lat = 40.714353, zoom = 4) %>%
  addCircleMarkers(craft_beer_dt$longitude, craft_beer_dt$latitude, 
                   popup = htmltools::htmlEscape(iconv(craft_beer_dt$text)),
                   radius = 0.1, color = "red", fillOpacity = 0.01))
