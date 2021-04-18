#Link googledrive to access spreadsheets
library(googledrive)
drive_find(n_max = 10)
drive_find(type = "spreadsheet")
drive_download("WeeklyFeels", type = "csv")

#
feels <- read.csv('WeeklyFeels.csv')
feels
library(dplyr)
library(lubridate)
library(tidyr)
library(stringr)
library(ggplot2)

feels%>%
  separate(col = 1, into = c('date','time'), sep = ' ')%>%
  rename(my_feelings = `I.feel...from.a.scale.from.1.5.`)%>%
  ggplot(aes(x = time, y = my_feelings))+
  geom_point()+
  labs(y = 'I feel', x = 'Time')

