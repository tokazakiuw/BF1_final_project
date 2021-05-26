# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(tidyr)

## Create Directory for Data Sets
dir.create("data", showWarnings=FALSE)

## Create Sub-directories for Data Sets
dir.create("data/Heart Disease", showWarnings = FALSE)
dir.create("data/Stroke", showWarnings = FALSE)

## Load Data Sets

## Coronary Heart Disease and Stroke Mortality Data
## US Adults (35+); years: 1999-2018
## Accessed via https://catalog.data.gov/dataset/rates-and-trends-in-coronary-heart-disease-and-stroke-mortality-data-among-us-adults-1999--c8032
chd_stroke_data <- read.csv("data/Rates_and_Trends_in_Coronary_Heart_Disease_and_Stroke_Mortality_Data_Among_US_Adults__35___by_County___1999-2018.csv")

## Stroke Mortality Data
## US Adults (35+) over date ranges
## 2017-2019 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2017-2019-d738a
stroke_mortality_1719 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2017-2019.csv")
## 2015-2017 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-7086f
stroke_mortality_1517 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2015-2017.csv")
## 2013-2015 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-dd9dc
stroke_mortality_1315 <- read.csv("data/Stroke/Stroke_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County (2).csv")

## Heart Disease Mortality Data
## US Adults (35+) over date ranges
## 2017-2019 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2017-2019-6c0b7
hd_mortality_1719 <- read.csv("data/Heart Disease/")
## 2015-2017 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-8fd97
hd_mortality_1517 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2015-2017.csv")
## 2013-2015 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-f139d
hd_mortality_1315 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County.csv")