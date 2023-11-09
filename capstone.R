library("tidyverse")
library("janitor")
library("ggplot2")
library("lubridate")
library("waffle")

#1. What are some trends in smart device usage?
#2. How could these trends apply to Bellabeat customers?
#3. How could these trends help influence Bellabeat marketing strategy?
  
# Import dataset
dailyactivity <- read.csv("E:/Download/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
heartrate_persecond <- read.csv("E:/Download/Fitabase Data 4.12.16-5.12.16/heartrate_seconds_merged.csv")
intensities <- read.csv("E:/Download/Fitabase Data 4.12.16-5.12.16/hourlyIntensities_merged.csv")
steps <- read.csv("E:/Download/Fitabase Data 4.12.16-5.12.16/hourlySteps_merged.csv")
sleep <- read.csv("E:/Download/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")


# Make the column name to be lowercase since R is case sensitive
dailyactivity <- rename_with(dailyactivity, tolower)
heartrate_persecond <- rename_with(heartrate_persecond, tolower)
steps <- rename_with(steps, tolower)
sleep <- rename_with(sleep, tolower)
intensities <- rename_with(intensities, tolower)


# Create a new column with mutate function.
heartrate_persecond <- heartrate_persecond %>% 
  rename (date = time) %>%
  mutate(
    time = format(as.POSIXct(heartrate_persecond$time, format = '%m/%d/%Y %H:%M:%S %p'), format = "%H:%M:%S"),
    date = format(as.Date(date, format = '%m/%d/%Y'), format = "%m/%d/%Y") # Formatting the old value
    ) %>%
  select (id, date, time, value)
  
steps <- steps %>%
  mutate(
    time = format(strptime(steps$activityhour, format = '%m/%d/%Y %I:%M:%S %p'), format = "%H:%M:%S"),
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


# Make sure all the dataset are distinct
n_distinct(dailyactivity$id)
n_distinct(heartrate_persecond$id)
n_distinct(intensities$id)
n_distinct(sleep$id)
n_distinct(steps$id)

# Check if there's any duplicate data
sum(duplicated(dailyactivity))
sum(duplicated(heartrate_persecond))
sum(duplicated(intensities))
sum(duplicated(sleep))
sum(duplicated(steps))

# Turns out only heartrate_persecond,sleep, intensities have duplicate data. Now we will check if the duplicate is reasonable or not
duplicated_rows <-steps[duplicated(sleep) | duplicated(sleep, fromLast = TRUE), ]
print(duplicated_rows)

# Summarize the data before we start to analyze

heartrate_persecond %>% select(value) %>% 
  summary()

steps %>% select(steptotal) %>% 
  summary()

sleep %>%  select(totalminutesasleep) %>% 
  summary()

intensities %>%  select(totalintensity, 
                        averageintensity) %>% 
  summary()

dailyactivity %>% select(totalsteps,
                         totaldistance,
                         sedentaryminutes, calories) %>% 
  summary()

# Start analyzing the data
sleep %>% 
  group_by(sleepday) %>% 
  summarize (average_totalminutesasleep = mean(totalminutesasleep)) %>% 
ggplot() +
  geom_col(mapping = aes(x = average_totalminutesasleep, y = sleepday, fill = average_totalminutesasleep)) +
  scale_fill_gradient(low = "green", high = "red") + 
  labs(title = "Mean of the Total Minutes Asleep Over Time", x = "Total Minutes Asleep", y = "Date")

# As we can see, usually the participants will sleep 7.22 hours (419.5 minutes) a day. And there is no odd trend we can find in this dataset.

# Average Intensity Over Time
intensities %>% 
  group_by(activitytime) %>%
  summarize(average_intensity = mean(totalintensity)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = activitytime, y = average_intensity, fill = average_intensity)) +
  scale_fill_gradient(low = "green", high = "red") + 
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Average Intensity Over Time")

# Average Steps Over Time
steps %>% 
  group_by(time) %>% 
  summarize(averagesteps = mean(steptotal)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = time , y = averagesteps, fill = averagesteps)) +
  scale_fill_gradient(low = "green", high = "red") + 
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Average Steps Over Time")

# Avg Heartrate over time
heartrate_persecond %>% 
  mutate(time = format(as.POSIXct(time, format = "%I:%M:%S"), format = "%H")) %>% 
  group_by(time) %>% 
  summarise(avereagebpm = mean(value)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = time, y = avereagebpm, fill = avereagebpm)) +
  scale_fill_gradient(low = "green", high = "red") +
  labs(title = "Average Heartrate Over Time")

# Relationship between Total Steps vs. Calories

ggplot(data = dailyactivity) +
  geom_point(mapping = aes(x = totalsteps, y = calories)) +
  stat_smooth(mapping = aes(x = totalsteps, y = calories)) +
  labs(title = "Relationship between Total Steps vs. Calories", x = "Total Steps", y = "Calories Burned (kcal)")

# User type distribution from Daily activity

usertype <- c("veryactiveminutes","fairlyactiveminutes","lightlyactiveminutes","sedentaryminutes")
minutes <- c(mean(dailyactivity$veryactiveminutes), mean(dailyactivity$fairlyactiveminutes), mean(dailyactivity$lightlyactiveminutes), mean(dailyactivity$sedentaryminutes))
percentage <- c(round(minutes/1440*100, 2))
usertype_chart <- data.frame(usertype, minutes, percentage = paste(percentage, "%")) 

waffle(usertype_chart,rows = 40, size = 0.5,
       colors = c("#85e085","#e6e600", "#ffd480", "#ff8080"), title="User type distribution")

# Conclusion

#
#The data also shows many people lead either a lightly active or sedentary lifestyle, which may be due to the nature of their work or the lack of time to exercise. Bellabeat (for example, 10 minute videos) that their customers can follow along to if they don't necessarily want to excercise alone. To encourage better sleeping habits, Bellabeat could incorporate reminders through an app that notifies users of the best time to go to sleep and wake up in order to feel refreshed in the morning and get adequate amount of sleep.

### User type distribution from Daily Activity
```{r}
usertype <- c("veryactiveminutes","fairlyactiveminutes","lightlyactiveminutes","sedentaryminutes")
minutes <- c(mean(dailyactivity$veryactiveminutes), mean(dailyactivity$fairlyactiveminutes), mean(dailyactivity$lightlyactiveminutes), mean(dailyactivity$sedentaryminutes))
percentage <- c(round(minutes/1440*100, 2))
usertype_chart <- data.frame(usertype, minutes, percentage = paste(percentage, "%")) 
print(usertype_chart)
```

Before we began our analysis, we organized users into four categories based on their activity levels: "very active minutes," "fairly active minutes," "lightly active minutes," and "sedentary minutes." We then calculated the average time spent in each category and expressed it as a percentage. This step was important to prepare our data for analysis.

```{r}
usertype_chart$percentage <- as.numeric(sub("%", "", usertype_chart$percentage))
waffle(usertype_chart,rows = 40, size = 0.5,
       colors = c("#85e085","#e6e600", "#ffd480", "#ff8080"), title="User type distribution")
```

From this new dataset, we observed that nearly 70% of users spend most of their time in a sedentary state, like sitting or lying down. About 14% engage in light activities such as walking slowly or standing in line. Only around 2% of users are highly active, participating in activities like running or aerobics classes. Approximately 1% are fairly active, engaging in activities like brisk walking or vacuuming.

To understand these categories better, we can refer to [The Nutrition Source from the Harvard School of Public Health website](https://www.hsph.harvard.edu/nutritionsource/staying-active/#:~:text=Sedentary%E2%80%94Uses%201.5%20or%20fewer,in%20line%20at%20the%20store). They define sedentary activities as those with a low metabolic rate (1.5 or fewer METs), which includes activities like sitting. Light activities (1.6-3.0 METs) include leisurely walking or standing. Fairly active activities (3.0-6.0 METs) involve brisk walking, vacuuming, or leaf-raking. Finally, very active activities (6.0+ METs) encompass activities like fast walking, running, or aerobics.
                                                                                                                                 
                                                                                                                                 In summary, our analysis reveals that the majority of users tend to be sedentary, while fewer are engaged in active or exercise-related activities. This information lays the groundwork for our further analysis and insights.
                                                                                                                               
                                                                                                                               
                                                                                                                              
                                                                                                                               

dailyactivity <- read.csv("../input/fitbit/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
heartrate_persecond <- read.csv("../input/fitbit/Fitabase Data 4.12.16-5.12.16/heartrate_seconds_merged.csv")
intensities <- read.csv("../input/fitbit/Fitabase Data 4.12.16-5.12.16/hourlyIntensities_merged.csv")
steps <- read.csv("../input/fitbit/Fitabase Data 4.12.16-5.12.16/hourlySteps_merged.csv")
sleep <- read.csv("../input/fitbit/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")
  