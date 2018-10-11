install.packages("mapview")
library(mapview)
mapview()


library(dataRetrieval)
pCode <- c("00665")
phos.wi <- readNWISdata(stateCd="WI", parameterCd=pCode,
                        service="site", seriesCatalogOutput=TRUE)


library(dplyr)
phos.wi <- filter(phos.wi, parm_cd %in% pCode) %>%
  filter(count_nu > 50) %>%
  mutate(period = as.Date(end_date) - as.Date(begin_date)) %>%
  filter(period > 15*365)


library(leaflet)
leafMap <- leaflet(data=phos.wi) %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~dec_long_va,~dec_lat_va,
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm)


library(htmlwidgets)
library(htmltools)

currentWD <- getwd()
dir.create("static/leaflet", showWarnings = FALSE)
setwd("static/leaflet")
saveWidget(leafMap, "leafMap.html")
setwd(currentWD)



library(leaflet)
library(widgetframe)
l <- leaflet() %>% addTiles() %>% setView(0,0,2)
frameWidget(l, height = '400')


