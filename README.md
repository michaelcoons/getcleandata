### Introduction

This is the project for the Getting and Cleaning data course. 
The repository here contains three files.
1. README.md: Markdown file that explain the repository and the content of
              the files
2. CodeBook.txt: A text file code book for the "project_final_table.txt"
3. run_analysis.R: R script that was used to analyze the source data and
   generate a new tity data set. 

### Tidy Data Set
The data set table in the file "project_final_table.txt" is considered "tidy"
The reason for this is described below keying off the definition presented in
the course
1. Each variable in one column
   This is true since the key is 2 columns of subject then activity type
   Each numeric value is a mean representation of samples from ONLY that one 
   sample type and no others.
2. Each observation is in 1 row.
   Every mean value of the sample type is associate to a single subject and 
   activity. 
3. One table for each kind of variable
   This is a table of consistent variable representation. Mean of samples. 
   There is no other calcuation type represented in the table. 
4. Multi-tables have linked column.
   This is a single table result with no other tables reprented in the 
   analysis so no linked column is needed nor was added. 


To Read the table and view you will need to have access to the student project 
submission as a teacher or peer reviewer. From there you can download the table.
Then you can read the table with the read.table function in R. Suggest that you
include "header = TRUE"

Final note on the labels of the samples. These are modifications of the 
original feature names that were tidied and then modified with a "func" name
in place of "()" for easy selection. The data represented are "means" of all
the samples of that specific subject/activity but since mean was already in
the sample names, for simplicity of reading the columns, "mean" was not added
a second time. For more details on the data names, see the Code Book in the
repository. 

### Code Book
This is the code book for the data set. It is a text file. 

### R Script run_analysis.R
Below is a high level description of the analysis script and how it works. 

1. First included necessary libraries dplyr and reshape2

2. All the data was stored into a "data" directory off the working directory

3. Read in all the files into initial data frames

4. It was critical to use the feature file to name the columns of the data
   sets but it was untidy so it was cleaned up by
   4.1 Replacing "()" with "func" for function. This was the most critical
       replacement since there were other feature names that contained 
       "mean" that were not the mean variables that I wanted.
   4.2 Removed all remaining "(", ")", ",", "-"
   4.3 Made the data lower case. 

5. Then the tidy feature names were used to name the columns of the train
   and test data sets. 

<!-- -->

    count <- nrow(features)
    for (i in 1:count)
    {
       names(test_set)[i] <- features$features[i]
       names(train_set)[i] <- features$features[i]
    }


6. At this point it was easy to take only the sample columns I wanted using
   grep on the values "meanfunc" OR "stdfunc"

7. The reset of the data frames were labeled before any combining occured. 

8. To create the full train data set and test data set the same steps were used
   8.1 Column bind the 3 proper data frames for each by subject, activity, and 
       data 

9. At this point both the train and test data sets were merged using row bind.

10. The combined table was ordered into sorted logic keys using arrange on the 
    subject column followed by the activity column. The columns were left 
    numeric at this point for ease and correctness in the sort.

11. Now changing the activity column from numeric codes to character 
    descriptions was done. The final column needed to be character so the code
    below was used in a loop from 1 though row length of data. This used the
    activity code in the data column as a match to the code in the activity
    table. This got the correct row and then the description in col 2 was pulled.

<!-- -->

    fulldatasort$activity[i] <- as.character(activelabels[fulldatasort#activity[i] ,2])

12. At this point we had all the information in the correct format to make the
    final data frame. This was created by:
    12.1 Take the wide data into a narrow representation using melt with 
         "subject" and "activity" as the ID and the rest of the columns as 
	 the measurements. 
    12.2 Then create the tidy, final table using dcast and applying the mean()
         function on the sample variables. 

13. Write the table out with row names = FALSE per the assignment. 

14. End of project. 

### READING AND VIEWING THE TABLE
To read the table itself please use the following steps,
1. Download the "project_final_table.txt" from the Project review section.
2. Place the file into your local R working directory. 
3. Use the read.table command with headers = TRUE 
4. Run View() on the resulting dataframe. 
