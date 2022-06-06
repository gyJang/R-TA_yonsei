2.6 # 셋 이상의 변수들
#산점도 행렬
library(tidyverse)
library(reshape2)
data(tips)


library(GGally)
ggpairs(tips)
ggpairs(mpg[,-c(1:2)])
ggpairs(mpg, columns=c(5,7,8,9),
        mapping=ggplot2::aes(color=drv),
        title='mpg')

## 대략적 상황만 파악



2.7 # 셋 이상의 범주형 자료 mosaic plot
library(ggmosaic)
Titanic_df <-as.data.frame(Titanic)

# 복습
ggplot(Titanic_df)+geom_mosaic(aes(product(Class), weight = Freq, fill = Survived))
ggplot(Titanic_df)+geom_mosaic(aes(product(Survived), weight = Freq, fill = Age))

# 변수 세 개 이상
ggplot(Titanic_df) + geom_mosaic(x = product(Age), conds = product(Class), weight = Freq, fill = Survived)

ggplot(Titanic_df) + geom_mosaic(x = product(Class), conds = product(Age), weight = Freq, fill = Survived)

ggplot(Titanic_df) + geom_mosaic(x = product(Sex), conds = product(Class), weight = Freq, fill = Survived)


2.8 #시계열 자료

- <economics>: 1967년 10월~2014년 4월까지 과거 40년 간 미국의 경제상황에 대해 조사한 월간 자료 (ggplot2 내장 데이터)

- 변수들:
  date: 조사한 날짜
  pce: 개인소비지출
  pop: 전체 인구수
  psavert: 개인 저축률
  uempmed: 실업 지속기간의 중앙값
  unemploy: 실업자 수

economics

class(economics$date)

ggplot(economics, aes(date, pce)) + geom_line()
ggplot(economics, aes(date, psavert)) + geom_line()
ggplot(economics, aes(date, unemploy/pop)) + geom_line()
ggplot(economics, aes(date, uempmed)) + geom_line()


2.9 #group 활용

library(nlme)
data("Oxboys")
head(Oxboys)

Oxford 26명 소년들 나이에 따른 키 자료 (9번 측정)

# 변수 설명
- Subject: 각 소년의 ID
- age: 표준화된 나이
- height: 키
- Occasion: 키가 측정된 순서, 1은 가장 먼저/ 9는 마지막 측정 (범주형 변수)

## 1) Multiple groups
ggplot(Oxboys, aes(age, height)) + geom_point() + geom_line() # 그룹 설정 X

* group = Subject #그룹 지정 옵션

## 2) Different groups on different layers
- ggplot 내에서 지정한 aesthetic mapping은 그 이후 layer에 모두 영향을 미침.
단, layer 내에서 지정된 aesthetic mapping은 layer 내의 지정이 우선

ggplot(Oxboys, aes(age, height, group = Subject)) + geom_point() + geom_smooth(method = "lm", se = FALSE)
ggplot(Oxboys, aes(age, height)) + geom_point(aes(group = Subject)) + geom_smooth(method = "lm", se = FALSE)

## 3) boxplot

ggplot(Oxboys, aes(Occasion, height))+geom_boxplot()
ggplot(Oxboys, aes(Occasion, height))+geom_boxplot()+geom_line(colour = blue, alpha = 0.5)
ggplot(Oxboys, aes(Occasion, height))+geom_boxplot()+geom_line(aes(group = Subject))
ggplot(Oxboys, aes(Occasion, height))+geom_boxplot()+geom_line(aes(group = Subject), colour = "blue", alpha = 0.5)
