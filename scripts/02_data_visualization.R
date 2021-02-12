#####################################################################################
##
##    File Name:        02_data_visualization.R
##    Date:             2021-02-12
##    Author:           Daniel Weitzel
##    Email:            weitzel.daniel@gmail.com
##    Webpage:          www.danweitzel.net
##    Purpose:          Generate visualizations of running data that I'm interested in
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

## Load the preprocessed data 
source("scripts/01_data_preprocessing.R")

## Load the library
library("tidyverse")

### Generate the data visualizations that I want 
### This includes running distance and elevation over the years as well as 
### the relationship between pace, distance, and heart rate 

## Plot 1: Monthly running distance over the years
df_garmin %>% 
  dplyr::select(year, month_char, distance) %>% 
  group_by(year, month_char) %>% 
  dplyr::summarize(total_distance = sum(distance)) %>% 
  ungroup() %>%
  ggplot(aes(x = month_char, y = total_distance, group = year, 
             color = as.factor(year))) +
    geom_point() + geom_line() + facet_wrap(~year, nrow = 2) +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45),  legend.position = "none") +
  labs(x = "Month", y = "Distance, km", 
       title = "Monthly running distance over the years")
ggsave("figures/monthly_distance_over_time.png",
       width = 14, height = 7, dpi = 150, device='png')

## Plot 2: Cumulative distance in one plot - COLOR
df_garmin %>% 
  dplyr::select(year, month_char, distance) %>% 
  group_by(year, month_char) %>% 
  dplyr::summarize(monthly_distance = sum(distance)) %>% 
  group_by(year) %>% 
  mutate(total_distance = cumsum(monthly_distance)) %>% 
  ungroup() %>% 
  ggplot(aes(x=month_char, y=total_distance, color = factor(year), group = year)) + 
  geom_line() +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45)) + 
  labs(x = "Month", y = "Running distance in meter", color = "Year",
       title = "Cumulative running distance")

## Plot 3: Cumulative distance in one plot - GRAY AND RED
df_garmin %>% 
  dplyr::select(year, month_char, distance) %>% 
  group_by(year, month_char) %>% 
  dplyr::summarize(monthly_distance = sum(distance)) %>% 
  group_by(year) %>% 
  mutate(total_distance = cumsum(monthly_distance),
         current = ifelse(year == 2021, "Yes", "No")) %>% 
  ungroup() %>% 
  ggplot(aes(x=month_char, y=total_distance, color = current, group = year)) + 
  geom_line() +
  scale_color_manual(values = c("Yes" = "red", "No" = "lightgray")) +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45), 
                          legend.position = "none") + 
  labs(x = "Month", y = "Running distance in meter", color = "Year",
       title = "Cumulative running distance",
       caption = "Note: Current year in red, all other years gray")
ggsave("figures/monthly_distance_cumulative.png",
       width = 7, height = 7, dpi = 150, device='png')

## Plot 4: Average pace over time 
df_garmin %>% 
  dplyr::select(year, month_char, avg_pace) %>% 
  group_by(year, month_char) %>% 
  dplyr::summarize(average_pace = mean(avg_pace), n_runs = n()) %>% 
  ungroup() %>%
  ggplot(aes(x = month_char, y = average_pace, group = year, color = n_runs)) +
  geom_point(aes(size = n_runs)) + facet_wrap(~year, nrow = 2) + geom_line() +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45), legend.position = "none") +
  labs(x = "Month", y = "Average pace, minutes/km", 
       title = "Monthly average running pace over the years",
       caption = "Note: Runs range from 5 to 20 a month")
ggsave("figures/monthly_avg_pace_over_time.png",
       width = 14, height = 7, dpi = 150, device='png')

## Plot 5: Correlation between hr and pace
df_garmin %>% 
  filter(avg_pace < 10) %>% 
  dplyr::select(avg_pace, avg_hr) %>% 
  ggplot(aes(y = avg_hr, x = avg_pace)) +
  geom_point() + geom_smooth(method = "lm") +
  theme_minimal() + theme(legend.position = "none") +
  labs(x = "Average pace, minutes/km", y = "Average heart rate, bpm", 
       title = "Relationship between heart rate and pace")


## Plot 7: Histogram of distance rounded to full km
df_garmin %>% 
  dplyr::select(year, distance) %>% 
  mutate(distance = round(distance, digits = 0)) %>% 
  ggplot(aes(x = distance)) +
  geom_bar() + theme_minimal() +
  labs(title = "Histogram of running distance", x = "Distance", y = "Count",
       caption = "Note = Distances are rounded to kilometers")
ggsave("figures/histogram_distance.png",
       width = 10, height = 7, dpi = 150, device='png')
  
## Plot 8: Correlation between hr and distance
## Based on the drop in the histogram at the 10km mark I am examining differences
## between runs up to 10k and below
df_garmin %>% 
  dplyr::select(avg_hr, distance) %>% 
  mutate(km10 = ifelse(distance > 10.5, TRUE, FALSE)) %>% 
  ggplot(aes(y = avg_hr, x = distance, color = km10)) +
  geom_point() + geom_smooth(aes(group=km10), method = "lm", se=TRUE) +
  theme_minimal() + theme(legend.position = "none") +
  labs(x = "Distance in km", y = "Average heart rate, bpm", 
       title = "Relationship between heart rate and running distance")
ggsave("figures/relationship_heartrate_distance.png",
       width = 10, height = 7, dpi = 150, device='png')

## Plot 9: Correlation between pace and distance
## Based on the drop in the histogram at the 10km mark I am examining differences
## between runs up to 10k and below
df_garmin %>% 
  filter(avg_pace < 10) %>% 
  dplyr::select(avg_pace, distance) %>% 
  mutate(km10 = ifelse(distance > 10.5, TRUE, FALSE)) %>% 
  ggplot(aes(y = avg_pace, x = distance, color = km10)) +
  geom_point()+ geom_smooth(aes(group=km10), method = "lm") +
  theme_minimal() + theme(legend.position = "none") + 
  labs(x = "Distance in km", y = "Average pace, m/km", 
       title = "Relationship between average running pace and running distance")
ggsave("figures/relationship_pace_distance.png",
       width = 10, height = 7, dpi = 150, device='png')

## Plot 10: Cumulative elevation
df_garmin %>% 
  dplyr::select(year, month_char, elev_gain) %>% 
  group_by(year, month_char) %>% 
  dplyr::summarize(monthly_elev = sum(elev_gain)) %>% 
  group_by(year) %>% 
  mutate(total_elev = cumsum(monthly_elev)) %>% 
  ungroup() %>% 
  ggplot(aes(x=month_char, y=total_elev, color = factor(year), group = year)) + 
  geom_line() +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45)) + 
  labs(x = "Month", y = "Elevation gain in meter", color = "Year",
       title = "Cumulative monthly elevation gain")



