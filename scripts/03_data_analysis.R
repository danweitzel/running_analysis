#####################################################################################
##
##    File Name:        03_data_analysis.R
##    Date:             2021-02-12
##    Author:           Daniel Weitzel
##    Email:            weitzel.daniel@gmail.com
##    Webpage:          www.danweitzel.net
##    Purpose:          Generate qucik data anlysis of running data that I'm interested in
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
library("texreg")
library("corrplot")

## Reduce data frame to variables used in the analysis
df_analysis <-
  df_garmin %>% 
  dplyr::select(distance, year, avg_pace, avg_hr, elev_gain, calories)



## Quick checks of all variables 
## First distributions of all variables
qplot(df_analysis$distance)
qplot(df_analysis$year)
qplot(df_analysis$avg_pace)
qplot(df_analysis$avg_hr)
qplot(df_analysis$elev_gain)
qplot(df_analysis$calories)

## Second correlations
## Heart rate and pace have a very strong correlation with each other.
res <- cor(df_analysis, use = "complete.obs")
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)


# Model 1: Has the distance changed over time?
lm1 <- lm(distance ~ year, data = df_analysis)

# Model 2: What explains variation in my avg. heart rate? Bivariate model with pace
lm2 <- lm(avg_hr ~ avg_pace, data = df_analysis)

# Model 3: What explains variation in my avg. heart rate? Multivariate model with other covariates
# Unfortunately I don't have weather 
lm3 <- lm(avg_hr ~ distance + avg_pace + elev_gain + year, data = df_analysis)

# Model 4: What explains variation in my average pace?
lm4 <- lm(avg_pace ~ distance + elev_gain + year, data = df_analysis)

# Model 5: What explains variation in my estimated calories for the run
lm5 <- lm(calories ~ distance + avg_pace + elev_gain + year, data = df_analysis)

## Examine results in R
screenreg(list(lm1, lm2, lm3, lm4, lm5),
          custom.model.names = c("Distance", "Avg. HR", "Avg. HR", "Avg. Pace", "Calories"),
          #custom.coef.names = c("Intercept", "Year", "Avg. Pace", "Distance", "Elevation Gain"),
          omit.coef = "Intercept")

## Export table to Latex
texreg(list(lm1, lm2, lm3, lm4, lm5),
          custom.model.names = c("Distance", "Avg. HR", "Avg. HR", "Avg. Pace", "Calories"),
          custom.coef.names = c("Intercept", "Year", "Avg. Pace", "Distance", "Elevation Gain"),
          omit.coef = "Intercept",
          file="tables/regression.tex", 
          caption="Regression models", 
          caption.above = TRUE,
          custom.note = "All models are ordinary least squares regressions.",
          include.rs=TRUE, 
          include.adjrs = FALSE,
          digits=2,
          stars=c(0.01, 0.05, 0.1))

# clean up
rm(df_analysis, lm1, lm2, lm3, lm4, lm5)

# fin