# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(tidyverse)

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