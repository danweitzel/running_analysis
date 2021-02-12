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




