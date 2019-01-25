#Allard Script for Public Opinion and Congress on Privacy

#Libraries - include in Markdown
library(dplyr)
library(ggplot2)
library(plm)
library(gtools)
library(tigris)
library(sf)
library(ggmap)
library(tidyverse)
library(sp)

#for this doc only
library(foreign)

#Read  Pew data in
file<-"/Users/GrantAllard/Documents/Clemson PhD/Courses/PADM - 8500 - Fundamentals of Homeland Security - Cook/Public Opinion of Privacy/January 3-10, 2018 - Core Trends Survey/January 3-10, 2018 - Core Trends Survey - CSV.csv"
CoreTrends<-read_csv(file)
CoreTrends_df<-as_data_frame(CoreTrends)
names(CoreTrends_df)

CoreTrends_df<- CoreTrends_df %>% 
  select(age,sex,inc,educ2, party, pial11, pial11_igbm, `pial11ao@`,  )
