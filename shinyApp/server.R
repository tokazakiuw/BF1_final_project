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
    
    # Seperate Location.1 Latitude and Longitude
    hd_mortality_combined <- hd_mortality_combined %>% 
      separate(Location.1, c("Y_lat", "X_lon"), ",")
    
    hd_mortality_combined %>% 
      filter(Year >= input$Year[1] & Year <= input$Year[2]) %>% 
      filter(LocationAbbr == input$State) %>% 
    leaflet() %>% 
      addTiles() %>% 
      addCircles(lng = ~X_long, lat = ~Y_lat,
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