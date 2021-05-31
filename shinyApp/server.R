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

server <- shinyServer(function(input, output, session){
  
  # Render Graph
  output$plot <- renderPlot({

  })
  
  # Render Map
  
  # Render Leaflet Map
  output$lmap <- renderLeaflet({

  if(input$Disease == "Heart Disease") {
    hd_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      filter(Gender == input$Gender) %>% 
      filter(!is.na(Data_Value)) %>% 
      filter(GeographicLevel != "State") %>% 
    leaflet() %>% 
      addTiles() %>% 
      addCircles(lng = ~X_lon, lat = ~Y_lat,
                 popup = ~LocationDesc, radius = ~Data_Value*20,
                 color = ~hd_pal(Data_Value)) %>% 
      addLegend(pal =  hd_pal, value = ~Data_Value)
    
  } else {
    stroke_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      filter(Gender == input$Gender) %>% 
      filter(!is.na(Data_Value)) %>% 
      filter(GeographicLevel != "State") %>% 
    leaflet() %>% 
      addTiles() %>% 
      addCircles(lng = ~X_lon, lat = ~Y_lat,
                 popup = ~LocationDesc, radius = ~Data_Value*20,
                 color = ~stroke_pal(Data_Value)) %>% 
      addLegend(pal = stroke_pal, value = ~Data_Value)
      
  }
  })
  
  # Render Table
    output$data <- renderDataTable({
      
      if(input$Disease == "Heart Disease") {
        hd_mortality_combined
      } else {
        stroke_mortality_combined
      }
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