
2.3 # 하나의 범주형 변수(Categorical) & 하나의 연속형 변수(Continuous)

library(reshape2)
library(tidyverse)
data(tips)

# 산점도(Scatter plot)
ggplot(tips, aes(day, tip)) + geom_point()

# Jittering(약간의 랜덤 노이즈를 줘서 겹쳐 그려지지 않도록)
ggplot(tips, aes(day, tip)) + geom_jitter()

# 박스 플랏
ggplot(tips, aes(day, tip)) + geom_boxplot()

# Violin plot
ggplot(tips, aes(day, tip)) + geom_violin()

# Freqploy
ggplot(tips, aes(total_bill, colour = day)) + geom_freqpoly(binwidth = 5)
 ## sample size가 달라서 비교하기 어려움

# Density plot
ggplot(tips, aes(total_bill, colour = day)) + geom_density()
  ## 안쪽 면적이 1 / 각각 요일별 비교 가능

# Histogram
ggplot(tips, aes(total_bill, colour = day, fill = day)) + geom_histogram()
 ## colour은 선의 색, fill은 내부 색 지정
+facet_wrap(~day, ncol = 1) #ncol, nrow


2.4 # 두 개의 연속변수(Continuous)

# geom_point
ggplot(tips, aes(total_bill, tip)) + geom_point()

+geom_smooth()
 ##  y = f(x) 식과 오차 범위(자료 많은 부분 오차 범위 적어짐)
 ## method 지정 중요 -> span= 0.1, 1 / method = "lm" / se = "FALSE"
 #### span controls the amount of smoothing for the default loess smoother. 
 #### Smaller numbers produce wigglier lines, larger numbers produce smoother lines.


2.5 # 두 개의 범주형 변수(Categorical)

## 타이타닉 데이터 사용
data(Titanic)

 -변수들:
  Class: 1st, 2nd, 3rd, Crew
  Sex: Male, Female
  Age: Child, Adult
  Survived: No, Yes
  
Titanic

apply(Titanic, 1, sum)
apply(Titanic, c(1,4), sum) #c(행, 열)
apply(Titanic, c(2,4), sum)
apply(Titanic, c(3,4), sum)

library(ggmosaic)
class(Titanic)
Titanic_df <-as.data.frame(Titanic)
head(Titanic_df)

## 탑승 class에 따른 survived 차이
ggplot(Titanic_df)+geom_mosaic(aes(product(Class), weight = Freq, fill = Survived))

ggplot(Titanic_df)+geom_mosaic(aes(product(Survived), weight = Freq, fill = Class))

## 성별에 따른 survived 차이
ggplot(Titanic_df)+geom_mosaic(aes(product(Sex), weight = Freq, fill = Survived))

ggplot(Titanic_df)+geom_mosaic(aes(product(Survived), weight = Freq, fill = Sex))

## Age에 따른 survived 차이
ggplot(Titanic_df)+geom_mosaic(aes(product(Age), weight = Freq, fill = Survived))

ggplot(Titanic_df)+geom_mosaic(aes(product(Survived), weight = Freq, fill = Age))
