#Lecture_3

## 결측치 처리
z <- c(11:13, NA) #not available
is.na(z)
na.omit(z)

sum(z) #계산 X
sum(z, na.rm=TRUE)

1/0 #Inf 반환
Inf * 5
0/0 #Nan 반환
Inf - Inf

z <- -1:1 / 0
is.na(z)
r <- c(z, NA)
is.na(r)
is.nan(r)

#변수명 부여
animals <- c(5, 7, 3, 2)
names(animals) <- c("cats", "dogs", "camels", "donkeys")
animals
animals["camels"]
animals[c("dogs","donkeys")]



## 데이터프레임
name <- c("김철수", "김영희", "이철수", "이영희", "홍길동")
grade <- c(1, 4, 3, 2, 1)
gender <- c("M", "F", "M", "F", "M")
student <- data.frame(name, grade, gender)
student

midterm = c(74, 82, 67, 89, 92)
final = c(91, 77, 88, 78, 86)
scores = cbind(midterm, final) #열로 합하기
scores

rt <- c(TRUE, FALSE, FALSE, TRUE, FALSE)
students <- data.frame(student, scores, retake = rt)
students

total.scores <- midterm + final
cbind(students, total.scores)


a <- data.frame(name="Jane Eyre", grade=4, gender="F", midterm=90, final=85, retake=F)
rbind(students, a) #행 추가

students$hw <- c(8, 9, 7, 8, 10) #열 추가

typeof(students)
attributes(students)

### 열 부르기
students$gender
students[["midterm"]]
students[[5]]
typeof(students$name)

### 값 수정
students$midterm[5] <- 50
students[[4]][3:5]

### 행렬 형식 필터링
students[1,]
students[2:3,]
students[-(2:3),]
students[,4]
students[,-1]
students[, c(2, 4)]
students[2:4, 3:5]
students[students$midterm >= 80, ]
students[students$midterm >= 80, c("name", "grade", "gender")]
students[students$grade != 1, c("name", "grade", "gender")]

### 정렬하기
students[order(students$grade), ]
students[order(students$final, decreasing = TRUE), ]

order(students$grade, students$final)
students[order(students$grade, students$final, decreasing=T), ]
students[order(students$grade, -students$final), ]

### subset 필터링
?subset
x <- c(7, 9, NA, 5, 2)
x[x>6]
subset(x, x> 6)

## 데이터 프레임 함수 적용
nrow(students)
ncol(students)
t(students) #전치 함수

head(iris) #n= 옵션
tail(iris)

attach(students)
detach(students)
ls()



