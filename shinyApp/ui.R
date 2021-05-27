# Load Packages
library(shiny)
library(leaflet)
library(tidyverse)
library(maps)

# Load Data
cat("--working dir", getwd(), "\n")


# Source Data 
source("analysis.R")

# Define UI

ui <- fluidPage(
  titlePanel("Insert Title Here"),
  sidebarLayout(
    sidebarPanel(
      
      # Select Year Range
      sliderInput(inputId = "Year", label = "Select Year Range",
                  min = min(chd_stroke_data$Year), max = max(chd_stroke_data$Year),
                  value = c(min(chd_stroke_data$Year), max(chd_stroke_data$Year)),
                  sep = ""),
      
      # Select State
      selectInput(inputId = "State", label = "Select State",
                  choices = unique(chd_stroke_data$LocationAbbr),
                  selected = "WA"),
      
    ),
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("Graph", plotOutput("plot")),
                  tabPanel("Map", leafletOutput("map")),
                  tabPanel("Table", tableOutput("table")),
                  tabPanel("Summary", textOutput("summary")),
                  tabPanel("About Us", textOutput("about_us")),
                  tabPanel("Sources", textOutput("sources"))
                  )
      
      
    )
  )
)