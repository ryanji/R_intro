
####    Title:       R Intro Workshop Data Management   ####
####    Created by:  XR Ji MERM UBC                     ####
####    Create date: Sept 23 2017                       ####
####    Last update: Sept  12 2018                      ####

### Section 1 Management ###
### set up the working directory (WD
setwd("/Users/ryanji/Documents/myworkshop/QMSupport/data") 
                               # Save the dataset in your target folder before setting up WD
                               # Directory allow you to access to your dataset easily


getwd()                        # Double check it is correct or not                 

### list the files in the directory file folder ###
dir()                          # display the files | show everything 
list.files()                   # display the files
ls()                           # display the objects 


### install and load package   ###
### demo for install package ###
install.packages("mlmRev")     # intall the package  
library(mlmRev)                # load the package
search()                       # display the installed packages 
library()                      # display the packages in library

### display information in the package ### 
library(help=mlmRev)           # show the detailed information about the pacakge
data(package="mlmRev")         # display the datasets in the mlmRev package in
ls("package:mlmRev")           # optional way

### import dataset into R ###

### import data from builtin dataset  ###
dir()
dat1<-data.frame(Hsb82)        # import data Hsb82
View(dat1)                     # view the data set 

### import data from external dataset ###

### import the ASCII file ###
dat2<-read.table("hsb12.dat")
View(dat2)                     # view the data set 
dim(dat2)

### import csv file ###
dat3<-read.csv("hsb12.csv", header = T) 
                               # header = T specify the first row as variable name
names(dat3)

### other format SPSS STATA and online dataset ###
install.packages("foreign")    # intall the "foreign" package
  require(foreign)
  library(help=foreign)

dat4<-read.spss("hsb12.sav")   # Warning: result in list rather than a data frame
dat4<-read.spss("hsb12.sav", to.data.frame = T) 
                               # read spss  as a dataset 

dat5<-read.dta("hsb12.dta")    # import stata dataset

### export dataset using R ### 
write.table(dat1, "./out1.txt", sep="\t") 
                               # export to a tab delimited text file
                               # out1.txt is the file name
                               # "./" represent the working directory
                               # "/t" tab separation
                               # this is also necessary to export to spss and sas file

write.foreign(dat1,"./out1.txt", "./outsas1", package = "SAS")
                               # generate SAS code and txt data file 
                               # read data using SAS code

write.foreign(dat1,"./out1.txt", "./outsps1", package="SPSS")
                               # generate SPSS code and txt data file
                               # read data using SPSS code

write.dta(dat1,"./outstata.dta")
                               # export to STATA file


### check the dataset ###

dim(dat1)                      # how many rows and columns 

names(dat1)                    # show the variables' names

head(dat1)                     # show the first six rows

summary(dat1)                  # give the summary statistics of every variables "dat1" is the name of the data file

str(dat1)                      # examine the types of variables


### data management with {dplyr}
install.packages("dplyr")
library(dplyr)

iris<-data.frame(iris)
View(iris)
names(iris)

##Select columns using select()
iris.data<-select(iris,Sepal.Length,Sepal.Width )
head(iris.data)

##Select all the columns except a specific column 
head(select(iris, -Species))

##Select multiple columns 
head(select(iris, Petal.Length:Species))

##Select columns with specific character string
head(select(iris, starts_with("Se")))
head(select(iris, ends_with("th")))
head(select(iris, contains("Sepal")))
head(select(iris, matches("l.W")))
head(select(iris, everything()))
vars<-c("Petal.Length", "Petal.Width")
head(select(iris, one_of(vars)))

##Select rows using filter()
filter(iris, Petal.Length < 1.3)
filter(iris, Petal.Length >= 1.2, Petal.Length <1.4)
filter(iris, Species %in% c("setosa","versicolor"), Sepal.Length ==5.2)
filter(iris, !Species %in% c("setosa","versicolor"), Sepal.Length==6.1)

##Pipe Operator %>%
head(select(iris,Sepal.Length,Sepal.Width ))

iris %>% 
  select(Sepal.Length,Sepal.Width)%>%
  head



##reorder rows using arrange()
iris %>%
  select(Sepal.Length,Sepal.Width) %>%
  arrange(desc(Sepal.Length),Sepal.Width)%>%
  head

iris %>%
  select(Sepal.Length,Sepal.Width) %>%
  arrange(desc(Sepal.Length),desc(Sepal.Width))%>%
  head

### create new column using mutate()
iris %>%
  mutate(newcol=Sepal.Length/Sepal.Width) %>%
  head

##Create summaries using sumarise()
iris %>%
  summarise(Sepal.Length.avg=mean(Sepal.Length))

## Summary statistics by group
iris %>% 
  group_by(Species) %>%
  summarise(Sepal.Length.avg = mean(Sepal.Length), 
            Sepal.Length.sd=sd(Sepal.Length),
            Sepal.Length.min = min(Sepal.Length), 
            Sepal.Length.max = max(Sepal.Length),
            total = n())


### select variable based on the variable names ####
colnames(dat3)

col<-c("ses","mathach")        # create a vector including ses and mathach    
newdat1<-dat3[col]             # only select ses and mathach
newdata1<-dat3[,col]           # note the comma can be omitted: [row, col] in R

   
newdat2<-dat3[c("ses","mathach")]
                               # combined syntax, give the same results 
newdata2<-dat3[,c("ses","mathach")]
                               # note the comma can be omitted 

### select (keep) variable based on the column number ###
as.data.frame(colnames(dat3))  # tricky way to the numeric index of column name

grep("ses", colnames(dat3))    # give the index of column name containing the "ses" 
grep("^ses$", colnames(dat3))  # give the index of column name that is exactly "ses"

newdat3<-dat3[c(4,5,6)]        # select all rows and only the 4th, 5th, and 6th columns
newdata3<-dat3[,c(4,5,6)] 

newdat4<-dat3[4:6]
newdata4<-dat3[,4:6]
  
### select (keep) variables based on the logical vector ###

keep<-names(dat3) %in% c("ses", "mathach")
keep
                               # evaluate the whether column names include the "ses" and "matach"
newdat5<-dat3[keep]
newdata5<-dat3[,keep]

### drop variables ###
### drop variables based on the logical vector ###
drop<-!keep                    # NOT "Keep"           
drop

newdat6<-dat3[,drop]           # drop variales "ses" and "mathach"
newdat7<-dat3[,!keep]          
  
newdat8<-dat3[,-4:-6]          # drop three variables col 4 to 6
newdat9<-dat3[,c(-4,-5,-6)]

temp3<-dat3
temp3$ses<-temp3$mathach<-NULL # NOT Recommend
  
### select observation ###
##select the first five observation 

newdat10<-dat3[1:5,]           # the comma ##CANNOT## be ommitted

## conditional selection
  
newdat11<-dat3[which(dat3$female==1 & dat3$mathach > 20),]
                               # select female students with math score higher than 20
                               # "file$column" extract the column from the data set 
summary(newdat11) 

## attach data file ##
attach(dat3)
newdat12<-dat3[which(female==1 & mathach > 20), ]
detach(dat3)

summary(newdat12)
  
## Selecting using the subset function
attach(dat3)
newdat13<-subset(dat3, female ==1 & mathach > 20, select = c(ses, mathach))
                                # select female students with math score higher than 20 
                                # and only keep "ses" and "mathach" columns
                                # explain the variable name
detach(dat3)

summary(newdat13)


### rename variable ###

# rename programmatically 
names(dat3)

install.packages("reshape")     # install package reshape 
require(reshape)                # load the package (Don't Foreget to load your package.)

newdat14 <- rename(dat3, c(female="gender", mathach="math"))
                                # oldname = "newname"
                                # explain this 
names(newdat14)
  
### insert new variable ###

### example 1 ###

data3<-dat3
                                # duplicate the dataset avoiding "contamination" 
data3$sum <- data3$ses + data3$mathach
                                # datafile$newvar insert the column in the data
                                # only for demo purpose The value of is nonsense
head(data3)

### example 2 ###
###col<-c("ses","mathach")      # create a vector including ses and mathach    

attach(dat3)
  data3$sum1 <- rowSums(dat3[col])
                                # calucatle the "row sum"
detach(dat3)

head(data3)

### example 3 ###
attach(dat3)
data3 <- transform(dat3,
                   sum1  = (ses + mathach), 
                   sum2  = rowSums(dat3[col]),
                   mean1 = (ses + mathach)/2,
                   mean2 = rowMeans(dat3[col])
)
                                # much more efficient way to create new variables 
detach(dat3)

head(data3)

### recode variables and create grouping variable ###
df3<-dat3

hist(dat3$ses)              
quantile(dat3$ses)              # get the cut-off value

attach(dat3)

  df3$sescat[ses > 0.602] <- "High"
  df3$sescat[ses > -0.538 & ses <= 0.602] <- "Middle"
  df3$sescat[ses <= -0.538] <- "Low"
                                # create categorical variables sescat
  
  df3$sescat<-factor(df3$sescat) 
                                # convert the the column to a factor 

### another way to create the categorical variable   
df3$sescat1 <- cut(df3$ses,
                       breaks=c(-Inf, -0.535, 0.602, Inf),
                       labels=c("low","middle","high"),
                       right = F)
 
  df3$sescat1<-factor(df3$sescat1) 

detach(dat3)

str(df3$sescat)
str(df3$sescat1)
head(df3)


### run an ONE-WAY ANOVA to test whether Math Achievement are different 
### across SES group

aggregate(df3$mathach,list(df3$sescat),mean)
                                # calculate the group mean of mathach 

fit1 <- aov(mathach ~ sescat, data=df3)
summary(fit1)
                                # run ANOVA using aov
fit2<- lm(mathach ~ sescat, data=df3)
summary(fit2)
                                # run ANOVA using linear regression 

  