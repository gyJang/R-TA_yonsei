
# 1. Tibble

library(tidyverse)

## Tibble: dataframe을 좀 더 편하게 사용할 수 있도록 변형시킨 class
## dataframe과 상호교환 가능 (변수 형태: int(정수), dbl(실수), chr(문자형), dttm=date_times(날짜/시간), lgl(logical), fctr(범주))


### tibble 만들기
class(iris)
iris_t = as_tibble(iris)
class(iris_t)

tb <- tibble(
  ':)'= 'smile',
  ' ' = 'space',
  '2000' = 'number'
)

tb # dataframe에서 불가능한 기호도 가능!

### printing: tibble에서는 처음 10줄 또는 화면에 맞는 정도만 ptinting해주고 변수의 type도 함께 보여준다.
### runif(): 0~1 난수 생성하는 함수

newtibble<- tibble(
  a = lubridate::now() + runif(1e3)*86400, #1e3 = 10^3
  a1 = lubridate::now() + runif(1e3)*86400*30,
  b = lubridate::today() + runif(1e3)*30,
  b1 = lubridate::today() + runif(1e3)*30*12,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE),
  f = sample(LETTERS, 1e3, replace = TRUE)
)

newtibble

print(newtibble, n = 3, width = Inf)
  # 3개 자료, 전체 변수 다 보여주기

options(tibble.print_max = n, tibble.print_min = m) # 자료가 m줄 이상인 경우 처음 n줄만 인쇄하라는 default 옵션 변경 함수
options(dplyr.print_min = Inf) # 항상 모든 자료를 인쇄
options(tibble.width = Inf) # 항상 모든 변수를 인쇄

View('data') # 보기만 가능, 변경 못 함

### subsetting
set.seed(2022) # 컴퓨터 내부에서 돌아가는 특정한 난수 생성 공식에서 처음 시작값을 주어 매번 같은 값이 나오게 만드는 것 / 난수 생성 함수와 같이 실행
tb<- tibble(
  x = runif(5),
  y = rnorm(5)
)

tb$x

tb[['x']]

tb[[1]]

### partial matching
df.tbl<- tibble(
  xx = runif(5),
  y = rnorm(5)
)

df.DF <- data.frame(
  xx = runif(5),
  y = rnorm(5)
)


df.tbl$x # 정확한 변수명만.
df.DF$x # partial matching이 가능

#### tibble to dataframe
tb_todf<- as.data.frame(tb)
class(tb_todf)




# 2. dplyr

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
sum(is.na(flights))
colSums(is.na(flights)) # 유용한 함수:)

### 1. filter() : 조건에 맞는 관측 선택하기

filter(flights, month == 1, day <= 2) # 1.1~1.2 자료
filter(flights, month == 11 | month == 12) # 11, 12월 자료
filter(flights, month %in% c(11,12))

#### na 포함된 경우 filter
df <- tibble(x= c(1, NA, 3))
filter(df, x>1)
filter(df,is.na(x) | x>1)


### 2. arrange() : 열 값을 기준으로 행의 순서를 바꿈

arrange(flights, year, month, day) # 기본적으로 오름차순
arrange(flights, desc(arr_delay)) # 내림차순 option
#### 참고 NA 값은 항상 마지막 순서로!
arrange(df, x)
arrange(df, desc(x))


### 3. select(): 특정 변수만을 선택하기
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day)) # 제거할 변수 선택도 가능
select(flights, time_hour, air_time, everything()) # 앞으로 빼고 나머지는 순서대로

##### 여러옵션: starts_with("abc"), ends_with("xyz"), contains("ijk"), num_range("x", 1:3)-x1,x2,x3 선택, rename()
rename(flights, tail_num = tailnum)

