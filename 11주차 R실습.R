library(dplyr)
library(nycflights13)
library(tidyverse)

### 6. Pipe
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count>20, dest != "HNL")

ggplot(delay, aes(dist, delay))
+geom_point(aes(size = count), alpha = 1/3) 
+geom_smooth(se = FALSE)

## 공간이 너무 많이 필요
delays <- flights %>% group_by(dest) %>% summarise(
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
) %>% filter(count> 0, dest != "HNL")


%>% ggplot(aes(dist, delay)) +geom_point(aes(size = count), alpha = 1/3) +geom_smooth(se = FALSE)


# example
flights %>% group_by(year, month, day) %>% summarise(mean = mean(dep_delay))
flights %>% group_by(year, month, day) %>% summarise(mean = mean(dep_delay, na.rm = TRUE))

# 같은 결과
sum(is.na(flights))
colSums(is.na(flights))

not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% group_by(year, month, day) %>% summarise(mean = mean(dep_delay))


# Q. delay 분포?
not_cancelled<- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))
delays <- not_cancelled %>% group_by(tailnum) %>% summarise(delay = mean(arr_delay), count = n())
ggplot(delays, aes(x = delay)) + geom_freqpoly(binwidth = 10)

## 300분 이상 평균 delay인 비행기 존재. 더 자세히 살펴보기 위해 delay와 비행건수 간의 산점도를 그림
delays <- not_cancelled %>% group_by(tailnum) %>% summarise(delay = mean(arr_delay, na.rm= TRUE), 
                                                            count = n())
## 몇 건의 비행 있는지 추가

ggplot(delays, aes(count, delay)) + geom_point(alpha = 0.1)
## 300분 이상의 비행 건수 매우 적음

## 비행건수 25 이상만 그리기
delays %>% filter(count>25) %>% ggplot(aes(count, delay)) + geom_point(alpha = 0.1)


# Useful summary functions

not_cancelled %>% group_by(year, month, day) %>% summarise(avg_delay1 = mean(arr_delay), 
                                                           avg_delay2 = mean(arr_delay[arr_delay>0]))
  ## delay 양수인 데이터만 뽑아 확인

not_cancelled %>% group_by(dest) %>% summarise(distance_sd = sd(distance)) %>% arrange(desc(distance_sd))
  ## 거리 표준편차 큰 것부터 정렬

not_cancelled %>% group_by(year, month, day) %>% summarise(first = min(dep_time), last = max(dep_time))

not_cancelled %>% group_by(year, month, day) %>% summarise(first_dep = first(dep_time), 
                                                           last_dep = last(dep_time))
  ## 일별로 가장 먼저, 마지막에 출발하는 시간?
  ## nth(x, 2)

not_cancelled %>% group_by(year, month, day) 
%>% mutate(r= min_rank(desc(dep_time))) %>% filter(r %in% range(r))
  ## 위와 비교

#### 참고: 
n() -> missing data 세기에 포함 / sum(!is.na(x)) -> missing X / n_distinct(x) -> 겹치지 않게 세기
