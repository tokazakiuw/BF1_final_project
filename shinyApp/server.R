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
<<<<<<< HEAD
    ggplot(stroke_mortality_combined,aes(x=Year,y=Data_Value)) +
      geom_line()
    
    
=======

>>>>>>> origin
  })
  
  # Render Map
  output$map <- renderLeaflet({

  if(input$Disease == "Heart Disease") {
    hd_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
    leaflet() %>% 
      addTiles() %>% 
      addCircles(lng = ~X_lon, lat = ~Y_lat,
                 popup = ~LocationDesc)
  } else {
    stroke_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addCircles(lng = ~X_lon, lat = ~Y_lat,
                 popup = ~LocationDesc)
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