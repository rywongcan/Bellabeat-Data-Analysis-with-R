Bellabeat Data Analysis with R
================

# Introduction

Welcome to the Bellabeat data analysis case study! Bellabeat is a
successful small company, but they have the potential to become a larger
player in the global smart device market. Urška Sršen, cofounder and
Chief Creative Officer of Bellabeat, believes that analyzing smart
device fitness data could help unlock new growth opportunities for the
company.

![](https://miro.medium.com/v2/resize:fit:624/1*EQeg_y74OZXgYsM8KHuJwA.png)

I am going to study regarding these three main questions in order to
provide better insight to Bellabeat. So that we can identify potential
avenues for expansion and propose ways to enhance Bellabeat’s marketing
strategy, drawing insights from current trends in the utilization of
smart devices.

**1. What are some trends in smart device usage?**

**2. How could these trends apply to Bellabeat customers?**

**3. How could these trends help influence Bellabeat marketing
strategy?**

# Loading packages

``` r
library("tidyverse") # for data manipulation, exploration and visualization
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.3     ✔ readr     2.1.4
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ## ✔ ggplot2   3.4.4     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library("janitor") #for examining and cleaning dirty data
```

    ## 
    ## Attaching package: 'janitor'
    ## 
    ## The following objects are masked from 'package:stats':
    ## 
    ##     chisq.test, fisher.test

``` r
library("lubridate") #for date & time formats
library("waffle") #for the waffle charts
```

# Importing datasets – Preparing Phase

As the cofounder of the Bellabeat encourages me to use public data that
explores smart device users’ daily habits. She points me to a specific
data set: [FitBit Fitness Tracker
Data](https://www.kaggle.com/datasets/arashnic/fitbit)

This Kaggle data set contains personal fitness tracker from thirty
fitbit users. Thirty eligible Fitbit users consented to the submission
of personal tracker data, including minute-level output for physical
activity, heart rate, and sleep monitoring. It includes information
about daily activity, steps, and heart rate that can be used to explore
users’ habits.

``` r
dailyactivity <- read.csv("../GitHub/Bellabeat-Data-Analysis-with-R/docs/dailyActivity_merged.csv")
heartrate_persecond <- read.csv("../GitHub/Bellabeat-Data-Analysis-with-R/docs/heartrate_seconds_merged.csv")
intensities <- read.csv("../GitHub/Bellabeat-Data-Analysis-with-R/docs/hourlyIntensities_merged.csv")
steps <- read.csv("../GitHub/Bellabeat-Data-Analysis-with-R/docs/hourlySteps_merged.csv")
sleep <- read.csv("../GitHub/Bellabeat-Data-Analysis-with-R/docs/sleepDay_merged.csv")
```

### Preview our datasets

After we import the datasets, lets take a brief look to preview them.

``` r
head(dailyactivity)
```

```
Description:df [6 × 15]
 
 
Id
<dbl>
ActivityDate
<chr>
TotalSteps
<int>
TotalDistance
<dbl>
TrackerDistance
<dbl>
LoggedActivitiesDistance
<dbl>
1	1503960366	4/12/2016	13162	8.50	8.50	0	
2	1503960366	4/13/2016	10735	6.97	6.97	0	
3	1503960366	4/14/2016	10460	6.74	6.74	0	
4	1503960366	4/15/2016	9762	6.28	6.28	0	
5	1503960366	4/16/2016	12669	8.16	8.16	0	
6	1503960366	4/17/2016	9705	6.48	6.48	0	
6 rows | 1-7 of 15 columns
```

``` r
head(heartrate_persecond)
```

```
Description:df [6 × 3]
Id
<dbl>
Time
<chr>
Value
<int>
1	2022484408	4/12/2016 7:21:00 AM	97	
2	2022484408	4/12/2016 7:21:05 AM	102	
3	2022484408	4/12/2016 7:21:10 AM	105	
4	2022484408	4/12/2016 7:21:20 AM	103	
5	2022484408	4/12/2016 7:21:25 AM	101	
6	2022484408	4/12/2016 7:22:05 AM	95	
6 rows
```

``` r
head(intensities)
```

```
Description:df [6 × 4]
Id
<dbl>
ActivityHour
<chr>
TotalIntensity
<int>
AverageIntensity
<dbl>
1	1503960366	4/12/2016 12:00:00 AM	20	0.333333
2	1503960366	4/12/2016 1:00:00 AM	8	0.133333
3	1503960366	4/12/2016 2:00:00 AM	7	0.116667
4	1503960366	4/12/2016 3:00:00 AM	0	0.000000
5	1503960366	4/12/2016 4:00:00 AM	0	0.000000
6	1503960366	4/12/2016 5:00:00 AM	0	0.000000
6 rows
```

``` r
head(sleep)
```
```
Description:df [6 × 5]
 
 
Id
<dbl>
SleepDay
<chr>
TotalSleepRecords
<int>
TotalMinutesAsleep
<int>
TotalTimeInBed
<int>
1	1503960366	4/12/2016 12:00:00 AM	1	327	346
2	1503960366	4/13/2016 12:00:00 AM	2	384	407
3	1503960366	4/15/2016 12:00:00 AM	1	412	442
4	1503960366	4/16/2016 12:00:00 AM	2	340	367
5	1503960366	4/17/2016 12:00:00 AM	1	700	712
6	1503960366	4/19/2016 12:00:00 AM	1	304	320
6 rows
```

``` r
head(steps)
```

```
Id
<dbl>
ActivityHour
<chr>
StepTotal
<int>
1	1503960366	4/12/2016 12:00:00 AM	373	
2	1503960366	4/12/2016 1:00:00 AM	160	
3	1503960366	4/12/2016 2:00:00 AM	151	
4	1503960366	4/12/2016 3:00:00 AM	0	
5	1503960366	4/12/2016 4:00:00 AM	0	
6	1503960366	4/12/2016 5:00:00 AM	0	
6 rows
```

After using the head function to preview the datasets, I’ve notice some
issues with these datasets. For instance, before conducting any analysis
it’s essential to change the column names to lowercase as R is
case-sensitive.

# Make the column name to be lowercase since R is case sensitive - Processing the data

``` r
dailyactivity <- rename_with(dailyactivity, tolower)
heartrate_persecond <- rename_with(heartrate_persecond, tolower)
steps <- rename_with(steps, tolower)
sleep <- rename_with(sleep, tolower)
intensities <- rename_with(intensities, tolower)
```

Also it’s essential to convert it into a date-time format and then
separate it into date and time components.

### Fixing formatting

``` r
heartrate_persecond <- heartrate_persecond %>% 
  rename (date = time) %>%
  mutate(
    time = format(as.POSIXct(heartrate_persecond$time, format = '%m/%d/%Y %I:%M:%S %p'), format = "%H:%M:%S"),
    date = format(as.Date(date, format = '%m/%d/%Y'), format = "%m/%d/%Y") # Formatting the old value
    ) %>%
  select (id, date, time, value)
  
steps <- steps %>%
  mutate(
    time = format(as.POSIXct(steps$activityhour, format = '%m/%d/%Y %I:%M:%S %p'), format = "%H:%M:%S"),
    activityhour = format(as.Date(activityhour, format = '%m/%d/%Y'), format = "%m/%d/%Y")
    ) %>%
select (id, activityhour, time, steptotal)

sleep <- sleep %>% 
  mutate(
    sleeptime = format(as.POSIXct(sleep$sleepday, format = '%m/%d/%Y %I:%M:%S %p'), format = "%H:%M:%S"),
    sleepday = format(as.Date(sleepday, format = '%m/%d/%Y'), format = "%m/%d/%Y")                
    ) %>%
  select (id, sleepday, sleeptime, totalminutesasleep)

intensities <- intensities %>% 
  mutate(
    activitytime = format(as.POSIXct(activityhour, format = '%m/%d/%Y %I:%M:%S %p'), format = "%H:%M:%S"), # Turning into 24 hrs
    activityhour = format(as.Date(activityhour, format = '%m/%d/%Y'), format = "%m/%d/%Y")
  ) %>%
  select (id, activityhour, activitytime, totalintensity, averageintensity)
```

Then we can check if the data has been formatted properly, for
instances:

``` r
head(intensities) 

```
Description:df [6 × 5]
id
<dbl>
activityhour
<chr>
activitytime
<chr>
totalintensity
<int>
averageintensity
<dbl>
1	1503960366	04/12/2016	00:00:00	20	0.333333
2	1503960366	04/12/2016	01:00:00	8	0.133333
3	1503960366	04/12/2016	02:00:00	7	0.116667
4	1503960366	04/12/2016	03:00:00	0	0.000000
5	1503960366	04/12/2016	04:00:00	0	0.000000
6	1503960366	04/12/2016	05:00:00	0	0.000000
6 rows
```


But before we start to perform any analysis, we also need to verify the
number of users first.

``` r
n_distinct(dailyactivity$id)
```

    ## [1] 33

``` r
n_distinct(heartrate_persecond$id)
```

    ## [1] 14

``` r
n_distinct(intensities$id)
```

    ## [1] 33

``` r
n_distinct(sleep$id)
```

    ## [1] 24

``` r
n_distinct(steps$id)
```

    ## [1] 33

As Sršen told me that this data set might have some limitations, we
believe that the limitation is the sample size is just too small.
However we believe that the data collected so far provides valuable
insights that can still be informative for our analysis. It is important
to make the most of the available data and draw preliminary conclusions,
even while recognizing the limitations imposed by the smaller sample
size.

Then the next step is we need to check if there’s any duplicate data.

``` r
sum(duplicated(dailyactivity))
```

    ## [1] 0

``` r
sum(duplicated(heartrate_persecond))
```

    ## [1] 0

``` r
sum(duplicated(intensities))
```

    ## [1] 0

``` r
sum(duplicated(sleep))
```

    ## [1] 3

``` r
sum(duplicated(steps))
```

    ## [1] 0

Duplicate data can be acceptable in certain scenarios for various
reasons, For example in a clinical or research setting, duplicate
heartbeat data might be acceptable if there’s a clear explanation, such
as repeated measurements for accuracy or consistency checks. As we can
see there’s 9334 duplicate values from the **heartrate_persecond** data/
3 duplicate values from the **sleep** data. Thus, we can check if the
duplicate is reasonable or not.

``` r
duplicated_rows <-sleep[duplicated(sleep) | duplicated(sleep, fromLast = TRUE), ]
print(duplicated_rows)
```

    ##             id   sleepday sleeptime totalminutesasleep
    ## 161 4388161847 05/05/2016  00:00:00                471
    ## 162 4388161847 05/05/2016  00:00:00                471
    ## 223 4702921684 05/07/2016  00:00:00                520
    ## 224 4702921684 05/07/2016  00:00:00                520
    ## 380 8378563200 04/25/2016  00:00:00                388
    ## 381 8378563200 04/25/2016  00:00:00                388

``` r
duplicated_rows <-heartrate_persecond[duplicated(heartrate_persecond) | duplicated(heartrate_persecond, fromLast = TRUE), ]
print(duplicated_rows)
```

    ## [1] id    date  time  value
    ## <0 rows> (or 0-length row.names)

Maybe due to human error, there’s some data being enter twice again in 2
datasets, we need to delete duplicates to ensure the data is clean.

``` r
heartrate_persecond <- heartrate_persecond %>%
  distinct() %>%
  drop_na()

sleep <- sleep %>%
  distinct() %>%
  drop_na()
```

Then we can double check if any duplicate records have been eliminated.

``` r
sum(duplicated(sleep))
```

    ## [1] 0

``` r
sum(duplicated(heartrate_persecond))
```

    ## [1] 0

Once we make sure all the data are appropriately sorted and cleaned. We
can start to summarize the data and putting in to work.

# Analyzing the data

``` r
# Summarize the data before we start to analyze
heartrate_persecond %>% select(value) %>% 
  summary()
```

    ##      value       
    ##  Min.   : 36.00  
    ##  1st Qu.: 63.00  
    ##  Median : 73.00  
    ##  Mean   : 77.33  
    ##  3rd Qu.: 88.00  
    ##  Max.   :203.00

``` r
steps %>% select(steptotal) %>% 
  summary()
```

    ##    steptotal      
    ##  Min.   :    0.0  
    ##  1st Qu.:    0.0  
    ##  Median :   40.0  
    ##  Mean   :  320.2  
    ##  3rd Qu.:  357.0  
    ##  Max.   :10554.0

``` r
sleep %>%  select(totalminutesasleep) %>% 
  summary()
```

    ##  totalminutesasleep
    ##  Min.   : 58.0     
    ##  1st Qu.:361.0     
    ##  Median :432.5     
    ##  Mean   :419.2     
    ##  3rd Qu.:490.0     
    ##  Max.   :796.0

``` r
intensities %>%  select(totalintensity, 
                        averageintensity) %>% 
  summary()
```

    ##  totalintensity   averageintensity
    ##  Min.   :  0.00   Min.   :0.0000  
    ##  1st Qu.:  0.00   1st Qu.:0.0000  
    ##  Median :  3.00   Median :0.0500  
    ##  Mean   : 12.04   Mean   :0.2006  
    ##  3rd Qu.: 16.00   3rd Qu.:0.2667  
    ##  Max.   :180.00   Max.   :3.0000

``` r
dailyactivity %>% select(totalsteps,
                         totaldistance,
                         sedentaryminutes, calories) %>% 
  summary()
```

    ##    totalsteps    totaldistance    sedentaryminutes    calories   
    ##  Min.   :    0   Min.   : 0.000   Min.   :   0.0   Min.   :   0  
    ##  1st Qu.: 3790   1st Qu.: 2.620   1st Qu.: 729.8   1st Qu.:1828  
    ##  Median : 7406   Median : 5.245   Median :1057.5   Median :2134  
    ##  Mean   : 7638   Mean   : 5.490   Mean   : 991.2   Mean   :2304  
    ##  3rd Qu.:10727   3rd Qu.: 7.713   3rd Qu.:1229.5   3rd Qu.:2793  
    ##  Max.   :36019   Max.   :28.030   Max.   :1440.0   Max.   :4900

1.  The data summary provides a comprehensive view of various key
    parameters. “Value” from **heartrate_persecond** exhibits a wide
    range of values, with the minimum at 36 and a maximum of 203,
    reflecting considerable variability within the dataset. The
    distribution is summarized with the first quartile at 63, the median
    at 73, and the third quartile at 88. The mean, calculated at
    approximately 77.36, gives us a measure of the central tendency.

2.  In the case of “Step Total” from **steps**, the data distribution is
    characterized by a range from a minimum of 0 steps to an astonishing
    maximum of 10554 steps. While the first quartile and median both
    stand at 0, the third quartile is at 357 steps, emphasizing a
    substantial spread within the dataset. The mean, around 320.2 steps,
    suggests a higher average value, signifying potential variations in
    the dataset.

3.  “Total Minutes Asleep” from **sleep** portrays a spread of values,
    ranging from a minimum of 58 minutes to a maximum of 796 minutes.
    The distribution shows that the first quartile is at 361 minutes,
    the median at 432.5 minutes, and the third quartile at 490 minutes,
    with a mean of approximately 419.2 minutes.

4.  The “Total Intensity” from **intensities** metric exhibits a range
    from 0 to 180. The data is spread with a first quartile of 0, a
    median of 3, and a third quartile of 16. The mean, about 12.04,
    suggests the average intensity across the dataset.

5.  Similarly from the **dailyactivity** table, “Average Intensity”
    reflects a diverse distribution, with the minimum at 0.0000 and the
    maximum at 3.0000. The first quartile and median are both at 0.0000,
    while the third quartile is at 0.2667. The mean, around 0.2006,
    signifies the dataset’s average intensity values.

- “Total Steps” showcases a range from a minimum of 0 steps to a maximum
  of 36019 steps. The distribution is characterized by a first quartile
  of 3790 steps, a median of 7406 steps, and a third quartile of 10727
  steps, with a mean of 7638 steps.
- “Total Distance” spans from a minimum of 0.000 to a maximum of 28.030,
  with a first quartile at 2.620, a median at 5.245, and a third
  quartile at 7.713. The mean, approximately 5.490, provides insight
  into the dataset’s average distance values.
- “Sedentary Minutes” is distributed with values ranging from a minimum
  of 0.0 to a maximum of 1440. The distribution shows the first quartile
  at 729.8, the median at 1057.5, and the third quartile at 1229.5, with
  a mean of 991.2.
- Lastly, “Calories” demonstrates a distribution from a minimum of 0 to
  a maximum of 4900, with the first quartile at 1828, the median at
  2134, the third quartile at 2793, and a mean of 2304.

# Share some insights from the dataset

After we finished summarizing our data, let’s look at the relationship
between different variables to see if we can find some trend and
correlation from them.

### Sleep Duration Analysis

``` r
sleep %>% 
  group_by(sleepday) %>% 
  summarize (average_totalminutesasleep = mean(totalminutesasleep)) %>% 
ggplot() +
  geom_col(mapping = aes(x = average_totalminutesasleep, y = sleepday, fill = average_totalminutesasleep)) +
  scale_fill_gradient(low = "green", high = "red") + 
  labs(title = "Mean of the Total Minutes Asleep Over Time", x = "Total Minutes Asleep", y = "Date")
```

<img
src=docs/capstone.notebook_files/figure-gfm/unnamed-chunk-18-1.png />

As we delve into the dataset, a prominent insight emerges regarding the
participants’ daily sleep duration. On average, individuals in our study
appear to sleep approximately 7.22 hours, equivalent to 419.5 minutes,
each day. This observation suggests that the dataset generally reflects
typical sleep patterns, with a substantial number of individuals meeting
the standard recommendations for daily sleep.

Further exploration of the data does not reveal any noticeable irregular
trends or anomalies. The sleep duration data follows a consistent and
expected pattern without any outliers or sudden fluctuations. This
stability in sleep duration can serve as a foundational understanding in
subsequent analyses and decision-making processes.

### User type distribution from Daily Activity

``` r
usertype <- c("veryactiveminutes","fairlyactiveminutes","lightlyactiveminutes","sedentaryminutes")
minutes <- c(mean(dailyactivity$veryactiveminutes), mean(dailyactivity$fairlyactiveminutes), mean(dailyactivity$lightlyactiveminutes), mean(dailyactivity$sedentaryminutes))
percentage <- c(round(minutes/1440*100, 2))
usertype_chart <- data.frame(usertype, minutes, percentage = paste(percentage, "%")) 
print(usertype_chart)
```

    ##               usertype   minutes percentage
    ## 1    veryactiveminutes  21.16489     1.47 %
    ## 2  fairlyactiveminutes  13.56489     0.94 %
    ## 3 lightlyactiveminutes 192.81277    13.39 %
    ## 4     sedentaryminutes 991.21064    68.83 %

Before we began our analysis, we organized users into four categories
based on their activity levels: “very active minutes,” “fairly active
minutes,” “lightly active minutes,” and “sedentary minutes.” We then
calculated the average time spent in each category and expressed it as a
percentage. This step was important to prepare our data for analysis.

``` r
waffle(usertype_chart,rows = 40, size = 0.5,
       colors = c("#85e085","#e6e600", "#ffd480", "#ff8080"), title="User type distribution")
```

<img
src=docs/capstone.notebook_files/figure-gfm/unnamed-chunk-20-1.png>

From this new dataset, we observed that nearly 70% of users spend most
of their time in a sedentary state, like sitting or lying down. About
14% engage in light activities such as walking slowly or standing in
line. Only around 2% of users are highly active, participating in
activities like running or aerobics classes. Approximately 1% are fairly
active, engaging in activities like brisk walking or vacuuming.

To understand these categories better, we can refer to [The Nutrition
Source from the Harvard School of Public Health
website](https://www.hsph.harvard.edu/nutritionsource/staying-active/#:~:text=Sedentary%E2%80%94Uses%201.5%20or%20fewer,in%20line%20at%20the%20store).
They define sedentary activities as those with a low metabolic rate (1.5
or fewer METs), which includes activities like sitting. Light activities
(1.6-3.0 METs) include leisurely walking or standing. Fairly active
activities (3.0-6.0 METs) involve brisk walking, vacuuming, or
leaf-raking. Finally, very active activities (6.0+ METs) encompass
activities like fast walking, running, or aerobics.

In summary, our analysis reveals that the majority of users tend to be
sedentary, while fewer are engaged in active or exercise-related
activities. This information lays the groundwork for our further
analysis and insights.

### Average Intensity Over Time

``` r
intensities %>% 
  group_by(activitytime) %>%
  summarize(average_intensity = mean(totalintensity)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = activitytime, y = average_intensity, fill = average_intensity)) +
  scale_fill_gradient(low = "green", high = "red") + 
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Average Intensity Over Time")
```

<img
src=docs/capstone.notebook_files/figure-gfm/unnamed-chunk-21-1.png />
Based on our visual analysis, we’ve uncovered a trend in the data that
relates to people’s daily activity levels and sleep patterns. It’s clear
that, on average, the intensity of physical activities reaches its
highest point between 5:00 p.m. and 9:00 p.m. This surge can be
explained by the fact that many people finish their work or daily
responsibilities during this time, allowing them to dedicate a portion
of their evening to fitness and exercise.

Conversely, we see a decline in average activity intensity starting at
8:00 p.m., reaching its lowest point at 4:00 a.m. This decline likely
reflects the natural progression of the day, with individuals winding
down after their workouts and heading home to rest. The general
consensus for sleep onset appears to fall between 8:00 p.m. and 12:00
a.m. And the result aligns with [established research on sleep
schedules](https://www150.statcan.gc.ca/n1/pub/82-003-x/2022003/article/00001-eng.htm).
These findings offer a valuable glimpse into how our daily routines
impact our activity levels and sleep, shedding light on the balance
between physical activity and rest in our lives.

### Average Steps Over Time

``` r
steps %>% 
  group_by(time) %>% 
  summarize(averagesteps = mean(steptotal)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = time , y = averagesteps, fill = averagesteps)) +
  scale_fill_gradient(low = "green", high = "red") + 
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Average Steps Over Time")
```

<img
src=docs/capstone.notebook_files/figure-gfm/unnamed-chunk-22-1.png />
Our result corroborates the trends identified in the **“Average
Intensity Over Time”** analysis. The chart depicting step count unveils
a clear pattern: users take more steps between 11 a.m. and 7 p.m.,
coinciding with the hours of elevated activity intensity observed in the
first result (5:00 p.m. to 9:00 p.m).

This alignment suggests that users’ activity levels are intimately tied
to their daily routines. The increase in both activity intensity and
step count during the late afternoon and early evening is indicative of
a time when individuals have completed their work or responsibilities,
allowing them to engage in exercise and fitness.

Conversely, a decline in step count after 8 p.m. mirrors the waning
activity intensity. This mirrors the natural progression of the day, as
individuals transition from active hours to rest, aligning with
established research on sleep schedules referenced in our initial
result.

In summary, our second result reaffirms the interplay between daily
activity patterns and step count, highlighting the influence of our
routines on both physical activity and relaxation.

### Average Heartrate Over Time

``` r
heartrate_persecond %>% 
  mutate(time = format(strptime(time, format = "%H:%M:%S"), format = "%H")) %>% 
  group_by(time) %>% 
  summarise(avereagebpm = mean(value)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = time, y = avereagebpm, fill = avereagebpm)) +
  scale_fill_gradient(low = "green", high = "red") +
  labs(title = "Average Heartrate Over Time")
```

<img
src=docs/capstone.notebook_files/figure-gfm/unnamed-chunk-23-1.png />
In this chart, we’ve aggregated the mean of the average heart rate,
grouped by time in a 24-hour format. The chart offers a reassuring
glimpse into the health of our users’ heart rates.

According to [Harvard Health Publishing on “What is a normal heart
rate?”](https://www.health.harvard.edu/heart-health/what-your-heart-rate-is-telling-you#:~:text=When%20you%20are%20at%20rest,and%2085%20beats%20per%20minute.)
when the body is at rest, the heart pumps the lowest amount of blood
required to supply the body with the necessary oxygen. While the
official normal resting heart rate typically ranges from 60 to 100 beats
per minute, for most healthy adults, it generally falls between 55 and
85 beats per minute.

However, it’s important to note that our analysis lacks specific user
age information. Therefore, further investigation may be warranted to
better understand the nuances of individual heart rate patterns and
ensure a comprehensive assessment of their cardiovascular health.

### Relationship between Total Steps vs. Calories

``` r
ggplot(data = dailyactivity) +
  geom_point(mapping = aes(x = totalsteps, y = calories)) +
  stat_smooth(mapping = aes(x = totalsteps, y = calories)) +
  labs(title = "Relationship between Total Steps vs. Calories", x = "Total Steps", y = "Calories Burned (kcal)")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

<img
src=docs/capstone.notebook_files/figure-gfm/unnamed-chunk-24-1.png>
Our analysis reveals the more steps we take, the more calories we burn.
It’s a basic and expected connection—being more active leads to greater
calorie expenditure. This emphasizes the importance of physical activity
in managing our calorie balance and staying healthy.

# Act and Suggestion

1.  As evident from our analysis, the majority of our users tend to have
    limited physical activity during the day, primarily engaging in
    sedentary activities. To address this, we’re contemplating the
    **integration of pop-up notifications within our app**.

<img
src="https://ap-lab.ca/wp-content/uploads/2020/06/notifications.png"
width="150" />

These notifications will play a crucial role as friendly prompts,
encouraging our users to incorporate regular physical activity and
exercise into their routines. The messages will emphasize the
significance of staying active and taking brief breaks to move
throughout the day. Through the implementation of this feature, we aim
not only to maintain user engagement but also to positively impact their
overall health and well-being. This initiative presents a simple yet
effective strategy to align with our commitment to fostering a healthy
and active lifestyle.

2.  Based on our analysis, it’s evident that many individuals face
    challenges in finding motivation to exercise, often due to the
    pressures of work and daily life. In response, we are considering an
    enhancement to **a reward system combined with interactive
    mini-games**. This feature would allow users to earn virtual coins
    by reaching their exercise goals and participating in fun
    challenges. These earned coins can then be traded for a range of
    in-app rewards or fitness-related items. By gamifying the fitness
    experience, our aim is to make physical activity not only enjoyable
    but also rewarding. This initiative aligns seamlessly with our
    dedication to promoting a healthier and more active lifestyle, while
    introducing an element of entertainment and motivation to our app.
    We believe that this addition has the potential to significantly
    boost user retention and satisfaction.

<img
src="https://i.pinimg.com/originals/e0/21/e0/e021e0e569e0022dd73ed0721eb776a6.png"
width="550" />

3.  We can encourage our users to share their fitness experiences and
    achievements within our app. By allowing them to post their workout
    updates, milestones, and challenges, we can create a thriving
    fitness community. Users can motivate each other, share tips, and
    celebrate their progress. This interactive and social dimension can
    significantly enhance user engagement and retention while
    reinforcing our app’s role as a hub for an active and supportive
    lifestyle.

![](https://blog.strava.com/wp-content/uploads/2018/03/GSS-2-800x480.jpg)

*Thank you for taking the time to review my initial R case study! If you
found it valuable and insightful, I kindly request your feedback in the
form of comments and upvotes.*

# References

Wang C, Colley RC, Roberts KC, Chaput JP, Thompson W. *Sleep behaviours
among Canadian adults: Findings from the 2020 Canadian Community Health
Survey healthy living rapid response module.* Health Rep. 2022 Mar
16;33(3):3-14. doi: 10.25318/82-003-x202200300001-eng. PMID: 35294137.

Harvard T.H. Chan School of Public Health. (n.d.). *Staying Active. The
Nutrition Source.*
<https://www.hsph.harvard.edu/nutritionsource/staying-active/>

Harvard Health Publishing. (n.d.). *What is a normal heart rate?*
<https://www.health.harvard.edu/heart-health/what-your-heart-rate-is-telling-you>
