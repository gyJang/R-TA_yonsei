library(dplyr)
library(nycflights13)

## data: flights - 2013년 뉴욕으로부터 출발하는 모든 비행기에 대한 자료
-변수들:
- dep_time: 실제 출발 시간
- sched_dep_time: 예정된 출발 시간
- dep_delay: 출발 지연 시간. 음수는 빠른 출발.
- carrier: 비헹기 회사
- flight: 항공기 번호
- tailnum: 비행기 본체 인식 번호
- origin: 출발공항코드
- dest: 도착공항코드
- air_time: 실제 비행시간
- distance:두 공항 간 거리(mile)
- hour/minute: 출발 예정 시간 시/분
- time_hour: 정각 단위로 올림한 예정 출발시간


flights


### 1. filter() : 조건에 맞는 관측 선택하기
filter(flights, month %in% c(11,12))

### 2. arrange() : 열 값을 기준으로 행의 순서를 바꿈
arrange(flights, desc(arr_delay))

### 3. select(): 특정 변수만을 선택하기
select(flights, year:day)

###
rename(flights, tail_num = tailnum)

### 4-1. mutate(): 새로운 변수 만들어 추가하기
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, 
       gain = arr_delay - dep_delay, # 비행 delay
       hours = air_time/60, # 분 시간으로 변경
       gain_per_hour = gain/hours
       )

### 4-2. transmute(): 새로운 변수만을 가지는 자료 만들기 
transmute(flights, 
          gain = arr_delay - dep_delay, # 비행 delay
          hours = air_time/60, # 분 시간으로 변경
          gain_per_hour = gain/hours
          )
  # 자료가 너무 많으면 전략적 사용

### 5. summarise(): 요약 통계량 계산
summarise(flights, delay= mean(dep_delay, na.rm = TRUE))
  # group_by와 함께 사용할 경우 유용
by_day <- group_by(flights, year, month, day)

summarise(by_day, delay = mean(dep_delay, na.rm = TRUE)) # day별 summary

### 6. Pipe
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count>20, dest != "HML")

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
