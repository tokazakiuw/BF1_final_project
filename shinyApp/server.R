# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)
library(DT)
library(plotly)

# Load Data
cat("--working dir", getwd(), "\n")

# Source Data 
source("analysis.R")

# Define Server

server <- shinyServer(function(input, output){
 
# Render Overall County Mortality Graph
  output$plot <- renderPlot({
  if(input$Disease == "Heart Disease") {
    hd_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      filter(Gender == input$Gender) %>% 
      filter(Ethnicity == "Overall") %>% 
      filter(!is.na(Data_Value)) %>% 
      group_by(LocationDesc) %>% 
      arrange(desc(Data_Value)) %>% 
      ungroup %>% 
      top_n(15, Data_Value) %>% 
  ggplot(aes(x=reorder(LocationDesc, Data_Value), y=Data_Value, fill=LocationDesc)) +
      geom_col() +
      theme(axis.text.x = element_text(angle=45, hjust = 1, siz = 8)) +
      labs(title = paste0(input$State, " Counties ", "(", input$Year, ") ", "with Highest ", input$Gender, " ", input$Disease, " Mortality Rates by Overall Ethnicity"),
           fill = paste(input$State, "Counties Labels"),
           y = paste(input$Disease, "Morality Rates (#/100000 Pop)"),
           x = paste("Top", input$State, "Counties"))
  } else {
    stroke_mortality_combined %>% 
      filter(Year == input$Year) %>% 
      filter(State == input$State) %>% 
      filter(Gender == input$Gender) %>% 
      filter(Ethnicity == "Overall") %>% 
      filter(!is.na(Data_Value)) %>% 
      group_by(LocationDesc) %>% 
      arrange(desc(Data_Value)) %>% 
      ungroup %>% 
      top_n(15, Data_Value) %>% 
      ggplot(aes(x=reorder(LocationDesc, Data_Value), y=Data_Value, fill=LocationDesc)) +
      geom_col() +
      theme(axis.text.x = element_text(angle=45, hjust = 1, siz = 8)) +
      labs(title = paste0(input$State, " Counties ", "(", input$Year, ") ", "with Highest ", input$Gender, " ", input$Disease, " Mortality Rates by Overall Ethnicity"),
           fill = paste(input$State, "Counties Labels"),
           y = paste(input$Disease, "Morality Rates (#/100000 Pop)"),
           x = paste("Top", input$State, "Counties"))
  }
})
  
# Render Ethnicity Mortality Graph
  output$plot1 <- renderPlot({
    if(input$Disease == "Heart Disease") {
      hd_mortality_combined %>% 
        filter(Year == input$Year) %>% 
        filter(State == input$State) %>% 
        filter(Gender == input$Gender) %>%
        filter(GeographicLevel == "State") %>% 
        filter(!is.na(Data_Value)) %>% 
        group_by(Ethnicity) %>% 
        arrange(desc(Data_Value)) %>% 
        ggplot(aes(x=reorder(Ethnicity, Data_Value), y=Data_Value, fill=Ethnicity)) +
        geom_col() +
        theme(axis.text.x = element_text(angle=45, hjust = 1, siz = 8)) +
        labs(title = paste0(input$Gender, " ", input$Disease, " Mortality Rates Grouped by Ethnicity in ", input$State, " (", input$Year, ")"),
             fill = paste("Ethnicity Labels"),
             y = paste(input$Disease, "Morality Rates (#/100000 Pop)"),
             x = paste("Ethnicities"))
    } else {
      stroke_mortality_combined %>% 
        filter(Year == input$Year) %>% 
        filter(State == input$State) %>% 
        filter(Gender == input$Gender) %>% 
        filter(GeographicLevel == "State") %>% 
        filter(!is.na(Data_Value)) %>% 
        group_by(Ethnicity) %>% 
        arrange(desc(Data_Value)) %>% 
        ggplot(aes(x=reorder(Ethnicity, Data_Value), y=Data_Value, fill=Ethnicity)) +
        geom_col() +
        theme(axis.text.x = element_text(angle=45, hjust = 1, siz = 8)) +
        labs(title = paste0(input$Gender, " ", input$Disease, " Mortality Rates Grouped by Ethnicity in ", input$State, " (", input$Year, ")"),
             fill = paste("Ethnicity Labels"),
             y = paste(input$Disease, "Morality Rates (#/100000 Pop)"),
             x = paste("Ethnicities"))
    }
  })
  
  # Render Map Labels
  output$label1 <- renderText({
    paste0(input$Disease, " Mortality Rates for U.S. by States in Year: ", input$Year)
  })
  
  # Render Map
  output$map <- renderPlotly({
    if(input$Disease == "Heart Disease") {
      hd_plotly %>% 
        filter(Year == input$Year) %>% 
        filter(Gender == input$Gender) %>% 
        plot_geo(locationmode = 'USA-states') %>% 
        add_trace(locations = ~State,
                  z = ~Rate, color = ~Rate,
                  text = ~hover, hoverinfo = 'text') %>% 
        layout(geo = list(scope = 'usa'))
    } else {
      stroke_plotly %>% 
        filter(Year == input$Year) %>% 
        filter(Gender == input$Gender) %>% 
        plot_geo(locationmode = 'USA-states') %>% 
        add_trace(locations = ~State,
                  z = ~Rate, color = ~Rate,
                  text = ~hover, hoverinfo = 'text') %>% 
        layout(geo = list(scope = 'usa'))
    }
  })
  
  # Render Leaflet Map Labels
  output$label2 <- renderText({
    paste0(input$Gender," ", input$Disease, " Mortality Rates for ",input$State, " State Counties in Year: ", input$Year)
  })
  
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
                 popup = ~paste(LocationDesc, input$Year, "-", input$Gender, "Heart Disease Mortality Rate of:", Data_Value, "(per 100,000 population)"),
                 radius = ~Data_Value*20,
                 color = ~hd_pal(Data_Value)) %>% 
      addLegend(title = "Mortality Rate (#/100000 Pop)", pal =  hd_pal, value = ~Data_Value)
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
                 popup = ~paste(LocationDesc, input$Year, "-", input$Gender, "Stroke Mortality Rate of:", Data_Value, "(per 100,000 population)"),
                 radius = ~Data_Value*20,
                 color = ~stroke_pal(Data_Value)) %>% 
      addLegend(title = "Mortality Rate (#/100000 Pop)", pal = stroke_pal, value = ~Data_Value)
  }
  })
  
  # Render Table
    output$data <- renderDataTable({
      if(input$Disease == "Heart Disease") {
        hd_mortality_combined %>% 
          filter(Year == input$Year) %>% 
          filter(State == input$State) %>% 
          filter(Gender == input$Gender) %>% 
          filter(!is.na(Data_Value)) %>% 
          select(Year, State, LocationDesc, GeographicLevel, Topic, Data_Value, Data_Value_Unit, Data_Value_Type, Gender, Ethnicity)
      } else {
        stroke_mortality_combined %>% 
          filter(Year == input$Year) %>% 
          filter(State == input$State) %>% 
          filter(Gender == input$Gender) %>%
          filter(!is.na(Data_Value)) %>% 
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
        filter(!is.na(Data_Value)) %>% 
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
            filter(!is.na(Data_Value)) %>% 
            group_by(Ethnicity) %>% 
            summarize(highest = max(Data_Value)) %>% 
      mutate(Ethnicity= paste(Ethnicity)) %>% 
      mutate(highest= paste(highest))
 paste("The highest value for stroke for",highestVar$Ethnicity, "is", highestVar$highest,". " )
    }
 })

  # Render Conclusion
  output$conclusion <- renderText({
    paste("In the graph, “Stroke Mortality Rates Grouped by Ethnicity in WA”, 
    it appears that Hispanic females have a lower rate of mortality from a stroke than
    Hispanic males from 2014 to 2018, except in 2016. In 2016, the mortality rate for Hispanic
    males and females was the same (rate:53). From the same graph, you can see that Black, American 
    Indian, and Alaskan Native are the top three ethnicities in Washington with the highest mortality
    rate for both stroke and heart disease.  The data quality wasn’t completely perfect. It lacked representation
    for minorities. Sometimes the data wouldn’t return data for minorities, it would just say “NA.”  Which results 
    in biased results and also harming minorities by not giving the proper information. I think adding income level and
    exercise level to the data set would be interesting to see how these parts play a role in the mortality rate of cardiovascular
    diseases in the U.S.")
  })  
  
  # Render About Us
  output$about_us <- renderText({
    
   
  })

  # Plot & Table Descriptions
  # Render Graph Description
  output$graphdesc <- renderText({
    paste0("These graphs represent the ", input$Gender, " ",input$Disease, " Mortality Rates for ", input$State, " State in Year ", input$Year,
           ". Gathered from averaged CDC (Centers for Disease Control and Prevention) Cardiovascular Disease Mortality data among US adults (age 35+), 
           we can plot instances by certain variables to gain insights. In the upper plot we can see a state's counties with highest mortality rates, 
           and in the lower plot we see how these mortality rates compare to underlying factors such as ethnicity.")
    
  })
  
  # Render Map Description
  output$mapdesc <- renderText({
    paste0("These maps represent the ", input$Gender, " ",input$Disease, " Mortality Rates for ", input$State, " State in Year ", input$Year,
           ". Gathered from averaged CDC (Centers for Disease Control and Prevention) Cardiovascular Disease Mortality data among US adults (age 35+), 
           we can plot instances by certain variables to gain insights. By using geospatial location for analysis, specifically, we can depict the level/severity of mortality rates 
           by using a color scale and filling geospatial values according to this scale. In the upper plot we can see the spread of mortality rates among US states in a given year, 
           and in the lower plot we see how these mortality rates compare against specific counties in a selected state.")
    
  })
  
  # Render Table Description
  output$tabledesc <- renderText({
    
    
  })
  
})