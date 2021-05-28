# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)
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
                  min = 2014, max = 2018,
                  value = 2014),
      
      # Select State
      selectInput(inputId = "State", label = "Select State",
                  choices = unique(hd_mortality_combined$LocationAbbr),
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