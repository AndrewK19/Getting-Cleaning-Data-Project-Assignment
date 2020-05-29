# Data Introduction
- This project will use six data, which are `x_train.txt`, `x_test.txt`, `y_train.txt`, `y_test.txt`, `subject_train.txt` and `subject_test.txt`, they can all be found inside the downloaded dataset, namely **URI HAR Dataset**.
- The `features.txt` contains the correct variable name, which corresponds to each column of `x_train.txt` and `x_test.txt`. Further explanation of each feature is in the `features_info.txt`. 
- The `activity_labels.txt` contains the desciptive names for each activity label, which corresponds to each number in the `y_train.txt` and `y_test.txt`.
- The `README.txt` is the overall desciption about the overall process of how publishers of this dataset did the experiment and got the data result.

# Course Project Introduction
The script `run_analysis.R` uses the `data.table` package for renaming column and reading in files. It performs 5 major steps including:


1. Merges the training and the test sets to create one data set. (In the following the word data means both train and test).
The `x_data.txt`, `y_data.txt`, `subject_data.txt` should be binded by row, and after that all three of them should binded by column.


2. Extracts only the measurements on the mean and standard deviation for each measurement. 
For the column of `x_data.txt`, extract only the ones that have mean() or std() in their names, compare it with `feature.txt`.


3. Uses descriptive activity names to name the activities in the data set.
Match each number in the `y_data` column with `activity_labels.txt`.


4. Appropriately labels the data set with descriptive variable names. 
Rename the column of `y_data` and `subject_data`, instead of using the default name given by R.


5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.   
Write out the tidy dataset to `averagedata.txt`.

# Final Data Set Creation

1. **Download the dataset**
    - Dataset downloaded and extracted under the folder called `UCI HAR Dataset`

2. **Assign each `data.txt` file to variables**
- `features` <- `features.txt` : 561 rows, 2 columns
    - *The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals             tAcc-XYZ and tGyro-XYZ.*
- `activities` <- `activity_labels.txt` : 6 rows, 2 columns
   - *List of activities performed when the corresponding measurements were taken and its codes (labels)*
- `subject_test` <- `test/subject_test.txt` : 2947 rows, 1 column
   - *contains test data of 9/30 volunteer test subjects being observed*
- `x_test` <- `test/X_test.txt` : 2947 rows, 561 columns
   - *contains recorded features test data*
- `y_test` <- `test/y_test.txt` : 2947 rows, 1 columns
   - *contains test data of activities’code labels*
- `subject_train` <- `test/subject_train.txt` : 7352 rows, 1 column
   - *contains train data of 21/30 volunteer subjects being observed*
- `x_train` <- `test/X_train.txt` : 7352 rows, 561 columns
   - *contains recorded features train data*
- `y_train` <- `test/y_train.txt` : 7352 rows, 1 columns
    - *contains train data of activities’code labels*

3. **Merges the training and testing data to create one data set**
- `xdata` is created by merging `x_train` and `x_test` using the `bind_rows()` function
- `ydata` is created by merging `y_train` and `y_test` using the `bind_rows()` function
- `subjectdata` is created by merging `subject_train` and `subject_test` using the `bind_rows()` function
- `xdata` column names are assigned using the `features$functions` subset
- `mergeddata` is created by merging `xdata`, `ydata`, and `subjectdata` using the `bind_cols()` function

4. **Extracts only the measurements on the mean and standard deviation for each measurement.**
- Use the `gprep()` function to find all column names with the exact match of `mean()` and `std()` and assign
    to the variable `featuresnames`
- Create new `tidydata` set with the columns `subject`, `code`, and all the `mean()` / `std()`
- Check to ensure the `dim()` and `names()` match the required data set with 10299 rows and 68 columns

5. **Uses descriptive activity names to name the activities in the data set and rename column.**
- Subset the `activites` variable to pull the activity names and use the `rename()` function to assign
   the subsetted activites to the corresponding `code` value.

6. **Appropriately labels the data set with descriptive variable names.**
- Use the `gub()` function to properly label all variables with the correct descriptions.
    + *prefix t is replaced by time*
    + *Acc is replaced by Accelerometer*
    + *Gyro is replaced by Gyroscope*
    + *prefix f is replaced by frequency*
    + *Mag is replaced by Magnitude*
    + *BodyBody is replaced by Body*

7. **From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**
- Use the `dplyr()` package to `chain` commands together to take the `tidydata` data set and `group_by()` the `subject` and `activity` columns. Then use the `summarize_all()` to calculate the `mean()` of all the `xdata` and `ydata` columns. 
- Check to see `if` the file `averagedata.txt` exists, and `if` not, then create a new text document with the `write.table()` function and save it in the active directory. 

**Now the final data set `averagedata.txt` contains the averaged values for each `mean()` and `std()` variable for each `subject` and `activity`.**