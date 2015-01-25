library(reshape2)

activities <- c(1, 2, 3, 4, 5, 6)
activities.nm <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
extract.feat <- c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 269, 270, 271, 345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 428, 429, 503, 504, 516, 517, 529, 530, 542, 543)
extract.featnm <- c("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", "tBodyAcc-mean()-Z", "tBodyAcc-std()-X", "tBodyAcc-std()-Y", "tBodyAcc-std()-Z", "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y", "tGravityAcc-mean()-Z", "tGravityAcc-std()-X", "tGravityAcc-std()-Y", "tGravityAcc-std()-Z", "tBodyAccJerk-mean()-X", "tBodyAccJerk-mean()-Y", "tBodyAccJerk-mean()-Z", "tBodyAccJerk-std()-X", "tBodyAccJerk-std()-Y", "tBodyAccJerk-std()-Z", "tBodyGyro-mean()-X", "tBodyGyro-mean()-Y", "tBodyGyro-mean()-Z", "tBodyGyro-std()-X", "tBodyGyro-std()-Y", "tBodyGyro-std()-Z", "tBodyGyroJerk-mean()-X", "tBodyGyroJerk-mean()-Y", "tBodyGyroJerk-mean()-Z", "tBodyGyroJerk-std()-X", "tBodyGyroJerk-std()-Y", "tBodyGyroJerk-std()-Z", "tBodyAccMag-mean()", "tBodyAccMag-std()", "tGravityAccMag-mean()", "tGravityAccMag-std()", "tBodyAccJerkMag-mean()", "tBodyAccJerkMag-std()", "tBodyGyroMag-mean()", "tBodyGyroMag-std()", "tBodyGyroJerkMag-mean()", "tBodyGyroJerkMag-std()", "fBodyAcc-mean()-X", "fBodyAcc-mean()-Y", "fBodyAcc-mean()-Z", "fBodyAcc-std()-X", "fBodyAcc-std()-Y", "fBodyAcc-std()-Z", "fBodyAccJerk-mean()-X", "fBodyAccJerk-mean()-Y", "fBodyAccJerk-mean()-Z", "fBodyAccJerk-std()-X", "fBodyAccJerk-std()-Y", "fBodyAccJerk-std()-Z", "fBodyGyro-mean()-X", "fBodyGyro-mean()-Y", "fBodyGyro-mean()-Z", "fBodyGyro-std()-X", "fBodyGyro-std()-Y", "fBodyGyro-std()-Z", "fBodyAccMag-mean()", "fBodyAccMag-std()", "fBodyBodyAccJerkMag-mean()", "fBodyBodyAccJerkMag-std()", "fBodyBodyGyroMag-mean()", "fBodyBodyGyroMag-std()", "fBodyBodyGyroJerkMag-mean()", "fBodyBodyGyroJerkMag-std()")
clean.fi <- "cleaned.txt"


# Subjects filename
subjects.fi <- function(name) {
  paste("subject_", name, ".txt", sep = "")
}

# Features filename 
features.fi <- function(name) {
  paste("X_", name, ".txt", sep = "")
}

# Activities filename
activities.fi <- function(name) {
  paste("Y_", name, ".txt", sep = "")
}



#Prinitng helper function
pr <- function(...) {
  cat("[run_analysis.R->", ..., "\n")
}

# Returns an interim dataframe for a single dataset.
get.data <- function(dir, name) {
  # Setup the file paths.
  real.dir <- file.path(dir, name)
  
  
  pr("Getting datasets:", real.dir)

  # Read the features table.
  pr("  reading features...")
  features.file <- file.path(real.dir, features.fi(name))   #filename for features, in fact the "X*.txt file
  features.t <- read.table(features.file)[extract.feat]
  names(features.t) <- extract.featnm

  clean.data <- features.t

  # Read the activities list.
  pr("  reading activities...")
  activities.file <- file.path(real.dir, activities.fi(name))  #filename for activities, in fact Y.txt file
  activities.t <- read.table(activities.file)
  names(activities.t) <- c("activity")
  # changes the values in the rows with the respective names
  activities.t$activity <- factor(activities.t$activity, levels = activities, labels = activities.nm)
  clean.data <- cbind(clean.data, activity = activities.t$activity)


  # Read the subjects list.
  pr("  reading subjects...")
  subjects.file <- file.path(real.dir, subjects.fi(name))       #filename for subjects
  subjects.t <- read.table(subjects.file)                       #read the file 
  names(subjects.t) <- c("subject")                             # change the column name
  clean.data <- cbind(clean.data, subject = subjects.t$subject) #new column in result data frame

  # Return the clean data
  clean.data
}

# Performs the full analysis of both the test and train
# datasets. Writes a clean dataset to disk.
# dir is the basic directory with subdirectories train and test
run.analysis <- function(dir) {
  pr("Getting and Cleaning Data Project")
  pr("---------------------------------")

  

  # Read the data.
  p("Reading datasets.")
  test <- get.data(dir, "test")
  train <- get.data(dir, "train")

  # Join the data.
  pr("Joining datasets.")
  all.data <- rbind(test, train)

  # Reshape the data.
  pr("Long Format Melting.")
  all.data.long <- melt(all.data, id = c("subject", "activity"))
  pr("Wide Format Dcasting.")
  all.data.wide <- dcast(all.data.long, subject + activity ~ variable, mean)

  # Set the clean data.
  all.data.clean <- all.data.wide

  # Save the clean data.
  clean.fi.nm <- file.path(dir, clean.fi)
  pr("Saving clean data to:", clean.fi.nm)
  write.table(all.data.clean, clean.fi.nm, row.names = FALSE, quote = FALSE)
}

# Run the analysis.
run.analysis("./getdata/datasets")

