# Load Packages
library(shiny)
## library(dplyr)
## library(ggplot2)
library(leaflet)
library(tidyverse)
## library(tidyr)
## library(stringr)


## Create Directory for Data Sets
dir.create("shinyApp/data", showWarnings=FALSE)

## Create Sub-directories for Data Sets
dir.create("shinyApp/data/Heart Disease", showWarnings = FALSE)
dir.create("shinyApp/data/Stroke", showWarnings = FALSE)

## Load Data Sets

## Stroke Mortality Data
## US Adults (35+) over date ranges
## 2017-2019 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2017-2019-d738a
stroke_mortality_18 <- read.csv("data/Stroke/Stroke___2017-2019.csv.bz2")
## 2016-2018 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2016-2018
stroke_mortality_17 <- read.csv("data/Stroke/Stroke_2016-2018.csv.bz2")
## 2015-2017 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-7086f
stroke_mortality_16 <- read.csv("data/Stroke/Stroke_2015-2017.csv.bz2")
## 2014-2016 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-d1212
stroke_mortality_15 <- read.csv("data/Stroke/Stroke_2015.csv.bz2")
## 2013-2015 via https://catalog.data.gov/dataset/stroke-mortality-data-among-us-adults-35-by-state-territory-and-county-dd9dc
stroke_mortality_14 <- read.csv("data/Stroke/Stroke_(2).csv.bz2")

## Consolidate Data by Merging Over Year Range
## Stroke Mortality Merge
stroke_mortality_combined <- bind_rows(stroke_mortality_14, stroke_mortality_15, stroke_mortality_16, stroke_mortality_17, stroke_mortality_18) %>% 
  select(-Class, -Topic, -Data_Value_Unit, -Data_Value_Type, -Data_Value_Footnote_Symbol, -Data_Value_Footnote)
rm(stroke_mortality_14, stroke_mortality_15, stroke_mortality_16, stroke_mortality_17, stroke_mortality_18)
gc()
## Heart Disease Mortality Data
## US Adults (35+) over date ranges
## 2017-2019 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2017-2019-6c0b7
hd_mortality_18 <- read.csv("data/Heart Disease/hd2018.csv.bz2")
## 2016-2018 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2016-2018
hd_mortality_17 <- read.csv("data/Heart Disease/hd2017.csv.bz2")
## 2015-2017 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-2015-2017-8fd97
hd_mortality_16 <- read.csv("data/Heart Disease/hd2016.bz2")
## 2014-2016 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-e5faa
hd_mortality_15 <- read.csv("data/Heart Disease/hd2015.bz2")
## 2013-2015 via https://catalog.data.gov/dataset/heart-disease-mortality-data-among-us-adults-35-by-state-territory-and-county-f139d
hd_mortality_14 <- read.csv("data/Heart Disease/hd2014.bz2")

## Heart Disease Mortality Merge
hd_mortality_combined <- bind_rows(hd_mortality_14, hd_mortality_15, hd_mortality_16, hd_mortality_17, hd_mortality_18) %>% 
  select(-Class, -Topic, -Data_Value_Unit, -Data_Value_Type, -Data_Value_Footnote_Symbol, -Data_Value_Footnote)
rm(hd_mortality_14, hd_mortality_15, hd_mortality_16, hd_mortality_17, hd_mortality_18)
gc()
print(object.size(hd_mortality_combined))

## Clean Heart Disease Mortality Data
# Separate Location.1 Latitude and Longitude

## Data Cleaning
hd_mortality_combined <- hd_mortality_combined %>% 
  group_by(LocationAbbr, LocationDesc) %>% 
  fill(Y_lat, .direction = "downup") %>% 
  fill(X_lon, .direction = "downup")
hd_mortality_combined$Data_Value <- as.numeric(hd_mortality_combined$Data_Value)
## Apply to Stroke
stroke_mortality_combined <- stroke_mortality_combined %>% 
  group_by(LocationAbbr, LocationDesc) %>% 
  fill(Y_lat, .direction = "downup") %>% 
  fill(X_lon, .direction = "downup")
stroke_mortality_combined$Data_Value <- as.numeric(stroke_mortality_combined$Data_Value)
#removing columns from hd_mortality_combined
hd_mortality_combined=subset(hd_mortality_combined, select = -c(DataSource, 
                              StratificationCategory1, StratificationCategory2,TopicID))
#removing columns from stroke_mortality_combined 
stroke_mortality_combined=subset(stroke_mortality_combined,select= -c(DataSource, 
                                    StratificationCategory1, StratificationCategory2,TopicID))
#renaming columns StratificationCategory1, StratificationCategory2, LocationAbbr from 
#hd_mortality_combined
hd_mortality_combined <- hd_mortality_combined %>% 
  rename(Gender = Stratification1,
         Ethnicity = Stratification2,
        State = LocationAbbr)
#renaming columns StratificationCategory1, StratificationCategory2, LocationAbbr from 
#stroke_mortality_combined
stroke_mortality_combined <- stroke_mortality_combined %>% 
  rename(Gender = Stratification1,
         Ethnicity = Stratification2,
         State = LocationAbbr)
#leaflet color palette
hd_pal <- colorNumeric("Set1", hd_mortality_combined$Data_Value)
stroke_pal <- colorNumeric("Set1", stroke_mortality_combined$Data_Value)

# Plotly Code
# Cleaning HD
hd_plotly <- hd_mortality_combined %>% 
  select(Year, State, LocationDesc, GeographicLevel, Data_Value, Gender, Ethnicity) %>% 
  filter(GeographicLevel == "State") %>% 
  mutate(hover = paste0(State, "\n", Data_Value, " Mortality Rate")) %>% 
  mutate(Rate = Data_Value)
# Cleaning Stroke
stroke_plotly <- stroke_mortality_combined %>% 
  select(Year, State, LocationDesc, GeographicLevel, Data_Value, Gender, Ethnicity) %>% 
  filter(GeographicLevel == "State") %>% 
  mutate(hover = paste0(State, "\n", Data_Value, " Mortality Rate")) %>% 
  mutate(Rate = Data_Value)
