# Running Analysis

<p align="center">
<img src="figures/monthly_avg_pace_over_time.png" width="800">
</p>

## Description
This repository holds an analysis of my running habits and development. The goal of this project is to motivate me with numbers that interest me. The data analyzed here was collected from my Garmin watches and hence it only includes runs that I logged on those. The analysis focuses only on runs and does not include bike rides, swims, and any brick workouts. 

## Content
1. The [01_data_preprocessing.R](./scripts/01_data_preprocessing.R) script, which prepares the downloaded Garmin data for analysis. The script is called with `source()` in all other scripts. 
2. The [02_data_visualization.R](./scripts/02_data_visualization.R) script, which produces a series of plots of quantities that I am interested in. Among those are over time developments of my average pace of my runs, running distance, and elevation gain. I am also interested in the relationship between heart rate, pace, and distance. Figures are stored in the [figures](./figures/) folder.
3. The [03_data_analysis.R](./scripts/03_data_analysis.R) script, which analyzes the data with statistical models

## Visual Analysis

I was wondering how much I've been running over time and how my current running habits compare to those of previous years. The figure below is the cumulative running distance in each month. The gray lines are past years, the red line is 2021. This ought to motivate me to keep running and beat past years. *This figure will be updated monthly.*

<p align="center">
<img src="figures/monthly_distance_cumulative.png" width="650">
</p>


A second metric that I am interested in is my average monthly pace (how many minutes I need per kilometer). How fast are the runs that I am doing? The figure below shows my monthly average pace (lower is faster) over time. The size and color of the dots indicate the number of runs (larger and brighter means more). With the preparation for the Austin Halfironman in 2019 the training got a lot more structured and the variability of my average pace dropped. 

<p align="center">
<img src="figures/monthly_avg_pace_over_time.png" width="650">
</p>


I am also interested in what type of distances I run. Most of my runs are either part of a Garmin Training Plan or runs with my wife or friends. The distances have been rounded to full kilometers for better visualization. Apparently I have a lot of runs between 5k and 10k and then fewer runs between 10k and up to the marathon distance. 

<p align="center">
<img src="figures/histogram_distance.png" width="650">
</p>


Based on the separation in the frequency of distances in the histogram above I set out to examine the relationship between running distance and a) heart rate and b) pace. 

Looking first at heart rate: For runs up to 10km we have a steep increase in my average heart rate with each additional kilometer. Going through entries in the data it becomes clear that the shorter runs in this subset are recovery runs and runs with friends and the runs closer to 10k are predominantly interval sessions and tempo runs from the Garmin Training Plan. That would explain the observed relationship pretty well. The relationship between average heart rate and running distance disappears for runs that are longer than 10km. Apparently, I'm able to find a rhythm in longer runs that I've no problems keeping up for some time. 

<p align="center">
<img src="figures/relationship_heartrate_distance.png" width="650">
</p>

Now looking at average pace: Here we can see a similar story as in the previous figure. In the sub 10km section the shorter runs are the slower and more relaxed recovery runs, while the longer runs are the sessions with a lot of effort. For distances larger than 10km there is a decrease in my running pace over time. However, the 7:30 average pace marathon was the Austin Marathon that I completed with my wife. Removing this outlier flattens the line of best fit substantially and the relationship between distance and pace disappears. 

<p align="center">
<img src="figures/relationship_pace_distance.png" width="650">
</p>

## Regression Analysis

After the visual examination of the data and a graphical representation of key relationships I was curious about I ran five regression models, shown in Table 1 below. All models are ordinary least squares regressions. In the first column I examine if my running distance has changed over the years. There coefficient is for the *year* variable is positive and weakly (.1) statistically significant. There seems to be some increase in the length of my runs over time. Columns 2 and 3 examine the factors that explain variability in my heart rate for each run. First, I look at the bivariate relationship between average heart rate and average pace. The relationship between the two variables is rather strong and highly statistically significant. For every minute additional minute that it takes me to run one kilometer my average heart rate goes down by 11.77 beats per minute. This relationship between average heart rate and average pace holds even if I control for year, distance, and elevation gain of the run. Something to be happy about: the coefficient for year is negative and statistically significant. As time advances I have become fitter! 

In column four I look at the factors that explain variation in my average pace. Two factors seems to play a role: 1) over time I have become faster and 2) as the distance increases my pace goes down. Lastly, in column 5 I take a look at the estimated calories that each run burned. What explains variation here? The average pace plays an important role: For every additional minute I need for one kilometer the estimated calories go down by 27.51. Each additional meter in elevation that I gain burns an additional 1.04 calories. The distance I ran does not, after controlling for pace and elevation, explain variation in the calories I burn during a run. 

<p align="center">
<img src="figures/regression.png" width="650">
</p>



