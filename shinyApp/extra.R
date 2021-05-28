## Extra Libraries
library(sf)

## Extra Datasets

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

## Extra Code
# Type Conversion
# Convert Year from character type to numeric type
chd_stroke_data$Year <- as.numeric(chd_stroke_data$Year)
chd_stroke_data <- na.omit(chd_stroke_data)
unique(chd_stroke_data$Year)

## Clean Heart Disease Mortality Data

## NOTES - DEBUGGING CODE
## Single Row
test1_df <- hd_mortality_combined %>% 
  filter(Year == 2014 & LocationDesc == "Polk County" & Data_Value == "486.3") %>% 
  select(Location.1)
## Separate Location.1
test1_df <- test1_df %>%
  separate(Location.1, c("sample_x", "sample_y"), ", ")
## Filter out first character
test1_df$sample_x <- gsub("^.", "", test1_df$sample_x)
## Filter out last character
test1_df$sample_y <- gsub(".$", "", test1_df$sample_y)

## Using County from Maps Library
mergeCounty <- map_data("county")
mergeCounty$subregion <- paste(mergeCounty$subregion, "County")
mergeCounty$subregion <- str_to_title(mergeCounty$subregion)
mergeCounty <- mergeCounty %>% 
  select(long, lat, subregion, region)
## Check Unique Values
unique(mergeCounty$subregion)
unique(hd_mortality_combined$LocationDesc)

## Separate Location.1 Latitude and Longitude
hd_mortality_combined$Location.1 <-  gsub("^.|.$", "", hd_mortality_combined$Location.1)
## Separate Location.1
hd_mortality_combined <- hd_mortality_combined %>%
  separate(Location.1, c("Y_lat1", "X_lon1"), ", ")
## Unique Values
test2 <- hd_mortality_combined %>% 
  filter(LocationDesc == "Juneau") %>% 
  fill(Y_lat, .direction = "downup") %>% 
  fill(X_lon, .direction = "downup")

## Convert to Numeric Value 
hd_mortality_combined$Y_lat <- as.numeric(hd_mortality_combined$Y_lat)
hd_mortality_combined$X_lon <- as.numeric(hd_mortality_combined$X_lon)

## County Code
## County Boundary File
## https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
UScounty <- st_read(dsn = "data/cb_2018_us_county_500k/cb_2018_us_county_500k.shp")
colnames(UScounty)[colnames(UScounty) == "GEOID"] <- "LocationID"
UScounty$LocationID <- as.numeric(UScounty$LocationID)
## Merge with County Boundary Data
hd_mortality <- left_join(hd_mortality_combined, UScounty, by = "LocationID")