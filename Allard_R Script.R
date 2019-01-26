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
library(stringr)
library(gmodels)


#for this doc only
library(foreign)

#Code not in function
"%ni%"<-Negate("%in%")

#Code wrapper function
wrapper <- function(x, ...) 
{
  paste(strwrap(x, ...), collapse = "\n")
}

#Internet Data####
#Read  Pew data in
file<-"/Users/GrantAllard/Documents/Clemson PhD/Courses/PADM - 8500 - Fundamentals of Homeland Security - Cook/Public Opinion of Privacy/January 3-10, 2018 - Core Trends Survey/January 3-10, 2018 - Core Trends Survey - CSV.csv"
CoreTrends<-read_csv(file)
CoreTrends_df<-as_tibble(CoreTrends)
names(CoreTrends_df)

#Subset for the variables that I need
CoreTrends_df<- CoreTrends_df %>% 
  select(age,sex,inc,educ2, party, pial11, pial11_igbm, `pial11ao@`, cregion, state)

#Examine Distribution of pial11####
int_tbl<-CoreTrends_df %>% 
  select(cregion, state, pial11, `pial11ao@`) %>% 
  group_by(pial11) %>%
  filter(pial11 < 4 ) %>% 
  count()

#Convert to Factor
int_tbl$pial11<-as.factor(int_tbl$pial11)

#internet plot
int_plot<-ggplot(int_tbl, aes(x=pial11, y=n))+
  geom_bar(stat="identity")+
  scale_x_discrete(labels=c("Good","Bad","Some of Both"))+
  ylab("Count")+
  xlab("")+
  ggtitle("The internet is...")
int_plot


#state data
remove<-list(3, 7, 11, 14, 43, 52, 60, 64, 66, 67, 68, 69, 70, 71,  74, 76, 78, 79, 81,84,86,89,95 )

state_tbl<-CoreTrends_df %>% 
  select(cregion, state, pial11, `pial11ao@`) %>% 
  group_by(state) %>% 
  filter(state %ni% remove) %>% 
  count()
state_tbl

#int x state
int_state<-CoreTrends_df %>% 
  select(cregion, state, pial11, `pial11ao@`) %>% 
  group_by(state, pial11) %>% 
  filter(state %ni% remove) %>% 
  filter(pial11 < 3)
int_state

#Recode into Good and bad
int_state[int_state$pial11==1,"pial11"]<-"Good"
int_state[int_state$pial11==2,"pial11"]<-"Bad"
int_state


#SPSS Style Cross Tab####
CrossTable(int_state$state, int_state$pial11, format="SPSS")

#Chi-Square Test, No significant difference in cells
int_state_tbl<-table(int_state$state, int_state$pial11)
summary(int_state_tbl)


#Surveillance Data####
file<-"/Users/GrantAllard/Documents/Clemson PhD/Courses/PADM - 8500 - Fundamentals of Homeland Security - Cook/Public Opinion of Privacy/June13/June13 public.sav"
surveil<-read.spss(file)
surveil_df<-as_data_frame(surveil)

#Q42 on Surveillance
surveil_df %>% 
  group_by(q42) %>%
  filter(q42 != "Don't know/Refused (VOL.)") %>% 
  count() %>% 
  ggplot(aes(x=q42, y=n))+
  geom_bar(stat="identity")+
  ggtitle(wrapper("If you knew that the federal government had collected data about your telephone or internet activity would you feel that your personal privacy had been violated, or not?", width=80))+
  theme(plot.title = element_text(family="Trebuchet MS", size=10))

surveil_df %>% 
  group_by(q42) %>%
  filter(q42 != "Don't know/Refused (VOL.)") %>% 
  summarise(n=n()) %>% 
  mutate(prop = n/sum(n))

surveil_df %>% 
  group_by(q41) %>%
  filter(q41 != "Don't know/Refused (VOL.)") %>% 
  summarise(n=n()) %>% 
  mutate(prop = n/sum(n))



#Subset People who would feel violated
surveil_sub<-surveil_df %>% 
  filter(q42=="Yes, would feel violated")

#Congress####

save.image("Allard_CongressHLS.Rdata")



