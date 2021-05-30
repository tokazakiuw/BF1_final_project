# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)

# Load Data
cat("--working dir", getwd(), "\n")

# Source Data 
source("analysis.R")

# Define Server

server <- shinyServer(function(input, output, session) {
  
  # Render Graph
  output$plot <- renderPlot({
    ggplot(stroke_mortality_combined,aes(x=Year,y=Data_Value)) +
      geom_line()
    
    
  })
  
  # Render Map
  output$map <- renderLeaflet({
    
    hd_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(LocationAbbr == input$State) %>% 
    leaflet() %>% 
      addTiles() %>% 
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