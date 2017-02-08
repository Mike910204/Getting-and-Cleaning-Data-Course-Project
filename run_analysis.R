#Librerias
library(dplyr)
library(reshape2)
library(tidyr)
library(plyr)

#Set the working directory (modify to the directory needed, the files should be there)
setwd("C:/Users/aguimi05/Documents/R/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/")

##Read files from training and test

#Labels
activity_labels<-read.table("activity_labels.txt",col.names=c("Activity","Activity_Name"))

train_labels<-data.frame(read.table("train/y_train.txt",col.names="Activity"),stringsAsFactors=FALSE)
test_labels<-data.frame(read.table("test/y_test.txt",col.names="Activity"),stringsAsFactors=FALSE)


#SETS
train_trainig_set<-data.frame(read.table("train/X_train.txt"),stringsAsFactors=FALSE)
test_trainig_set<-data.frame(read.table("test/X_test.txt"),stringsAsFactors=FALSE)

#Subjects
train_subject<-data.frame(read.table("train/subject_train.txt",col.names="Person"),stringsAsFactors=FALSE)
test_subject<-data.frame(read.table("test/subject_test.txt",col.names="Person"),stringsAsFactors=FALSE)

unique(train_labels)

#union subject-labels
train_set<-cbind(train_labels,train_subject)
train_set<-cbind(train_set,train_trainig_set)
test_set<-cbind(test_labels,test_subject)
test_set<-cbind(test_set,test_trainig_set)

#Features' names
features<-read.table("features.txt",head=FALSE)
subfeatures<-c("Activity","Person",as.character(features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]))
features<-features[,2]
features<-as.character(features)
features<-as.character(c("Activity","Person",features))
subfeatures<-as.character(subfeatures)

#name data set
names(test_set)<-features
names(train_set)<-features

#Merge labels
test_set<-subset(test_set,select=subfeatures)
train_set<-subset(train_set,select=subfeatures)
test_set<-left_join(test_set,activity_labels,by="Activity")
train_set<-left_join(train_set,activity_labels,by="Activity")
a<-c(names(test_set),"Tipo")
b<-c(names(test_set),"Tipo")
e<-names(train_set[,3:68])
test_set<-mutate(test_set,Tipo="Test")
train_set<-mutate(train_set,Tipo="Train")
data_set<-rbind(test_set,train_set)
data_set<-select(data_set,-c(1,70))

#Average of each variable for each activity and each subject.
data_set<-aggregate(. ~Person + Activity_Name, data_set, mean)
data_set<-data_set[order(data_set$Person,data_set$Activity_Name),]
View(data_set)
write.table(data_set,file="data_set.txt",row.names = FALSE)
