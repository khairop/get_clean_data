### Run Analysis Description

The cleanup script does the following using rshape2 package:

    Reading the resepctive data sets two times (one for test and another for train)
    Uses descriptive activity names  for the receving the data set
    Merges the respective training and the test sets to create one data set.
    Subestting only the measurements on the mean and standard deviation
    Appropriately labels the final categorical labels using factor commmand
    Reshape the data set two times (using melt and dcast function) to the requested format
    Creates a second, independent tidy data set with the average of each variable for each activity and each subject.



### Source Code Description

    Define the values tables, listed in CodeBook.md
    Features data are stored in X* files and we extract this information
    Activites data are stored in Y* files and we extract this information
    For both the test and train datasets, produce an interim dataset:
        Extract the mean and standard deviation features based on values tables.  table.
        Get the list of features and put into interim data table
        Get the list of activities, put the activity labels (not numbers) into interim data table.
        Get the list of subjects and put subject IDs into the interiam data table.
    Join the test and train interim datasets into a final one
    Create a "long" data set with the melt command using the pair subject/activity
    Create a "wide" data set with the dcast command applying the mean function for the pair subject/activity. This is the final data set
    Writing the final data set on disk.



### Executing the script

To run the script, source("run_analysis.R") which includes also the run command at the end. 
After running is completed, the destination file named tidydata.txt is created. Several info messages are printed in the console during execution



### Cleaned Data Set

The source data (test data have  2947 rows and train data have 7352 rows)  
The resulting clean dataset is the file in this repository at: datasets/tidydata.txt, in total 181 rows.  
It contains one row for each subject/activity pair and columns for subject, activity, and each feature with mean and standard deviation
