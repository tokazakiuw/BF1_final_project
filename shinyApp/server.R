# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(tidyverse)

# Load Data
cat("--working dir", getwd(), "\n")
chd_stroke_data <- read.csv("shinyApp/data/Rates_and_Trends_in_Coronary_Heart_Disease_and_Stroke_Mortality_Data_Among_US_Adults__35___by_County___1999-2018.csv")
brfss_data <- read.csv("shinyApp/data/Behavioral_Risk_Factor_Surveillance_System__BRFSS__-__National_Cardiovascular_Disease_Surveillance_Data.csv")
cms_data <- read.csv("shinyApp/data/Center_for_Medicare___Medicaid_Services__CMS____Medicare_Claims_data.csv")
nhanes_data <- read.csv("shinyApp/data/National_Health_and_Nutrition_Examination_Survey__NHANES__-_National_Cardiovascular_Disease_Surveillance_System.csv")
nvss_data <- read.csv("shinyApp/data/National_Vital_Statistics_System__NVSS__-_National_Cardiovascular_Disease_Surveillance_Data.csv")

# Define Server

