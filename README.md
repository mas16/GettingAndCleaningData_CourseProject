# Peer-graded Assignment: Getting and Cleaning Data Course Project
This is my submission for the Peer-graded assignment as part of the Getting and Cleaning Data course. In this repo you will find the following files:

`run_analysis.R`  
`tidy.txt`  
`CODEBOOK.md`

## run_analysis.R
The `run_analysis.R` script generates a "tidy" dataset from the raw data. It takes approximately 20s to run on a 1.3 GHz Intel Core i5 MacBook Air with 4 GB 1600 MHz DDR3 memory. Specifically, `run_analysis.R`  performs the following:   

1. Checks if the dataset is in the working directory and if it is not, downloads it and unzips it (note: this script is setup to work on macs (uses curl)).  

2. Loads the activity names and features data: `activity_labels.txt` and `features.txt`, respectively.

3. Loads the test set data: `X_test.txt`, `y_test.txt`, and `subject_test.txt`  

4. Loads the training set data: `X_train.txt`, `y_train.txt`, and `subject_train.txt`

5. Merges the test and training datasets into one data set

6. Extracts only measurements that are mean and standard deviation (std)

7. Adds descriptive activity names to the data set

8. Labels the dataset with appropriate, descriptive variable names

9. Creates a "tidy" dataset with the average of each variable for each activity and each subject and writes it to `tidy.txt`
 
10. Reports the amount of time the script took to execute

## CODEBOOK.md
This is the codebook that lists all of the variable names used in `tidy.txt`
