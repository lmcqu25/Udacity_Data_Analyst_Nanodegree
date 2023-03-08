
library(dplyr)
library(tidyr)
library(timeDate)
library(tidyverse)
library(ggplot2)
library(lubridate)

ny = read.csv('new_york_city.csv')
wash = read.csv('washington.csv')
chi = read.csv('chicago.csv')

names(ny)
ncol(ny)

names(chi)
ncol(chi)

names(wash)
ncol(wash)

# Verifying that the three columns are not equal.
ncol(ny) == ncol(chi) & ncol(wash) == ncol(ny) 

class(ny)
class(chi)
class(wash)

head(ny,2)

head(chi,2)

head(wash,2)

# New York table structure.
str(ny)

# Chicago table structure.
str(chi)

# Washington table structure.
str(wash)

# Missing values for ny table.
sum(is.na(ny))

# Missing values for the Trip.Duration column in ny table.
sum(is.na(ny$Trip.Duration))

# Missing values for the Birth.Year colum in ny table.
sum(is.na(ny$Birth.Year))

# The total missing values in ny data frame from Trip.Duration and Birth.Year.
sum(is.na(ny)) == (sum(is.na(ny$Trip.Duration)) + sum(is.na(ny$Birth.Year)))

empty.values.search <- function(state,variable){
    #` Function to find empty values in state table.`
    return (count(filter(state, state[[variable]] =='')))    
}

# Searching for any empty values in Gender variable for ny table.
empty.values.search(ny,"Gender")

# Converting the empty values into NA values to later do EDA.
ny$Gender[ny$Gender==''] <- NA

# Verifying the empty values have been turned into NA values.
empty.values.search(ny,"Gender")

# Missing values for chi table.
sum(is.na(chi))

# All Missing values come from Birth.Year column in chi table.
sum(is.na(chi$Birth.Year))

# Using function to find missing Gender values in chi table.
empty.values.search(chi,"Gender")

# Converting the empty values into NA values to later do EDA.
chi$Gender[chi$Gender==''] <- NA

# Verifying that the empty values are zero.
count(filter(chi, Gender==''))

# Missing values for wash table.
sum(is.na(wash))

# Missing value comes from Trip.Duration in wash table.
sum(is.na(wash$Trip.Duration))

# Searching for any empty values in Start.Station variable for wash table.
empty.values.search(wash,"Start.Station")

# Converting the empty values into NA values to later do EDA.
wash$Start.Station[wash$Start.Station==''] <- NA

# Verifying that the empty values are zero.
empty.values.search(wash,"Start.Station")

# Searching for any empty values in User.Type variable for ny table.
empty.values.search(ny,"User.Type")

# Converting the empty values into NA to do EDA.
ny$User.Type[ny$User.Type==""] <- NA

# Verifying that the empty values are zero.
empty.values.search(ny,"User.Type")

# Searching for any empty values in User.Type variable for chi table.
empty.values.search(chi,"User.Type")

# Converting the empty values into NA to do EDA.
chi$User.Type[chi$User.Type==""] <- NA

# Verifying that the empty values are zero.
empty.values.search(chi,"User.Type")

# Searching for any empty values in User.Type variable for wash table.
empty.values.search(wash,"User.Type")

# Converting the empty values into NA to do EDA.
wash$User.Type[wash$User.Type==""] <- NA

# Verifying that the empty values are zero.
empty.values.search(wash,"User.Type")

date.time.conversion.ST <- function(state){
    #' Function to convert factor into a POSIXct/Date Time format for Start.Time.'
    state$Start.Time <- state[['Start.Time']] <- as.POSIXct(state[['Start.Time']], format = "%Y-%m-%d %H:%M:%S")
    return (state$Start.Time)
    }

date.time.conversion.ET <- function(state){
    #' Function to convert factor into a POSIXct/Date Time format for Start.Time.'
    state$End.Time <- state[['End.Time']] <- as.POSIXct(state[['End.Time']], format = "%Y-%m-%d %H:%M:%S")
    return (state$End.Time)
    }

# Convert ny from factor to date time.
ny$Start.Time <- date.time.conversion.ST(ny)
ny$End.Time <- date.time.conversion.ET(ny)

# Convert chi from factor to date time.
chi$Start.Time <- date.time.conversion.ST(chi)
chi$End.Time <- date.time.conversion.ET(chi)

# Convert wash from factor to date time.
wash$Start.Time <- date.time.conversion.ST(wash)
wash$End.Time <- date.time.conversion.ET(wash)

# Verifying ny date time conversion.
str(ny$Start.Time)
str(ny$End.Time)

# Verifying chi date time conversion.
str(chi$Start.Time)
str(chi$End.Time)

# Verifying wash date time conversion.
str(wash$Start.Time)
str(wash$End.Time)

# Creating a Gender column for the wash table.
wash$Gender <- NA

# Converting empty values into NA to perfrom EDA.
wash$Gender[wash$Gender == ''] <- NA

# Verifying Gender column for the wash table was created.
head(wash,1)

# Verifying Gender column has no empty values.
filter(wash, Gender=='')

# Creating a Birth.Year column for the wash table.
wash$Birth.Year <- NA

# Converting empty values into NA to perform EDA.
wash$Birth.Year[wash$Birth.Year=='']<- NA

# Verifying Birth.Year has no empty values.
filter(wash, Birth.Year=='')

# Verifying Birth.Year column for the wash table was created.
head(wash, 1)

# Creating a City column for each table to allow for identification 
# on master table.
ny$City <- factor("NYC")
chi$City <- factor("Chicago")
wash$City <- factor("DC")

# Verifying new City Column creation.
names(ny)
names(chi)
names(wash)

# Adding up the number of rows and columns per table. 
total <- nrow(ny) + nrow(chi) + nrow(wash)
ny.count <- ncol(ny) 
chi.count <- ncol(chi)
wash.count <- ncol(wash)
 
print(paste0("Total rows: ", total," ny columns: ", ny.count, " chi columns: ", chi.count, " wash columns: ", wash.count))

# rbinding ny table with chi table.
bikeshare.city <- rbind(ny, chi)
# rbinding ny and chi table with wash table.
bikeshare.cities <- rbind(bikeshare.city, wash)

# Verfying the total number of bikeshare.cities table is equal to the three individual tables.
total.2 <- nrow(bikeshare.cities)
total.col <- ncol(bikeshare.cities)
print(paste0("bikeshare.cities rows: ", total.2," bikeshare.cities columns: ", total.col))

# Inspecting the new bikeshare.cities table.
head(bikeshare.cities, 1)

# Source help: https://stackoverflow.com/questions/50304159/label-day-timing-into-morning-afternoon-and-evening-in-r
# Creating time periods from the Start.Time column to make EDA easier.

# transforming time column into date time. 
bikeshare.cities$Start.Time <- ymd_hms(bikeshare.cities$Start.Time)

# createing breaks
breaks <- hour(hm("00:00", "05:59", "11:59", "16:59", "23:59"))

# creating labels for the breaks
labels <- c("Night", "Morning", "Afternoon","Evening")

# creating the new Time.Period variable for the bikeshare.cities table.
bikeshare.cities$Time.Period <- cut(x=hour(bikeshare.cities$Start.Time),
breaks = breaks, labels = labels, include.lowest=TRUE)

# Verifying the levels.
levels(bikeshare.cities$Time.Period)

# Creating new variable for the bikeshare.cities table to later perform EDA
# using Month, hourly time, and days of the week variables.

bikeshare.cities$Day.of.Week <- factor(format(bikeshare.cities$Start.Time, format= "%a"), levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))
bikeshare.cities$Month <- factor(format(bikeshare.cities$Start.Time, format="%b"), levels =c("Jan", "Feb", "Mar", "Apr", "May", "Jun"))
bikeshare.cities$Time <- factor(format(bikeshare.cities$Start.Time, format="%H:%M:%S"))
bikeshare.cities <- bikeshare.cities %>% select(X, Start.Time, End.Time, Month, Day.of.Week, Time, Time.Period, Trip.Duration, Start.Station, End.Station, User.Type, Gender, Birth.Year, City)

# Verifying the levels for Days and Months.
levels(bikeshare.cities$Day.of.Week)
levels(bikeshare.cities$Month)

# Verifying the new variables just created from above code.
head(bikeshare.cities, 1)

# Checking to see if the Time.Periods align witht the time.
time.period.check <- function(period){
#` Function to verify the time period of the day to the actual time.`    

test <- bikeshare.cities%>%
filter(Time.Period == period)%>%
select(Time, Time.Period)%>%
arrange(Time)
head(test,5)
}

time.period.check("Morning")

time.period.check("Afternoon")

time.period.check("Evening")

time.period.check("Night")

table(bikeshare.cities %>%
    select(Time.Period, City))

ggplot(subset(bikeshare.cities, !is.na(Time.Period), !is.na(City)), aes(x=Time.Period, fill=City))+
geom_bar(stat='count', position='dodge') +
ggtitle("Rides per Time of Day for Each City") +
labs(x="Time Interval", y="Ride Count") 

# Creating the new Age variable for bikeshare.cities table.
bikeshare.cities <- bikeshare.cities %>% 
    mutate(Age = (2017 - Birth.Year))

# Verifying new variable was added.
names(bikeshare.cities)

# Code to create age category labels.
bikeshare.cities$Age.Category <- cut(bikeshare.cities$Age, breaks = c(1, 12, 19, 55, Inf),
    labels = c("Children", "Teen", "Adult", "Senior"))

# Verifying the labels are correct.
summary(bikeshare.cities$Age.Category)

# Creating table to investigate the busiest day of the week.
busiest.city.all <- bikeshare.cities %>%
    select(Day.of.Week) %>%
    arrange(Day.of.Week)
table(busiest.city.all)

# Creating a ggplot of visualize the data for busiest day of the week.
ggplot(data=subset(bikeshare.cities, !is.na(Day.of.Week)), aes(Day.of.Week))+
geom_bar(fill='steelblue', color='navy')+
ggtitle("Rides per Day for All Cities") +
labs(x="Day of Week", y="Ride Count") 

# Selecting city and day.of.week and making a table to see actual numbers.
busiest.days.city <- bikeshare.cities %>%
    select(City, Day.of.Week)
table(busiest.days.city)   

# Creating a ggplot to visualize the data from the Day.of.Week vs City table.
ggplot(data=subset(bikeshare.cities, !is.na(Day.of.Week)), aes(x = Day.of.Week, fill = City)) +
geom_bar(position="dodge", color="black")+
ggtitle("Rides per Day per City") +
labs(x="Day of Week", y="Ride Count") +
scale_fill_manual("legend", values=c("NYC"= "grey", "Chicago"="black", "DC"="darkblue"))

# Creating table to investigate the Time.Period and each day of the week.
city.day.period <- bikeshare.cities%>%
    select(Day.of.Week,Time.Period,City)%>%
    arrange(Day.of.Week)
table(city.day.period)

ggplot(subset(bikeshare.cities, !is.na(bikeshare.cities$Day.of.Week)), aes(x=Day.of.Week, fill=Time.Period))+
geom_histogram(stat='count', position='dodge') +
facet_grid(rows=vars(City), scales="free")+
ggtitle("Busiest Times of the Day per City per Day") +
labs(x="Day of Week", y="Ride Count") 

# Creating a table of values to investigate the intersection of City and Month.

tabs <- bikeshare.cities %>%
    select(City, Month)
table(tabs)

# Creating a ggplot to visualize the data from the above table.
ggplot(data=subset(bikeshare.cities, !is.na(Month)), aes(x = Month, fill = City)) +
geom_bar(position="dodge", color="black") + 
ggtitle("Rides per Month per City") +
labs(x="Month", y="Total Rides") +
scale_fill_manual("legend", values=c("NYC"= "navy", "Chicago"="limegreen", "DC"="blue"))


# Investigating the User Type data.
summary(bikeshare.cities$User.Type)
levels(bikeshare.cities$User.Type)

# Creating a table to investigate the User.Type data and to see which months
# were the busiest.
month.by.usertype <- bikeshare.cities %>%
    filter(!is.na(City), !is.na(Month), !is.na(User.Type)) %>%    
    select(City, Month, User.Type)
table(month.by.usertype)

# Creating a ggplot to visualize the data from the above table.
ggplot(data=subset(bikeshare.cities, !is.na(User.Type) & !is.na(Month)), aes(x =Month, fill = User.Type)) +
geom_bar(position='dodge')+
ggtitle("Rides per User Type per Month by City") +
labs(x="Month", y="Ride Count") +
facet_wrap(~City)
#facet_grid(rows=vars(City), scales="free")

# Creating a table to investigate the data on gender and days of the week.
riders.day.gender <- bikeshare.cities %>%
    select(Day.of.Week,City,Gender)
table(riders.day.gender)

# Creating a ggplot to visualize data from gender and days of the week table.
ggplot(data=subset(bikeshare.cities, !is.na(Gender)), aes(x=Day.of.Week, fill=Gender)) +
geom_bar(position='dodge') +
ggtitle('Riders per Day by Gender') +
labs(y = 'Number of Riders', x = 'Day of Week') +
scale_fill_manual("legend", values = c("Male" = "navy", "Female" = "cyan"))+
facet_grid(rows=vars(City), scales="free")

# Creating a table to investigate the intersection of age category, gender, and
# city.
city.age.gender <-bikeshare.cities %>%
    select(City, Gender, Age.Category)
table(city.age.gender)

# Creating a ggplot to visualize the table on gender, age category, and city.
ggplot(data=subset(bikeshare.cities, !is.na(Gender) & !is.na(Age.Category)), aes(Age.Category, fill=Gender))+
geom_histogram(stat='count', position='dodge')+
facet_grid(rows=vars(City), scales='free')+
ggtitle('Riders by Gender and Age Category per City') +
labs(y = 'Number of Riders', x = 'Age Category') 

# Looking for extreme age values and outliers.
cit.age <- bikeshare.cities%>%
    select(City, Age)
table(cit.age)

# Looking for the maximum age values and outliers.
bikeshare.cities %>%
    group_by(City)%>%
    filter(!is.na(Age))%>%
    summarize(max(Age))

summary(cit.age)

ggplot(data=subset(bikeshare.cities, !is.na(Gender) & !is.na(Age)), aes(x=Gender, Age, fill=City))+
geom_boxplot()+
scale_y_continuous(breaks=seq(0, 140, by=10))+
labs(title="Age and Gender per City")

# Code to extract the extreme ages or outliers from the bikeshare.cities
# dataset. Creating a new table so not to destroy the original bikeshare.cities
# table.
outliers <- boxplot(bikeshare.cities$Age, plot=FALSE)$out

new.age <- bikeshare.cities

new.age<- new.age[-which(new.age$Age %in% outliers),]

summary(new.age$Age)

# The standard deviation of the ages after the outliers have been removed.
sd(new.age$Age, na.rm=TRUE)

# Looking for the maximum age values and outliers in the new.age table.
new.age %>%
    group_by(City)%>%
    filter(!is.na(Age))%>%
    summarize(max(Age))

# The new.age table created after removing extreme age values from
# bikeshare.cities table.
head(new.age,1)

# Plotting the new ages of the new table after extracting the extreme values
# from the bikeshare.cities$Age data.
ggplot(data=subset(new.age, !is.na(Gender) & !is.na(Age)), aes(x=Gender, Age, fill=City))+
geom_boxplot()+
scale_y_continuous(breaks=seq(0, 80, by=5))+
labs(title="Age and Gender per City")

system('python -m nbconvert Explore_bikeshare_data.ipynb')
