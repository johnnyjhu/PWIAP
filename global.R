library(dplyr)
library(ggplot2)
library(readxl)
library(zipcode)
library(dplyr)
library(lubridate)
library(ggmap)
library(shinythemes)
library(shinydashboard)

# Pre-load gmap
la_gmap = qmap("Los Angeles", zoom = 10, color = "bw")

# Read all datasets and files from folder
data <- read_excel("Public%forArt-DataScienceChallenge-20161202.xlsx.xlsx")
data_address <- read_excel("PWIAP Data Science Facility Address.xlsx")
data_income <- read_excel("acs2015_5yr_income.xlsx")
data_age <- read_excel("data_age.xlsx")
edudata = read.csv("education.csv")
la_zipcode = read.csv("losangeleszip.csv")

# Rename column name
colnames(data) <- c("Project_Name",
                    "Agency",
                    "Project_ZIP",
                    "Project_CD",
                    "Status",
                    "Artist_ZIP",
                    "Project_Start_Date",
                    "Full_1p_Amount",
                    "Art_Contract",
                    "Art_Contract_Start",
                    "Community_Meeting_Date",
                    "End_Date")

colnames(data_address) <- c("Pro_Name",
                            "Google_Map_Address",
                            "Pro_ZIP")
# Remove NA projects
data = filter(data, !is.na(data$Project_Name))

data$Project_Start_Date = as.numeric(data$Project_Start_Date)
data$Project_Start_Date = as.Date(data$Project_Start_Date, origin = "1899-12-30")
data$End_Date = ymd(data$End_Date)
data$End_Year = year(data$End_Date)
data$Month = month(data$Project_Start_Date, label=T, abbr=T)

# Join two data frames
data = merge(x = data,
             y = data_address,
             by.x = "Project_Name",
             by.y = "Pro_Name",
             all.x = TRUE)

# Remove duplicated data (bug from merge???)
data <- unique(data[1:nrow(data), ])

# Add zipcode to address
data <- within(data, 
               Complete_Address <- ifelse(!is.na(Google_Map_Address), 
                                          paste(data$Google_Map_Address, data$Pro_ZIP, sep = ", CA "), 
                                          NA)
)

# Add zipcode to address
#data$Google_Map_Address = paste(data$Google_Map_Address, data$Pro_ZIP, sep = ", CA ")

#data$Complete_Address[!is.na(data$Google_Map_Address)] = paste(data$Google_Map_Address, data$Pro_ZIP, sep = ", CA ")

# Filter out NA and create data_address for plot
data_address = filter(data, !is.na(data$Complete_Address))

# Get location longitude and latitude
#data_address$Pro_Location = geocode(data_address$Complete_Address)

# Save data_address
#save(data_address, file = "data_address.rda")
load("data_address.rda")

data_address$Pro_Location_lon = data_address$Pro_Location[,1]
data_address$Pro_Location_lat = data_address$Pro_Location[,2]
data_address$Pro_Location = NULL


data("zipcode")

zip_ca <- zipcode %>%
  filter(state == "CA")

#Join income data frames with zipcode
data_income = merge(x = data_income,
                    y = zip_ca,
                    by.x = "zip",
                    by.y = "zip",
                    all.x = T)


# Get agency_income for bar chart
agency_income = merge(x = data_address,
                      y = data_income,
                      by.x = "Project_ZIP",
                      by.y = "zip",
                      all.x = T)

agency_income = agency_income %>%
  group_by(Agency) %>%
  summarise(avg_income = round(mean(Average_Income),2)) %>%
  filter(!is.na(avg_income))

# Get data_age
data_age = merge(x = data_age,
                 y = zip_ca,
                 by.x = "zip",
                 by.y = "zip",
                 all.x = T)

max_age = max(data_age$Average_Age)

# Bar chart of age
agency_age = merge(x = data_address,
                   y = data_age,
                   by.x = "Project_ZIP",
                   by.y = "zip",
                   all.x = T)

agency_age = agency_age %>%
  group_by(Agency) %>%
  summarise(avg_age = round(mean(Average_Age),2)) %>%
  filter(!is.na(avg_age))

# Get art_map
art_map = merge(x = la_zipcode, 
                y = data,
                by.x = "zip_code", 
                by.y = "Project_ZIP",
                all.x = T)

# Get edu_map
edu_map = merge(x = edudata,
                y = zip_ca,
                by.x = "name",
                by.y = "zip",
                all.x = T)

edu_map = edu_map %>%
  mutate(edu_index = high_school_graduate+bachelor+master+doctorate)

# Calculate data_delta_money
data_delta_money = data %>%
  mutate(delta = Full_1p_Amount - Art_Contract) %>%
  filter(!is.na(delta)) %>%
  arrange(delta)

# Calculate number_of_delta_money for ui.R
number_of_delta_money = nrow(data_delta_money)
