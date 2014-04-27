# Assessment Task CodeBook.md - tonycaine

Task is described in [(readme.md)](README.md).

The workflow of the two parts are described in more detail below.
Below that are details regarding the files loaded, dataframes and other variables created. 

###Preliminary:
- Data obtained from 
- [https://class.coursera.org/getdata-002/forum/thread?thread_id=271](https://class.coursera.org/getdata-002/forum/thread?thread_id=271)
As noted in the datafile readme and also in the forum the data is unitless. it has been scaled between -1 and +1 removing any link to base units.
- Zip downloaded to local dir and unzipped to folder.

###Part 1: Work flow was;
- load the Activity coded and names from 'activity_labels.txt'
- load the index of the Features file 'features.txt'. This contains the name of the data in each column of the test and train datafiles.
 
For the two datasets each in own dirs 'test' and 'train'.

- load the Subject data from file 'subject_test.txt'. this lists the subject by code on each row of the dataset file
- load the Activity data from the file 'y_test.txt' and  merge in the ActivityNames. the activity file lists the activity by code on each row of the dataset file.
- load the observations data from file 'X_test.txt' - of all the measurements made by the mobile phones of the subjects doing the activities. Use the features dataframe to label the columns.
- join these three files into one so can see easily which subject was doing what activity on each row.
- Merge the test and the train datasets into 'alldata' dataset.
- Save the data to a csv file for later reuse. File name is 'alldata.csv'

###Part 2: Work flow was;
interpret the question as 'take the means of the mean-() columns'. Taking the means of the '-std()' columns was meaningless and not as much fun.

- start with the alldata dataframe from part 1.
- Form a reduced dataframe called 'alldata2.DT' by reducing 'alldata' to just the key information of the Subjects, Activities, ActivityNames plus the '-mean()' columns.
- convert to a datatable 'alldata2.DT' to use the lapply of mean() in-place and because i wanted to use data.table library.
- calculate the means of the means and store the data in the data.table called 'alldata.MeanMeans'
- Save the data to a csv file for later reuse. This csv file was called 'alldata.MeanMeans.csv'


###Notes:

1. The Zip downloaded contained a top level folder that contains 2 folders, Test and Train. Inside these test and train folders are three files that hold together as a set. In each of the test and train folders there is also an Inertial Signals sub-folder. For the purposes of this analysis just the data in the test and train directory are analysed. the data in the 'Inertial Signals' dir was not included in analysis.

2. A requirement was to 'Uses descriptive activity names to name the activities in the data set'. This was interpreted as meaning combine in the names of the Activities that the Subjects were measured undertaking. I considered rewriting the names of the measurements recorded, but then considered that this was neither in the requirements and nor was it a useful or practical exercise. If they were renamed it would make it difficult to re-interpret the data because the connection back to the raw data would be lost.

### Variables:
dir: base directory where data zip had been unzipped to.

###DataFrames and DataTables:

- activities: Activities Subjects undertaking. nb. no subjects dataframe as not decoded to names as not provided. (6 rows, 2 variables ("Activity"     "ActivityName"). from source data)
 
- features: Features details the 'name' of data measured and the column that data is in in the source data. Keep added to flag if wanted to keep this data for this analysis.  (561 rows, 3 variables ("ColumnNumber" "VariableName" "Keep" ). from source data)

- traindata: data loaded from train folder. combined with the activities and subjects info. (7352 rows, 69 variables. (see below for column names)) 
- testdata: data loaded from test folder. combined with the activities and subjects info (2947 rows, 69 variables. (see below for column names)) 
- alldata: combined testdata and traindata. (10299 rows, 69 variables. (see below for column names)) 

- alldataCols: A dataframe used to index into the 'alldata' dataframe. A extra column (Keep) added in to tag the columns required to keep. This used to select the Subject, Activity, ActivityName and all the 'mean()'- columns. (69 rows, 3 variables ("Name"   "Number" "Keep"))

- alldata2: alldata reduced by selecting columns using the keep flag of the alldataCols dataframe. (10299 rows, 36 variables. (see below for column names)) 
- alldata2.DT: converted alldata2 to a data.table. (10299 rows, 36 variables. (see below for column names))

- alldata.MeanMeans: contains the Means of the Means from alldata dataframe (via process through alldata2). (180 rows, 36 variables. (see below for column names))

###Transformations and Functions

#####three utility functions 
- get_features(dir) - load the file indexing the columns in the test and train data files and returns this in the features dataframe.
- get_activitynames(dir) - loads the activities and their codes so that the activities dataframe can be used to add in the activitityNames to the data. Return the activities dataframe.
- get_data(dir, set_type) - load three files  for each of test and train. The actual source dir path is constructed using the base 'dir' and the 'set_type' variables and the three files loaded. During this process the ActivityNames are added in and the three files are merged into the returned dataset.

#####There are 2 groups of interesting functions (interest is in the eye of beholder).
- at two steps I wanted to reduce the columns being carried. this was done by using colnames() to get column names then grepl() to find and tag the columns to keep.   The indexes of the columns to keep was then used to move these columns to new dataframe.
- data.table plus a lapply() of mean() as used in part 2 to get the means of each of the mean columns. The details are in the comments in the R script.

----
##### column names of the testdata, traindata and alldata datasets.

 [1] "Subject"                    
 [2] "Activity"                   
 [3] "ActivityName"               
 [4] "tBodyAcc-mean()-X"          
 [5] "tBodyAcc-mean()-Y"          
 [6] "tBodyAcc-mean()-Z"          
 [7] "tBodyAcc-std()-X"           
 [8] "tBodyAcc-std()-Y"           
 [9] "tBodyAcc-std()-Z"           
[10] "tGravityAcc-mean()-X"       
[11] "tGravityAcc-mean()-Y"       
[12] "tGravityAcc-mean()-Z"       
[13] "tGravityAcc-std()-X"        
[14] "tGravityAcc-std()-Y"        
[15] "tGravityAcc-std()-Z"        
[16] "tBodyAccJerk-mean()-X"      
[17] "tBodyAccJerk-mean()-Y"      
[18] "tBodyAccJerk-mean()-Z"      
[19] "tBodyAccJerk-std()-X"       
[20] "tBodyAccJerk-std()-Y"       
[21] "tBodyAccJerk-std()-Z"       
[22] "tBodyGyro-mean()-X"         
[23] "tBodyGyro-mean()-Y"         
[24] "tBodyGyro-mean()-Z"         
[25] "tBodyGyro-std()-X"          
[26] "tBodyGyro-std()-Y"          
[27] "tBodyGyro-std()-Z"          
[28] "tBodyGyroJerk-mean()-X"     
[29] "tBodyGyroJerk-mean()-Y"     
[30] "tBodyGyroJerk-mean()-Z"     
[31] "tBodyGyroJerk-std()-X"      
[32] "tBodyGyroJerk-std()-Y"      
[33] "tBodyGyroJerk-std()-Z"      
[34] "tBodyAccMag-mean()"         
[35] "tBodyAccMag-std()"          
[36] "tGravityAccMag-mean()"      
[37] "tGravityAccMag-std()"       
[38] "tBodyAccJerkMag-mean()"     
[39] "tBodyAccJerkMag-std()"      
[40] "tBodyGyroMag-mean()"        
[41] "tBodyGyroMag-std()"         
[42] "tBodyGyroJerkMag-mean()"    
[43] "tBodyGyroJerkMag-std()"     
[44] "fBodyAcc-mean()-X"          
[45] "fBodyAcc-mean()-Y"          
[46] "fBodyAcc-mean()-Z"          
[47] "fBodyAcc-std()-X"           
[48] "fBodyAcc-std()-Y"           
[49] "fBodyAcc-std()-Z"           
[50] "fBodyAccJerk-mean()-X"      
[51] "fBodyAccJerk-mean()-Y"      
[52] "fBodyAccJerk-mean()-Z"      
[53] "fBodyAccJerk-std()-X"       
[54] "fBodyAccJerk-std()-Y"       
[55] "fBodyAccJerk-std()-Z"       
[56] "fBodyGyro-mean()-X"         
[57] "fBodyGyro-mean()-Y"         
[58] "fBodyGyro-mean()-Z"         
[59] "fBodyGyro-std()-X"          
[60] "fBodyGyro-std()-Y"          
[61] "fBodyGyro-std()-Z"          
[62] "fBodyAccMag-mean()"         
[63] "fBodyAccMag-std()"          
[64] "fBodyBodyAccJerkMag-mean()" 
[65] "fBodyBodyAccJerkMag-std()"  
[66] "fBodyBodyGyroMag-mean()"    
[67] "fBodyBodyGyroMag-std()"     
[68] "fBodyBodyGyroJerkMag-mean()"
[69] "fBodyBodyGyroJerkMag-std()"

##### column names for alldata2,  alldata2.DT and alldata.MeanMeans

 [1] "Subject"                    
 [2] "Activity"                   
 [3] "ActivityName"               
 [4] "tBodyAcc-mean()-X"          
 [5] "tBodyAcc-mean()-Y"          
 [6] "tBodyAcc-mean()-Z"          
 [7] "tGravityAcc-mean()-X"       
 [8] "tGravityAcc-mean()-Y"       
 [9] "tGravityAcc-mean()-Z"       
[10] "tBodyAccJerk-mean()-X"      
[11] "tBodyAccJerk-mean()-Y"      
[12] "tBodyAccJerk-mean()-Z"      
[13] "tBodyGyro-mean()-X"         
[14] "tBodyGyro-mean()-Y"         
[15] "tBodyGyro-mean()-Z"         
[16] "tBodyGyroJerk-mean()-X"     
[17] "tBodyGyroJerk-mean()-Y"     
[18] "tBodyGyroJerk-mean()-Z"     
[19] "tBodyAccMag-mean()"         
[20] "tGravityAccMag-mean()"      
[21] "tBodyAccJerkMag-mean()"     
[22] "tBodyGyroMag-mean()"        
[23] "tBodyGyroJerkMag-mean()"    
[24] "fBodyAcc-mean()-X"          
[25] "fBodyAcc-mean()-Y"          
[26] "fBodyAcc-mean()-Z"          
[27] "fBodyAccJerk-mean()-X"      
[28] "fBodyAccJerk-mean()-Y"      
[29] "fBodyAccJerk-mean()-Z"      
[30] "fBodyGyro-mean()-X"         
[31] "fBodyGyro-mean()-Y"         
[32] "fBodyGyro-mean()-Z"         
[33] "fBodyAccMag-mean()"         
[34] "fBodyBodyAccJerkMag-mean()" 
[35] "fBodyBodyGyroMag-mean()"    
[36] "fBodyBodyGyroJerkMag-mean()"