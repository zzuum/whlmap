##### Mapping CWHL and NWHL Teams 
# Imports ----
library(maps)
library(mapdata)
library(ggplot2)
library(ggthemes)
library(ggrepel) # Helps space labels
library(raster)
# Data input nnd setup ----
teams <- read.csv('nwhl_cwhl.csv')
teams$League <- factor(teams$League, 
                       levels = c('NWHL', 'CWHL', 'NWHL/CWHL', 'Independent'))
teams$City <- factor(teams$City)

us <- getData("GADM", country = "USA", level = 1)
canada <- getData("GADM", country = "CAN", level = 1)
states <- c('Connecticut', 'New York', 'New Jersey', 'Massachusetts',
            'Minnesota')
provinces <- c('Ontario', 'Alberta', 'Québec', 'Saskatchewan', 'Manitoba')

us.states <- us[us$NAME_1 %in% states, ]
ca.provinces <- canada[canada$NAME_1 %in% provinces, ]

# Plotting the map ----
countries <- ggplot(
  us.states, 
  aes(x = long, y = lat, group = group)
  ) + geom_path(
    size = 0.25,
    color = 'red'
  ) + geom_path(
    data = ca.provinces,
    size = 0.25,
    color = 'red'
  ) + coord_map() + theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = 'grey', color = 'white'),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank()
  )

# Plotting the teams ----
whl <- countries + geom_point(
  data = teams, 
  aes(Longitude, Latitude, color = League, 
      shape = League, group = NULL),
  size = 2.
  ) + scale_color_manual(
    values = c(
      'NWHL' = 'blue',
      'CWHL' = 'red', 
      'NWHL/CWHL' = 'green', 
      'Independent' = 'black'
    ) 
  ) + scale_shape_manual(
    values = c(
      'NWHL' = 15,
      'CWHL' = 16, 
      'NWHL/CWHL' = 17, 
      'Independent' = 18
    )
  ) + geom_text_repel(
  data = teams,
  aes(Longitude, Latitude, label = City, group = NULL), 
  color = 'black', 
  size = 4) + ggtitle("Professional Women's Hockey Teams") + theme(
    plot.title = element_text(hjust = 0.5), # Centers the title
    legend.background = element_blank()
  )

whl
