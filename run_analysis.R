#############################################################################################
## File: run_analysis.R
#############################################################################################
## DATA
## data/features_info.txt    : Shows information about the variables used on the feature vector 
## data/features.txt         : List of all features.
## data/activity_labels.txt  : Links the class labels with their activity name.
## data/test/subject_test.txt: Each row identifies the subject who performed the activity for
##                             each window sample. Its range is from 1 to 30. 
## data/test/X_test.txt      : Test set.
## data/test/y_test.txt      : Test labels.
## data/train/subject_train.txt: Each row identifies the subject who performed the activity 
##                               for each window sample. Its range is from 1 to 30.
## data/train/X_train.txt    : Training set.
## data/train/y_train.txt    : Training labels.
##############################################################################################
## Include all libraries 
library(dplyr)
library(reshape2)

## Read in all the required data files
features <- read.table("./data/features.txt", sep = " ", stringsAsFactors=FALSE, header=FALSE)
activelabels <- read.table("./data/activity_labels.txt", sep = " ", stringsAsFactors=FALSE, header=FALSE)

# Read in the training Data
subject_train <- read.table("./data/train/subject_train.txt", sep = "", stringsAsFactors=FALSE, header=FALSE)
train_set <- read.table("./data/train/X_train.txt", sep = "", stringsAsFactors=FALSE, header=FALSE)
train_labels <- read.table("./data/train/y_train.txt", sep = " ", stringsAsFactors=FALSE, header=FALSE)

# Read in the test data
subject_test <- read.table("./data/test/subject_test.txt", sep = "", stringsAsFactors=FALSE, header=FALSE)
test_set <- read.table("./data/test/X_test.txt", sep = "", stringsAsFactors=FALSE, header=FALSE)
test_labels <- read.table("./data/test/y_test.txt", sep = " ", stringsAsFactors=FALSE, header=FALSE)

# Clean up the features file before applying it to the data
colnames(features) <- c("junk", "feature")
features$feature <- tolower(features$feature)

# By replacing the () with func, it sets the mean and STD that I will want later. 
features$feature <- gsub("\\(\\)", "func", features$feature)
features$feature <- gsub(",", "", features$feature)
features$feature <- gsub("\\(", "", features$feature)
features$feature <- gsub("\\)", "", features$feature)
features$feature <- gsub("-", "", features$feature)

count <- nrow(features)
## Use the features to lable the training and test sets 
for (i in 1:count)
{
   names(test_set)[i] <- features$feature[i]
   names(train_set)[i] <- features$feature[i]
} 

## Now that the data sets have proper names, great a new frame that only has the 
## columns with mean and std in them. 
colneeds <- grep("meanfunc|stdfunc", colnames(test_set))
test_setms <- test_set[ , grep("meanfunc|stdfunc", colnames(test_set))]
train_setms <- train_set[ , grep("meanfunc|stdfunc", colnames(train_set))]

## Now take care of the subject tables with name
colnames(subject_train) <- "subject"
colnames(subject_test) <- "subject"

## Now take care of the activity data sets with proper labels
colnames(activelabels) <- c("code", "activity")
colnames(train_labels) <- "activity"
colnames(test_labels) <- "activity"

## Now for each set put them together by subject, activity then the data measurements
train_final <- cbind(subject_train, train_labels, train_setms)
test_final <- cbind(subject_test, test_labels, test_setms)

## Now merge the tables together with row bind into one master table. 
fulldata <- rbind(train_final, test_final)

## While the subject and activity are int variables, good time to order the data by subject, activity to be cleaner
fulldatasort <- arrange(fulldata, subject, activity)

## Now apply the activity names to the column Activity 
count <- nrow(fulldatasort)
for (i in 1:count)
{
    fulldatasort$activity[i] <- as.character(activelabels[fulldatasort$activity[i] ,2])
}

## Now, Create a narrow version of the data with the Key being the subject and activity, samples as variables
narrowdata <- melt(fulldatasort, id=c("subject", "activity"), measure.vars=c(names(fulldatasort[3:67])))

## Create a new tidy table on the average (mean) of each type of sample set by subject and activity
tidytable <- dcast(narrowdata, subject + activity ~ variable, mean)

## Write out the table to a text file
write.table(tidytable, "./project_final_table.txt", row.name=FALSE)

 

