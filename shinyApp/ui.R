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
  titlePanel("Cardiovascular Diseases in the U.S"),
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
                  selected = "WA"),
      
    ),
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("Overview",titlePanel("Overview"), textOutput("overview"), 
                           img(src= 'overview-image.jpeg',height=200, width=400)),
                  navbarMenu("About Us",
                             tabPanel("Pablo Aguirre",
                                      titlePanel("Pablo Aguirre"),
                                      textOutput("pablo"),
                                      img(src='pablo-image.jpg',height=142.24,width=106.68)),
                             tabPanel("Jennifer Morales"),
                             tabPanel("Ty Okazaki")),
                  tabPanel("Graph", 
                           titlePanel("Graph Visualizations"),
                           textOutput("graphdesc"),
                           plotOutput("plot"),
                           plotOutput("plot1"),
                           ),
                  tabPanel("Map",
                           titlePanel("Geographic Visualizations"),
                           textOutput("mapdesc"),
                           h4(strong(textOutput("label1"))),
                           plotlyOutput("map"),
                           h4(strong(textOutput("label2"))),
                           leafletOutput("lmap")
                           ),
                  tabPanel("Disease Mortality Table",
                           titlePanel("Table Visualizations"),
                           textOutput("summary"),
                           textOutput("tabledesc"),
                           dataTableOutput("data"),
                            ),
                  tabPanel("Insights", titlePanel("Conclusions"),textOutput("conclusion"))
                  
      )
    )
  )
)
