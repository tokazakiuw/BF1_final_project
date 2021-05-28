# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)
library(maps)

# Load Data
cat("--working dir", getwd(), "\n")

# Source Data 
source("analysis.R")

# Define Server

server <- shinyServer(function(input, output, session) {
  
  # Render Graph
  output$plot <- renderPlot({
    
    
    
  })
  
  # Render Map
  output$map <- renderLeaflet({
    
    hd_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(LocationAbbr == input$State) %>% 
    leaflet() %>% 
      addTiles() %>% 
      addPolygons(data = county, lng = county$long, lat = county$lat) %>% 
      addCircles(lng = ~X_lon, lat = ~Y_lat,
                 popup = ~LocationDesc)
  })
  
  # Render Table
  output$table <- renderTable({
    
    
    
  })
  
  # Render Summary
  output$summary <- renderText({
    
    
    
  })
  
  # Render About Us
  output$about_us <- renderText({
    
    
    
  })
  
  # Render Sources
  output$sources <- renderText({
    
    
    
  })
  
})