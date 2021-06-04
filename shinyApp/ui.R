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

# Define UI

ui <- fluidPage(
  titlePanel("Cardiovascular Disease Mortality in the U.S"),
  sidebarLayout(
    sidebarPanel(
      # Select Year Range
      sliderInput(inputId = "Year", label = "Select Year Range",
                  min = 2014, max = 2018,
                  value = 2014),
      
      # Select Heart Disease or Stroke
      radioButtons(inputId = "Disease", label = "Select Disease Displayed",
                   choices = c("Heart Disease", "Stroke"),
                   selected = "Heart Disease"),
      
      # Select Gender
      radioButtons(inputId = "Gender", label = "Select Gender",
                   choices = unique(hd_mortality_combined$Gender),
                   selected = "Overall"),
      
      # Select State
      selectInput(inputId = "State", label = "Select State",
                  choices = unique(hd_mortality_combined$State), 
                  selected = "WA")
      
    ),
    
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("Overview",titlePanel("Overview"), 
                           h4(textOutput("overview")), br(), 
                           img(src= 'overview-image.jpeg',height=300, width=600), br(),
                           img(src= 'heart-stroke.jpeg',height=200, width=300),
                           img(src= 'cardiovasculardisease.jpeg',height=200, width=300)),
                  tabPanel("Graph", 
                           titlePanel("Graph Visualizations"),
                           h4(textOutput("graphdesc")), br(),
                           plotOutput("plot"), br(),
                           plotOutput("plot1")
                           ),
                  tabPanel("Map",
                           titlePanel("Geographic Visualizations"),
                           h4(textOutput("mapdesc")), br(),
                           h4(strong(textOutput("label1"))),
                           plotlyOutput("map"), br(),
                           h4(strong(textOutput("label2"))),
                           leafletOutput("lmap")
                           ),
                  tabPanel("Disease Mortality Table",
                           titlePanel("Table Visualizations"),
                           h4(textOutput("tabledesc")), br(),
                           dataTableOutput("data"), br(),
                           titlePanel("Highest Rate of Mortality for Each Ethnicity"),
                           h4(textOutput("summary"))
                            ),
                  tabPanel("Insights",
                           titlePanel("Conclusions"),
                          h4(textOutput("conclusion")),br(),
                           plotOutput("lineplot"),
                          h4(textOutput("lineplot.desc"))),
                          
                  navbarMenu( "About Us",
                             tabPanel("Pablo Aguirre",
                                      titlePanel("Pablo Aguirre"),
                                      h4(textOutput("pablo")),
                                      img(src='pablo-image.jpg',height=142.24,width=106.68)),
                             
                             tabPanel( "Jennifer Morales",
                              titlePanel("Jennifer Morales"),
                             h4(textOutput("jennifer")),
                             img(src='jennifer-image.jpg', height=142.24, width=106.68)),
                  
                             tabPanel("Ty Okazaki",
                              titlePanel("Ty Okazaki"),
                              h4(textOutput("ty")),
                              img(src='yumi.JPG', height=300, width=400))
                  
                          )
                 )
            )
        )
)