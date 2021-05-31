# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)
library(DT)
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
                  tabPanel("Graph", plotOutput("plot")),
                  tabPanel("Map",
                           h4(strong(textOutput("label1"))),
                           plotlyOutput("map"),
                           h4(strong(textOutput("label2"))),
                           leafletOutput("lmap")),
                  tabPanel("Disease Mortality Table", dataTableOutput("data")),
                  tabPanel("Summary", textOutput("summary")),
                  tabPanel("About Us", textOutput("about_us")),
                  tabPanel("Sources", textOutput("sources"))
                  )
    )
  )
)
