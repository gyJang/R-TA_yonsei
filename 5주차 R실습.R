
# Visualization - package: tidyverse(ggplot2 내장)

library(tidyverse)

# 1. ggplot2 example

1.1
?mpg #mpg데이터
mpg

-변수들:
  manu~ & model: 자동차 생산회사와 모델. 1999~2008년 사이의 38가지 모델
  displ: 엔진 배기량
  year: 생산연도
  cyl: 자동차의 실린더수(엔진 배기량을 나타냄)
  trans: 자동차의 변속방법
  drv: 전륜구동, 후륜구동, 사륜구동
  cty와 hwy: 도시와 고속도로에서의 mpg(갤런당 주행거리)
  fl: 연료타입
  class: 자동차 타입

1.2
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()
# 함수의 세 가지 요소: data / aesthetic mapping / geom 함수
# scatter plot(음의 상관관계) / outlier

1.3 #aes 지정:
aes(displ, hwy, colour = class)
aes(displ, hwy, shape = drv)
aes(displ, hwy, size  = cyl)

ggplot(mpg, aes(displ, hwy, colour = class)) + geom_point()
ggplot(mpg, aes(displ, cty, shape = drv)) + geom_point()
ggplot(mpg, aes(displ, cty, size = cyl)) + geom_point()
ggplot() + geom_point(aes(x=displ, y=hwy, alpha=class), data=mpg)
ggplot() + geom_point(aes(x=displ, y=hwy, alpha=cty), data=mpg)

1.4 #Facetting
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point() + facet_wrap(~class)

1.5 #geom 함수
geom_smooth(),  geom_boxplot(), geom_violin(), geom_path()

# 2. 변수 종류에 따른 자료 표현
library(reshape2)
data(tips)

-변수들:
  total_bill: 각 테이블에서 지불한 돈
  tips: 각 테이블에서 지불한 tip ->tip의 분포를 알고 싶은 것
  sex: 성별
  smoker: table이 smoking section에 있는지
  day: 서빙을 한 요일
  time: 서빙한 시간(Dinner, Lunch)
  size: 함께 식사한 인원(명)
  
2.1 # 단일 연속변수

# Histogram
ggplot(tips, aes(x = tip)) + geom_histogram()
 ## binwidth에 따라 특징 달라짐 binwidth = 1, 0.5, 0.25, 0.1, 0.05, 0.01
 ## bins와 binwidth 같은 것 아님
 ## tip 경향: peak 존재, 대략적으로 round off해서 지불하는 경향

# frequency polygons
ggplot(tips, aes(tip)) + geom_freqpoly()
  ## binwidth

# density
ggplot(tips, aes(tip)) + geom_density()
  ## bw 크면 전체적 pattern, 작으면 세부 pattern

2.2 # 단일 범주형 변수

# Bar chart
ggplot(tips, aes(time)) + geom_bar()
ggplot(tips, aes(day)) + geom_bar()
table(tips$day)
  ## 요일 순서대로 : 
  TipsDay<-data.frame(day = factor(c("Thur", "Fri", "Sat", "Sun"),
                      levels = c("Thur", "Fri", "Sat", "Sun")),
                      count = c(62,19,87,76))
  ggplot(TipsDay, aes(day, count)) + geom_bar(stat = "identity")
  #### we need to be mindful of the value we assign to the stat argument 
  #### within the geom_bar() function. If it is stat = "identity",
  #### we are asking R to use the y-value we provide for the dependent variable.
  
  ggplot(TipsDay, aes(day, count))+ geom_point() #->실행 안 됨
  
# Pie chart
ggplot(TipsDay, aes(x = "", y = count, fill = day)) + geom_bar(stat = "identity")
ggplot(TipsDay, aes(x = "", y = count, fill = day)) + geom_bar(stat = "identity") + coord_polar("y") 
