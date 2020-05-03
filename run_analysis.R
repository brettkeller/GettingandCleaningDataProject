#### Set working directory and set up files 

  setwd("C:/Users/Brett/Dropbox/Current Projects/R & Stata projects/CoursEra Data Science/Cleaning Data project")
  
  library(reshape2)
  
  file <- "getdata_dataset.zip"

###### Download, unzip dataset
  if (!file.exists(file)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,file,method="curl")
  }  
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(file) 
  }

##### Load labels and features
  labels <- read.table("UCI HAR Dataset/activity_labels.txt")
  labels[,2] <- as.character(labels[,2])
  
  features <- read.table("UCI HAR Dataset/features.txt")
  features[,2] <- as.character(features[,2])

##### Load the datasets from test subfolder
  test <- read.table("UCI HAR Dataset/test/X_test.txt")[featurescore]
  
  testact <- read.table("UCI HAR Dataset/test/Y_test.txt")
  testsub <- read.table("UCI HAR Dataset/test/subject_test.txt")
  
  test <- cbind(testsub, testact, test)

##### Load the datasets from train subfolder
  train <- read.table("UCI HAR Dataset/train/X_train.txt")[featurescore]
  
  trainact <- read.table("UCI HAR Dataset/train/Y_train.txt")
  trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt")
  
  train <- cbind(trainsub, trainact, train)
  
##### Extract mean and SD from features dataset
  featurescore <- grep(".*mean.*|.*std.*", features[,2])
  
  featurescore.names <- features[featurescore,2]
  featurescore.names = gsub('-mean', 'Mean', featurescore.names)
  featurescore.names = gsub('-std', 'Std', featurescore.names)
  featurescore.names <- gsub('[-()]', '', featurescore.names)
  
##### Merge datasets together
  all <- rbind(train, test)
  colnames(all) <- c("sub", "act", featurescore.names)

##### Turn act & sub into factors 
  all$act <- factor(all$act, levels = labels[,1], labels = labels[,2])
  all$sub <- as.factor(all$sub)
  all.melted <- melt(all, id = c("sub", "act"))
  all.mean <- dcast(all.melted, sub + act ~ variable, mean)

#### write table with overall results
  write.table(all.mean, "tidy.txt", row.names = FALSE, quote = FALSE)