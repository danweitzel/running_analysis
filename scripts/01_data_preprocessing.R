#####################################################################################
##
##    File Name:        01_data_preprocessing.R
##    Date:             2021-02-12
##    Author:           Daniel Weitzel
##    Email:            weitzel.daniel@gmail.com
##    Webpage:          www.danweitzel.net
##    Purpose:          Preprocessing raw Garmin run data for analysis 
##    Date Used:        2021-02-12
##    Data Used:        garmin.csv (excluded from repo)
##    Output File:      (none)
##    Data Output:      (none)
##    Data Webpage:     (none)
##    Log File:         (none)
##    Notes:            Data is not included in public repo for privacy reasons.
##
#####################################################################################

## Set the working directory
setwd(githubdir)
setwd("running_analysis")

## Load the libraries
library("tidyverse")
library("lubridate")

## Load the data and preprocess it
## Variable names are all uppercase and include spaces, reduce data to only Running,
## and clean up the variables of interest + generate date variables for plot and regression
df_garmin <- read_csv("data/garmin.csv") %>% 
  select_all(~gsub("\\s+|\\.", "_", .)) %>% 
  select_all(tolower) %>% 
  filter(activity_type == "Running") %>% 
  separate(date, into = c("date", "time"), sep = " ") %>% 
  mutate_all(str_replace_all, ",|:", ".") %>% 
  mutate(across(c(distance, avg_pace, avg_hr, elev_gain, calories), as.numeric),
         date = ymd(date), 
         year =  year(date),
         month = month(date),
         year_month =  ym(paste(year, month)),
         month_char = lubridate::month(as.numeric(month), label = TRUE)) %>% 
  filter(distance > 0.99)
