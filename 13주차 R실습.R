
# Tidy Data - 데이터 정리

library(tidyverse) # tidyr패키지 포함
library(dplyr)

## 같은 자료를 4가지 다른 방법으로 표현

table1<- tibble(country = rep(c("Afganistan", "Brazil", "China"), each = 2),
                year = rep(c(1999, 2000), 3),
                cases = c(745, 2666, 37737, 80488, 212258, 213766),
                population = c(19987071, 20595360, 172006362, 174504898, 1272915272, 1280428583))

table2<-tibble(country = rep(c("Afganistan", "Brazil", "China"), each = 4),
               year = rep(c(1999, 1999, 2000, 2000), 3),
               type = rep(c("cases", "population", "cases", "population"), 3),
               count = c(745, 19987071, 2666, 20595360, 37737, 172006362, 80488, 174504898, 212258, 1272915272, 213766, 1280428583))
                
table3<- tibble(country = rep(c("Afganistan", "Brazil", "China"), each = 2),
                year = rep(c(1999, 2000), 3),
                rate = c(745/19987071, 2666/20595360, 37737/172006362, 80488/174504898, 212258/1272915272, 213766/1280428583))

# cases
table4a<- tibble(country = c("Afganistan", "Brazil", "China"),
                `1999` = c(19987071, 172006362, 1272915272),
                `2000` = c(20595360, 174504898, 1280428583))

# population
table4b<- tibble(country = c("Afganistan", "Brazil", "China"),
                 `1999` = c(745, 37737, 212258),
                 `2000` = c(2666, 80488, 217376))


### 데이터셋을 타이디하게 만드는, 서로 연관된 세 가지 규칙
### 1. 변수마다 해당되는 열이 있어야 한다.
### 2. 관측값마다 해당되는 행이 있어야 한다.
### 3. 값마다 해당하는 하나의 셀이 있어야 한다.

## 변수를 열에 배치하면 R의 벡터화 속성이 가장 잘 발휘된다는 점에서 장점. 
## mutate와 summarise에서 볼 수 있듯, 대부분의 내장 R 함수는 벡터에 작동.

----------------------------------------------------------------------------------------

# Compute rate per 10,000
table1 %>% mutate(rate = cases / population * 10000) # 만 명당 비율

# Compute cases per year
table1 %>% count(year, wt = cases)

# Visualise changes over time
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # 축 눈금 설정



## table4a 를 보면 열 이름 1999 와 2000은 year 변수 값.
## 각 행은 하나가 아닌 두 개의 관측값을 나타낸다.
## 데이터셋을 타이디하게 만들려면 해당 열을 새로운 두 변수로 피봇(pivot) 해야 한다.
### 변수가 아니라 값을 나타내는 열 집합. 이 예에서는 열 1999 과 열 2000.
### 열 이름을 이동시켜서 만들 변수이름. (여기에서는 year)
### 열 값을 이동시켜서 만들 변수 이름. (여기에서는 cases)

table4a %>% pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

tidy4a <- table4a %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "population"
  ) %>%
  mutate(year = parse_integer(year))

tidy4b<- table4b %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "cases"
  ) %>%
  mutate(year = parse_integer(year))

left_join(tidy4a, tidy4b)
