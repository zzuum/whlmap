##### Mapping CWHL and NWHL Teams 
# Imports ----
library(maps)
library(mapdata)
library(ggplot2)
library(ggthemes)
library(ggrepel) # Helps space labels
library(raster)
# Data input ----
teams <- read.csv('nwhl_cwhl.csv')
teams$League <- factor(teams$League)
teams$City <- factor(teams$City)

us <- getData("GADM", country = "USA", level = 1)
canada <- getData("GADM", country = "CAN", level = 1)
states <- c('Connecticut', 'New York', 'New Jersey', 'Massachusetts')
provinces <- c('Ontario', 'Alberta', 'Québec', 'Saskatchewan', 'Manitoba')

us.states <- us[us$NAME_1 %in% states, ]
ca.provinces <- canada[canada$NAME_1 %in% provinces, ]

countries <- ggplot(
  us.states, 
  aes(x = long, y = lat, group = group)
  ) + geom_path(
    size = 0.15,
    color = 'lightblue'
  ) + geom_path(
    data = ca.provinces,
    size = 0.15,
    color = 'lightblue'
  ) + coord_map() + theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = 'white', color = 'white'),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    legend.background = element_blank()
  )

whl <- countries + geom_point(
  data = teams, 
  aes(Longitude, Latitude, color = League, shape = League, group = NULL),
  size = 2.
  ) + geom_text_repel(
  data = teams,
  aes(Longitude, Latitude, label = City, group = NULL), 
  color = 'black', 
  size = 4) + ggtitle("Professional Women's Hockey Teams")

whl
