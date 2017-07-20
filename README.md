# ReadMe

In this project, wearable computing data gathered from the accelerometers from the Samsung Galaxy S smartphone was taken in its relatively raw form and cleaned and tidied. As described in the instructions, the necessary steps to take were: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Coding Process:

The ordering of the process, as commented in the code, diverged from the recommended ordering and instead went 1, 4, 2, 3, 5.
This ordering seemed simpler than the offered one, because I could directly move the given 561 feature-vector names from the features.txt file into the feature vector data column names without having to adjust anything, and I could use those names to accurately remove the unnecessary columns. 

### Step 1:
The three separate parts of the test and training set were read in (subject ID number, the feature vector, the activity results) and combined before than being combined together to create one full set (dataframe named full_set).

### Step 4:
The names of the different columns in the feature vector were taken from features.txt and placed into a variable named vecNames. Due to the ordering with which the full_set was created, vecNames became fullNames by adding "SubjectID" at the beginning of the character vector, and "Activity" at the end, to correctly label the two non feature-vecotr columns. THe columns in full_set were then named using this character vector.


### Step 2:
the which() and grepl() methods were used to find the indices for the columns that contained the word mean and std. After discluding the columns that had "meanFreq", since this measured something other than the mean of the measurement, these indices were used to remove all columns that were deemed unnecessary to keep by the instructions.


### Step 3: 
After reading in the descriptive labels for each activity from the activity_labels.txt a for-loop was used to set each activity to its given label.


### Step 5:
I couldn't figure out how to make two different groupings (i.e. group by activity and by subjectID) using the group_by method from dplyr, so instead I used a for-loop to subset the dataframe by activity, and then using the group_by method within the for-loop, I grouped by subjectID. This allowed for the average to be found for each activity for each subject using the summarize_at() method (same as summarize() but skips the non-numeric rows). The result of summarize was added to a new dataframe and together created the tidy dataframe requested. 
