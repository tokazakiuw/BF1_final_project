# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)
library(maps)

## Create Directory for Data Sets
dir.create("shinyApp/data", showWarnings=FALSE)

## Create Sub-directories for Data Sets
dir.create("shinyApp/data/Heart Disease", showWarnings = FALSE)
dir.create("shinyApp/data/Stroke", showWarnings = FALSE)

## Load Data Sets

## Stroke Mortality Data
## US Adults (35+) over date ranges
## 2017-2019 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2017-2019-d738a
stroke_mortality_18 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2017-2019.csv")
## 2016-2018 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2016-2018
stroke_mortality_17 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2016-2018.csv")
## 2015-2017 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-7086f
stroke_mortality_16 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2015-2017.csv")
## 2014-2016 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-d1212
stroke_mortality_15 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County 2015.csv")
## 2013-2015 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-dd9dc
stroke_mortality_14 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County (2).csv")

## Heart Disease Mortality Data
## US Adults (35+) over date ranges
## 2017-2019 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2017-2019-6c0b7
hd_mortality_18 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2017-2019.csv")
## 2016-2018 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2016-2018
hd_mortality_17 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2016-2018 (1).csv")
## 2015-2017 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-8fd97
hd_mortality_16 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2015-2017.csv")
## 2014-2016 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-e5faa
hd_mortality_15 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County 2015.csv")
## 2013-2015 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-f139d
hd_mortality_14 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County.csv")

## Consolidate Data by Merging Over Year Range
## Stroke Mortality Merge
stroke_mortality_combined <- bind_rows(stroke_mortality_14, stroke_mortality_15, stroke_mortality_16, stroke_mortality_17, stroke_mortality_18)

## Heart Disease Mortality Merge
hd_mortality_combined <- bind_rows(hd_mortality_14, hd_mortality_15, hd_mortality_16, hd_mortality_17, hd_mortality_18)


# Type Conversion
# Convert Year from character type to numeric type
chd_stroke_data$Year <- as.numeric(chd_stroke_data$Year)
chd_stroke_data <- na.omit(chd_stroke_data)
unique(chd_stroke_data$Year)

## Clean Heart Disease Mortality Data
# Separate Location.1 Latitude and Longitude

## Data Cleaning

hd_mortality_combined <- hd_mortality_combined %>% 
  group_by(LocationAbbr, LocationDesc) %>% 
  fill(Y_lat, .direction = "downup") %>% 
  fill(X_lon, .direction = "downup")

county <- map_data("county")
