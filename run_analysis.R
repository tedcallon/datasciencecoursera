##GENERAL FYI:
##the 5 "to-do" steps listed on the assignment page do not occur 
##in the given order. It's instead 1, 4, 2, 3, 5

library(tidyr)
library(dplyr)
##read in data
#read testing set: subject numbers, 561-feature vector, activity labels
subject_test <- read.table(file = "UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table(file = "UCI HAR Dataset/test/X_test.txt")
y_test <- read.table(file = "UCI HAR Dataset/test/y_test.txt")


#read training set: subject numbers, 561-feature vector, activity labels
subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
y_train <- read.table(file = "UCI HAR Dataset/train/y_train.txt")



#combine dataframes into single dataframe (step 1)
test_set <- cbind(subject_test, X_test, y_test)
train_set <- cbind(subject_train, X_train, y_train)

full_set <- rbind(test_set, train_set)



#create column names for the full set (step 4)
column_labels <- read.table(file = "UCI HAR Dataset/features.txt")
vecNames <- as.character(column_labels[,2]) #use names given in the features.txt file
fullNames <- c("SubjectID", vecNames, "Activity")

colnames(full_set) <- fullNames



#remove columns that are unrelated to mean and st. dev. (step 2)
## find indices for columns with the phrase mean and std in it, but remove
## columns that show the "mean frequency" of an observation
keepColumns <- which((grepl("mean", fullNames) | 
                         grepl("std", fullNames)) & 
                         !grepl("meanFreq", fullNames))
full_set <- full_set[,c(1,keepColumns,563)]



#give activities descriptive names in "Activity" col (step 3)
actLables <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)

#give names listed in the activity label file
for(i in 1:nrow(actLables)) {
    full_set[full_set$Activity == i,"Activity"] <- actLables[i,2]
}



#Create an independent tidy data set with the average of each variable
#for each activity and each subject (step 5)

#reorder columns
full_set <- cbind(full_set[,ncol(full_set)], full_set[,-ncol(full_set)])
colnames(full_set)[1] <- "Activity"

## create the dataframe
newDF <- data.frame()
actLables <- arrange(actLables, V2)

#subsets the full set by unique activities, then takes the mean of each
#measurement after grouping by subjectID, then inputs this result together
#with the others into a dataframe
for (i in 1:nrow(actLables)) {
    temp <- subset(full_set, full_set$Activity == actLables[i,2])
    grouped <- group_by(temp, SubjectID)
    hold <- summarize_at(grouped, c(2:(ncol(grouped)-1)), mean)
    hold <- cbind(grouped[nrow(hold),"Activity"], hold)
    newDF <- rbind(newDF, hold)
}

##relabel the dataframes columns
newNames <- colnames(full_set)
colnames(newDF)[c(3:length(newNames))] <- paste0("Mean_of_",newNames[c(3:(length(newNames)))])

##write table to file
write.table(newDF, file = "step5table.txt", row.names = F)

