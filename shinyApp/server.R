# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)
library(plotly)
# Load Data
cat("--working dir", getwd(), "\n")

# Source Data 
source("analysis.R")

# Define Server

server <- shinyServer(function(input, output, session){
  # Render Overall County Mortality Graph
  output$plot <- renderPlot({
  if(input$Disease == "Heart Disease") {
  hd_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      filter(Gender == input$Gender) %>% 
      filter(Ethnicity == "Overall") %>% 
      group_by(LocationDesc) %>% 
      arrange(desc(Data_Value)) %>% 
      slice_head(n = 10) %>% 
  ggplot(aes(x=reorder(LocationDesc, Data_Value), y=Data_Value, fill=LocationDesc)) +
      geom_col() +
      theme(axis.text.x = element_text(angle=90, hjust = 1, siz = 6)) +
      labs(title = paste("Top 10 Counties with Highest Overall Mortality Rates in", input$State, input$Year),
           y = paste(input$Disease, "Morality Rates per 100000 Population"),
           x = "Counties")

  } else {
    stroke_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      filter(Gender == input$Gender) %>% 
      filter(Ethnicity == "Overall") %>% 
      group_by(LocationDesc) %>% 
      arrange(desc(Data_Value)) %>% 
      slice_head(n = 10) %>% 
      ggplot(aes(x=reorder(LocationDesc, Data_Value), y=Data_Value, fill=LocationDesc)) +
      geom_col() +
      theme(axis.text.x = element_text(angle=90, hjust = 1, siz = 6)) +
      labs(title = paste("Top 10 Counties with Highest Overall Mortality Rates in", input$State, input$Year),
           y = paste(input$Disease, "Morality Rates per 100000 Population"),
           x = "Counties")
  }
    
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
        hd_mortality_combined %>% 
          filter(Year == input$Year) %>% 
          filter(State == input$State) %>% 
          filter(Gender == input$Gender) %>% 
          select(Year, State, LocationDesc, GeographicLevel, Topic, Data_Value, Data_Value_Unit, Data_Value_Type, Gender, Ethnicity)
      } else {
        stroke_mortality_combined %>% 
          filter(Year == input$Year) %>% 
          filter(State == input$State) %>% 
          filter(Gender == input$Gender) %>%
          select(Year, State, LocationDesc, GeographicLevel, Topic, Data_Value, Data_Value_Unit, Data_Value_Type, Gender, Ethnicity)
      }
  })
      
  # Render Summary
  output$summary <- renderText({
    #What Ethnicity has the highest rate of mortality from heart disease
    if(input$Disease == "Heart Disease"){ 
   highestVar <- hd_mortality_combined %>%
     select(Year, State, Gender,Ethnicity, Data_Value) %>%
        filter(Year == input$Year) %>% 
        filter(State == input$State) %>%
        filter(Gender == input$Gender) %>%
        group_by(Ethnicity) %>% 
        summarize(highest = max(Data_Value)) %>% 
     mutate(Ethnicity= paste(Ethnicity)) %>% 
     mutate(highest= paste(highest))
  paste("The highest value for heart disease for",highestVar$Ethnicity, "is", highestVar$highest, ". ")

  }
    else{ 
    highestVar2 <- stroke_mortality_combined %>% 
      select(Year, State, Gender,Ethnicity, Data_Value) %>%
            filter(Year == input$Year) %>% 
            filter(State == input$State) %>% 
            filter(Gender == input$Gender) %>% 
            group_by(Ethnicity) %>% 
            summarize(highest = max(Data_Value)) %>% 
      mutate(Ethnicity= paste(Ethnicity)) %>% 
      mutate(highest= paste(highest))
 paste("The highest value for stroke for",highestVar$Ethnicity, "is", highestVar$highest,". " )

    
    }
 })
  # Render About Us
  output$about_us <- renderText({
    
   
  })
  
  # Render Sources
  output$sources <- renderText({
    
  })

})