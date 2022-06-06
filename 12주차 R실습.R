library(dplyr)
library(nycflights13)
library(tidyverse)

# Data handling exercise
not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
View(not_cancelled)

## Q. 일별로 5시 이전에 출발하는 비행기의 합?
not_cancelled %>% group_by(year, month, day) %>% summarise(n_early = sum(dep_time < 500)) # 5:00


## Q. 1시간 이상 지연된 비행기 비율?
not_cancelled %>% group_by(year, month, day) %>% summarise(hour_perc = mean(arr_delay > 60)) # 60분


## 여러 변수를 이용한 그룹 지정
daily <- flights %>% group_by(year, month, day)
per_day <- daily %>% summarise(flights = n()) # 일별
per_month <- per_day %>% summarise(flights = sum(flights)) #월별
per_year <- per_month %>% summarise(flights = sum(flights)) # 연간


# Ungroup(그룹 해제)
daily %>% ungroup() %>% summarise(flights = n())


# Variable creating Excercise

delay_ranking <- flights %>% select(year, month, day, dep_delay, arr_delay, distance, air_time) 
                %>% group_by(year, month, day) %>% filter(rank(desc(arr_delay))<10) 
      ### ranking 1~9위 arr_delay 큰 row

popular_dests <- flights %>% group_by(dest) %>% filter(n()> 365) %>% count() %>% arrange(desc(n))
      ### 하루에 한 건 이상 비행하는 destination들

popular_dests2 <- flights %>% group_by(dest) %>% filter(n()> 365) %>% filter(arr_delay >0) 
                  %>% mutate(prop_delay = arr_delay / sum(arr_delay)) 
                  %>% select(year:day, dest, arr_delay, prop_delay) %>% arrange(desc(prop_delay))



