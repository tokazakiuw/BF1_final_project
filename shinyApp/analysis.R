# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(tidyverse)
library(tidyr)

## Create Directory for Data Sets
dir.create("shinyApp/data", showWarnings=FALSE)

## Create Sub-directories for Data Sets
dir.create("shinyApp/data/Heart Disease", showWarnings = FALSE)
dir.create("shinyApp/data/Stroke", showWarnings = FALSE)

## Load Data Sets

## Coronary Heart Disease and Stroke Mortality Data
## US Adults (35+); years: 1999-2018
## Accessed via https://catalog.data.gov/dataset/rates-and-trends-in-coronary-heart-disease-and-stroke-mortality-data-among-us-adults-1999--c8032
chd_stroke_data <- read.csv("data/Rates_and_Trends_in_Coronary_Heart_Disease_and_Stroke_Mortality_Data_Among_US_Adults__35___by_County___1999-2018.csv")

## Behavioral Risk Factor Surveillance System
## National Cardiovascular Disease Surveillance Data
## Accessed via https://catalog.data.gov/dataset/behavioral-risk-factor-surveillance-system-brfss-national-cardiovascular-disease-surveilla-2b1fc
brfss_data <- read.csv("data/Behavioral_Risk_Factor_Surveillance_System__BRFSS__-__National_Cardiovascular_Disease_Surveillance_Data.csv")

## Center for Medicare & Medicaid Services
## Medicare Claims data
## Accessed via https://catalog.data.gov/dataset/center-for-medicare-medicaid-services-cms-medicare-claims-data-b1571
cms_data <- read.csv("data/Center_for_Medicare___Medicaid_Services__CMS____Medicare_Claims_data.csv")

## National Health and Nutrition Examination Survey
## National Cardiovascular Disease Surveillance System
## Accessed via https://catalog.data.gov/dataset/national-health-and-nutrition-examination-survey-nhanes-national-cardiovascular-disease-su-00a88
nhanes_data <- read.csv("data/National_Health_and_Nutrition_Examination_Survey__NHANES__-_National_Cardiovascular_Disease_Surveillance_System.csv")

## National Vital Statistics System
## National Cardiovascular Disease Surveillance Data
## Accessed via https://catalog.data.gov/dataset/national-vital-statistics-system-nvss-national-cardiovascular-disease-surveillance-data-ba4cb
nvss_data <- read.csv("data/National_Vital_Statistics_System__NVSS__-_National_Cardiovascular_Disease_Surveillance_Data.csv")

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
hd_mortality_1719 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2017-2019.csv")
## 2015-2017 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-8fd97
hd_mortality_1517 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2015-2017.csv")
## 2013-2015 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-f139d
hd_mortality_1315 <- read.csv("data/Heart Disease/Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County.csv")

## Consolidate Data by Merging Over Year Range
## Stroke Mortality Merge

## Heart Disease Mortality Merge