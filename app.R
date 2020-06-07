#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(rgdal)
library(tidycensus)
library(tidyverse)
library(sf)
library(stringr)

source("generate_projections.R")




ui <- fluidPage(

    # Application title
    titlePanel("Coronavirus US Projections"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("days",
                        "Days from Now",
                        min = 1,
                        max = 100,
                        value = 30)
        ),

        mainPanel(
            leafletOutput("map")

        )
    )
)

# Define server logic required to draw map
server <- function(input, output) {

    states <- readOGR("tl_2019_us_state.shp",
                    layer = "tl_2019_us_state", GDAL1_integer64_policy = TRUE)

    
    allStates <- subset(states, !(states$STUSPS %in% c(
        "PR","MP","GU","AS", "VI")
    ))
    
    projections <- generate_projections()
    
    output$map <- renderLeaflet({
        days <- input$days
        char_days <- as.character(days)
        
        time <- seq(from = 0, to = days, by = 1)
        
        allStates$Deaths = as.vector(projections[[1]][char_days])
        allStates$Infections = as.vector(projections[[2]][char_days])
        allStates$Recovered = as.vector(projections[[3]][char_days])
        allStates$Quarantined = as.vector(projections[[4]][char_days])
        #data_for_day <- as_tibble(data.frame(GEOID = as.character(allStates$GEOID), State = as.character(allStates$STUSPS), Deaths = projections[[1]][char_days], Infections = projections[[2]][char_days],
        #                           Recovered = projections[[3]][char_days], Quarantined = projections[[4]][char_days],
         #                          Polygons = ))
        
        pal <- colorQuantile(palette = "YlOrRd", domain = allStates$Deaths, n = 10)
        
        
        allStates %>% leaflet(width = "100%") %>%
            addTiles() %>%
            addPolygons(label = ~ (paste0(STUSPS, " - ", "Deaths: ", format(round(Deaths, 2), nsmall = 2))
            ),
            stroke = FALSE,
            smoothFactor = 0,
            fillOpacity = 0.7,
            fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND)) 
            #color = ~ pal(as.numeric(Deaths))) %>%
           # addLegend("bottomright", 
            #          pal = pal,
             #         values = ~ Deaths,
              #        title = "Deaths",
               #       opacity = 1)
        
        
        

    })
}

# Run the application 
shinyApp(ui = ui, server = server)
