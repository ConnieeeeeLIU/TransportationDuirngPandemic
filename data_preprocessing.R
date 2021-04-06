library(tidyverse)
library(zipcode)
library(covid19.analytics)
library(coronavirus)

# Load original data of daily transportation from BTS (2019-01-01~2021-03-20)
raw_data <- readr::read_csv("data/raw/Trips_by_Distance.csv", 
                            col_types = cols(
  .default = col_double(),
  Level = col_character(),
  Date = col_date(format = ""),
  `State FIPS` = col_character(),
  `State Postal Code` = col_character(),
  `County FIPS` = col_character(),
  `County Name` = col_character(),
  `Row ID` = col_character()
))

raw_data <- dplyr::filter(raw_data, Date >= "2019-04-01")

# Extract national level time series data
national_data <- dplyr::filter(raw_data, Level == "National")
write.csv(national_data, "data/clean/National.csv")

# Extract state level data and put them in a folder by state
state_data <- dplyr::filter(raw_data, Level == "State")
state <- c(state.abb)
for (s in state){
  tmp_data = dplyr::filter(state_data, `State Postal Code` == s)
  csvFileName = paste(c("data/clean/state/", s, ".csv"), collapse = "")
  write.csv( tmp_data, file = csvFileName)
}

# Extract county level data and put them in a folder by state
county_data <- dplyr::filter(raw_data, Level == "County")
state <- c(state.abb)
for (s in state){
  tmp_data = dplyr::filter(county_data, `State Postal Code` == s)
  csvFileName = paste(c("data/clean/county/", s, ".csv"), collapse = "")
  write.csv( tmp_data, file = csvFileName)
}

# Load original data of different transportation methods from BTS (2019-04-01~2021-03-01)
# but data of 2021-03-01 is not recorded yet
raw_data <- readr::read_csv("data/raw/Monthly_Transportation_Statistics.csv")
raw_data$Date <- substr(raw_data$Date, 1, 10)
raw_data$Date <- as.Date(raw_data$Date, format = "%m/%d/%Y")

# Read covid19 data from packages directly
covid_data <- covid19.data()
covid_data <- dplyr::filter(covid_data, Country_Region == "US")
