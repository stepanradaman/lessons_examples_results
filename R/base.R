# говно
# Ctrl-L - очистить консоль

# ------------------------ всякое
# 1+2+3
# sqrt(3)
# ?sqrt #посмотреть на функцию

# x<-100
# y<-x*2
# sqrt(y)

# ------------------------ векторы

# myset<-c(1,-2,3,4,5)
# myset*2
# sqrt(myset)

# nextset<-myset^2
# nextset
# mean(myset)

# myset > 0
# myset[1] # здесь с 1 индексируется

# myset[myset > 3] # типа np.where

# which(nextset==9) # найти индекс по совпадению
# which(nextset==max(nextset)) # найти индекс по совпадению


# ------------------------ папки и файлы
# getwd() # узнаем рабочую директорию
# setwd("D:/TEST/R/lesson/") # устанавливаем рабочую директорию
# getwd()

# dir.create("D:/TEST/R/testfolder")
# file.exists("D:/TEST/R/testfolder")

# ------------------------ загрузка
# данные тут взял: https://www.cbr.ru/currency_base/dynamics/?UniDbQuery.Posted=True&UniDbQuery.so=1&UniDbQuery.mode=1&UniDbQuery.date_req1=&UniDbQuery.date_req2=&UniDbQuery.VAL_NM_RQ=R01010&UniDbQuery.From=02.12.2022&UniDbQuery.To=09.12.2022
# dataTXT <- read.table(file = "hydro_chem.txt", header = TRUE)
# dataCSV <- read.table(file = "test.csv", header = TRUE, sep = ",", fileEncoding= "utf-8")
# View(dataCSV) # чтоб открыть
# colnames(dataCSV)<-c('a', 'b', 'c', 'd') #изменить названия столбцов
# dataCSV$a<-NULL #удалить столбец

# ------------------------ посмотреть графики
# class(dataCSV$b) #character, а нужно числовое чего-нибудь
# dataCSV$b <- strptime(dataCSV$b, format="%d.%m.%Y")
# class(dataCSV$c)
# dataCSV$c = as.numeric(dataCSV$c)
# class(dataCSV$c)

# ---- я тут ничего не удалял, переимпортировал
# ---- тут нужна именно точка для конвертации
# dataCSV$curs <- gsub(",", ".", dataCSV$curs)
# dataCSV$curs <- as.numeric(dataCSV$curs)
# dataCSV$data <- strptime(dataCSV$data, format="%d.%m.%Y")

# plot(dataCSV$data,dataCSV$curs, type='l', col='red', lwd=2, xlab='date', ylab='price', main='dynamic')

# ------------------------ операции
#str(dataCSV) #summary, названия, тип, количество
# head(dataCSV, 10) # начало
# tail(dataCSV, 2) # конец
#names(dataCSV) # столбцы

# cols<-dataCSV$curs
# dataCSV[1:10,1:3] # с 1 по 10 строки, с 1 по 3 колонки
# dataCSV[1:10,] # с 1 по 10 строки просто
# dataCSV[1,1]

# n<-nrow(dataCSV)
