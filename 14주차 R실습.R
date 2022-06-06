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
                rate = c("745/19987071", "2666/20595360", "37737/172006362", "80488/174504898", "212258/1272915272", "213766/1280428583"))

# cases
table4a<- tibble(country = c("Afganistan", "Brazil", "China"),
                 `1999` = c(19987071, 172006362, 1272915272),
                 `2000` = c(20595360, 174504898, 1280428583))

# population
table4b<- tibble(country = c("Afganistan", "Brazil", "China"),
                 `1999` = c(745, 37737, 212258),
                 `2000` = c(2666, 80488, 217376))

table5 <- tibble(country = rep(c("Afganistan", "Brazil", "China"), each = 2),
                 century = rep(c("19", "20"), 3),
                 year = rep(c("99", "00"), 3),
                 rate = c("745/19987071", "2666/20595360", "37737/172006362", "80488/174504898", "212258/1272915272", "213766/1280428583"))


----------------------------------------------------------------------------------

table2

## 관측값이 여러 행에 흩어져 있을 때
## cases 와 population 을 각각 열로 가지고, 이 열의 각 셀이 관련된 count 값을 가지는 데이터프레임이 필요
### 변수 이름을 포함하는 열, 여기에서는 type
### 값을 포함하는 열, 여기에서는 count

table2 %>%
  pivot_wider(names_from = type, values_from = count)

table2 %>%
  pivot_wider(names_from = type, values_from = count) %>%
  mutate(rate = cases / population)

table2 %>%
  pivot_wider(names_from = type, values_from = count) %>%
  mutate(rate = cases / population) %>%
  ggplot(aes(x = year, y = rate)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))

----------------------------------------------------------------------------------
  
## pivot_wider/longer의 다른 방법: gathering and spreading

## Gathering  
tidy4a<- table4a %>% gather(`1999`, `2000`, key = "year", value = "population")
### key : 새로운 변수를 저장하는 이름 / cases: 수치를 저장할 변수
tidy4b<- table4b %>% gather(`1999`, `2000`, key = "year", value = "cases")

left_join(tidy4a, tidy4b)

## Spreading :  Observation이 여러줄에 나타날 때 이용
spread(table2, key = type, value = count)



# Separation and uniting
# table3의 하나의 열에 두 변수의 값을 가진 문제를 해결

## Separate(): 하나의 컬럼을 여러 개의 컬럼으로 바꾸어주는 함수
table3
table3 %>% separate(rate, into = c("cases", "population")) # 특수문자 기준으로 분리하게 됨
# option = sep = "/"
table3 %>% separate(rate, into = c("cases", "population"), sep = "/")
table3 %>% separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE) # 알맞은 type으로 자동 분류

# * sep = 2 : 앞에서 두 개 문자(숫자)에서 끊으시오 / sep = -1 : 뒤에서 한 개로 끊으시오


## Unite(): 여러 개의 컬럼을 하나의 컬럼으로 합쳐줌
table5 
table5 %>% unite(new, century, year)
table5 %>% unite(new, century, year, sep = "")








