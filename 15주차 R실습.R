# Missing values
# - explicitly missing: 자료는 있으나 파악되지 못해 NA로 표시
# - implicitly missing: 자료가 존재하지 않는 경우

library(tidyverse)

stocks <- tibble(
  year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr = c(1, 2, 3, 4, 2, 3, 4),
  return= c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)
## 2015년의 qtr4 자료: explicitly missing
## 2016년의 qtr1 자료: implicitly missing
## spread를 이용하여 implicitly missing을 explicitly missing으로 만들 수 있음

stocks %>% spread(year, return)

## explicitly missing 제거하고 싶은 경우

stocks %>% spread(year, return) %>% gather(year, return, `2015`:`2016`, na.rm = TRUE)

## complete() 함수를 이용하여 implicit missing을 explicit missing으로 변환

stocks %>% complete(year, qtr) # qtr 요소가 다 있어야 한다는 뜻

## fill ftn

treatment <- tribble(
  ~ person, ~treatment, ~reponse,
  "Derick Whitmore",1 , 7,
  NA,               2 , 10,
  NA,               3 , 9,
  "Katherine Buke", 1, 4
)

treatment %>% fill(person)
### missing을 Last Observation Carried Forward 규칙에 따라 채워줌


# Case Study

who
## 1980-2013년까지 WHO의 TB 원자료
## country , iso2 및 iso3 는 국가를 중복해서 지정하는 세 개의 변수
## new_sp_m014 , new_ep_m014 , new_ep_f014 : 그룹별 새로운 결핵 환자 수 
## rel, sn, sp -> 결핵의 종류
## f: female, m: male
## 014: 0~14세, 1524: 15~24세, ... , 65: 65세 이상
--------------------------------------------------------------------------------
### 자료 정리
who1 <- who %>% pivot_longer(
  cols = new_sp_m014:newrel_f65, 
  names_to = "key", 
  values_to = "cases", 
  values_drop_na = TRUE
  )
who1

who1 <- who %>% gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm= TRUE)
who1

### key변수 살펴보기
who1 %>% count(key)


### key -> 첫 부분(new), 결핵 종류, 환자 성별, 나이그룹

### 문제점 해결: newrel -> new_rel로 변환
who2 <- who1 %>% mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

### 분리
who3 <- who2 %>% separate(key, c("new", "type", "sexage"), sep = "_")
who3

who3 %>% count(new)

### new, iso 제거
who4 <- who3 %>% select(-new, -iso2, -iso3)

### 성별과 나이 분리
who5 <- who4 %>% separate(sexage, c("sex", "age"), sep = 1)
who5


### 총정리
who %>%
  gather(
    new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm= TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "type", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

