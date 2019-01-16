##                      Coursera Course Assisgment                  ##
##                      Getting and Cleaning Data                   ##
##                      Busayo Akinloye                             ##

# Create folder if it doesnt already exist
if(!file.exists("./startData")){
    dir.create("./startData")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/Dataset.zip")
    
    unzip(zipfile="./startData/Dataset.zip",exdir="./startData")
}

# Initialize file path
file_path <- file.path("./startData" , "UCI HAR Dataset")

# Read Activity dataset
Y_Test  <- read.table(file.path(file_path, "test" , "Y_test.txt" ),header = FALSE)
Y_Train <- read.table(file.path(file_path, "train", "Y_train.txt"),header = FALSE)

# Read Subject dataset
subject_Train <- read.table(file.path(file_path, "train", "subject_train.txt"),header = FALSE)
subject_Test  <- read.table(file.path(file_path, "test" , "subject_test.txt"),header = FALSE)

# Read Features dataset
X_Test  <- read.table(file.path(file_path, "test" , "X_test.txt" ),header = FALSE)
X_Train <- read.table(file.path(file_path, "train", "X_train.txt"),header = FALSE)

# Merge Subject, Activity and Feature datasets respectively
subject_rbind <- rbind(subject_Train, subject_Test)
activity_rbind<- rbind(Y_Train, Y_Test)
features_rbind<- rbind(X_Train, X_Test)
names(subject_rbind)<-c("subject")
names(activity_rbind)<- c("activity")
dataFeaturesNames <- read.table(file.path(file_path, "features.txt"),head=FALSE)
names(features_rbind)<- dataFeaturesNames$V2

# Merge all datasets
dataCombine <- cbind(subject_rbind, activity_rbind)
Data <- cbind(features_rbind, dataCombine)

# Get only mean and standard deviation data
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

dataNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=dataNames)

activityLabels <- read.table(file.path(file_path, "activity_labels.txt"),header = FALSE)

# Name the dataset columns
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# Create final dataset framework and write to output text file
library(plyr);
final_Data<-aggregate(. ~subject + activity, Data, mean)
final_Data<-final_Data[order(final_Data$subject,final_Data$activity),]
write.table(final_Data, file = "tidyResult.txt",row.name=FALSE)