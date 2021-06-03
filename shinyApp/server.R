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
          select(-GeographicLevel, -Location.1, -Georeference.Column)
      } else {
        stroke_mortality_combined %>% 
          filter(Year == input$Year) %>% 
          filter(State == input$State) %>% 
          filter(Gender == input$Gender) %>%
          filter(!is.na(Data_Value)) %>% 
          select(-GeographicLevel, -Location.1, -Georeference.Column)
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
    rate for both stroke and heart disease.  The data quality isn't perfect. It lacked representation
    for minorities. Sometimes the data wouldn’t return data for minorities, it would just say “NA.”  Which results 
    in biased results and also harming minorities by not giving the proper information. If income level, age, and
    exercise level were added to the data set, it would be interesting to see how they play a role in the mortality rate of cardiovascular
    diseases and strokes in the U.S.")
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
    paste0("This tables represent the ", input$Gender, " ",input$Disease, " Mortality Rates for ", input$State, " State in Year ", input$Year,
           ". Gathered from averaged CDC (Centers for Disease Control and Prevention) Cardiovascular Disease Mortality data among US adults (age 35+), 
           we can plot instances by certain variables to gain insights. By showing the underlying numeric values which drive the visualizations for various plots, 
           we can get a better understanding of the data and its significance. By showing variables highlighted in the plots prior such as location, gender, and ethnicity, 
           we see the plethora of observations which construct the dataset. Along with verifying our visualizations with these numeric tables, we can reinforce our credibility 
           by showing the dataset and allowing for user exploration.")
    
  })
  
  #Render Overview
  output$overview <- renderText({
    paste0("This analysis seeks to examine heart disease and stroke mortality rates per county in the United States, and to display existing disparities in mortality 
    rates by ethnicity and gender. This analysis uses data from the Centers for Disease Control and Prevention which documents the stroke mortality rate and 
           heart disease mortality rate by county, ethnicity, and gender.  Data was compiled from 10 individual datasets provided by the CDC, 5 for each cause of death, and is displayed in 
           2 bar graphs, a map plot, a leaflet plot, and a table, each with unique and pertinent insights derived from the data. 
           ")
    
  })
  
  #Render About Us Bios
  
  #Pablo Aguirre
  output$pablo <- renderText({
    paste0("Hello, I am a 3rd year pursuing a major in Economics.  My interests are in global finance legislation, business, and technology.  On the weekends, I enjoy spending time with 
           my friends and family and going outside!")
  })
    #Jennifer Morales 
    output$jennifer <- renderText({
      paste0("Hey, I'm a first year hoping to major in Informatics. I enjoy working out, scrolling through TikTok, and hanging out with
             friends and family.")
    })
    #Ty Okazaki 
    output$ty <- renderText({
      paste0("Hello! My name is Ty and I'm a first year student intending to major in Economics or Data Science. On my free time I enjoy 
             playing/listening to music, spending time with my friends, and programming. I also have a pet dog named Yumi")
    })
})

  


