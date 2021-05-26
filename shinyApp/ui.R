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

# Define UI

ui <- fluidPage(
  titlePanel("Insert Title Here"),
  sidebarLayout(
    sidebarPanel(
      
      #
      
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