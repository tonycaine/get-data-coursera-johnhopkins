Assessment Task CodeBook.md - tonycaine

Task is described in ReadMe.md. (link)

The workflow of the two parts are described in more detail below.
Below that are details regarding the files loaded, dataframes and other variables created, 

Preliminary step:
Data obtained from https://class.coursera.org/getdata-002/forum/thread?thread_id=271
As noted in the datafile readme and also in the forum the data is unitless. it has been scaled between -1 and +1 removing any link to base units.
Zip downloaded to local dir and unzipped to folder.

Part 1: Work flow was;
load the Activity coded and names from 'activity_labels.txt'
load the index of the Features file 'features.txt'. This contains the name of the data in each column of the test and train datafiles.
 
For the two datasets each in own dirs 'test' and 'train'.
 load the Subject data from file 'subject_test.txt'. this lists the subject by code on each row of the dataset file
 load the Activity data from the file 'y_test.txt' and  merge in the ActivityNames. the activity file lists the activity by code on each row of the dataset file.
 load the observations data from file 'X_test.txt' - of all the measurements made by the mobile phones of the subjects doing the activities.
 join these three files into one. to know which subject was doing what activity on each row.
Merge the test and the train datasets into 'alldata' dataset.
Save the data to a csv file for later reuse. File name is 'alldata.csv'

Part 2:

Work flow was;
interpret the question to mean  

start with the alldata dataframe from part 1.
Form a redcued dataframe called 'alldata2.DT' by reducing 'alldata' to just the key information of the Subjects, Activities, ActivityNames plus the '-mean()' columns.
convert to a datatable 'alldata2.DT' to use the lapply of mean() in-place and because i wanted to use data.table library.
calculate the means of the means and store the data in the data.table called 'alldata.MeanMeans'
Save the data to a csv file for later reuse. This csv file was called 'alldata.MeanMeans.csv'


Notes:

1. The Zip downloaded contained a top level folder that contains 2 folders, Test and Train. Inside these test and train folders are three files that hold together as a set. In each of the test and train folders there is also an Inertial Signals sub-folder. For the purposes of this analysis just the data in the test and train directory are analysed. the data in the was not included in analysis.

2. A requirement was to 'Uses descriptive activity names to name the activities in the data set'. This was interpreted as meaning combine in the names of the Activities that the Subjects were measured undertaken. I considered rewriting the names of the measurements recorded. I considered that this was neither in the requirements and nor was it a useful or practical exercise. If they were renamed it would make it difficult to re-interpret the data because the connection back to the raw data would be lost.

Variables:
dir: base directory where data zip had been unzipped to.

DataFrames and DataTables:

activities: Activities Subjects undertaking. nb. no subjects dataframe as not decoded to names as not provided.
features: Features 'name' and the columns they are in.
traindata: data loaded from train folder. combined with the activities and subjects info 
testdata: data loaded from test folder. combined with the activities and subjects info 
alldata: combined testdata and traindata.

alldataCols: A dataframe used to index into the 'alldata' dataframe. A extra column added in to tag the columns to keep to to select out the subject, Activity, ActivityName and all the 'mean()'- columns.

alldata2: alldata reduced by selecting columns using the keep flag of the alldataCols dataframe.
alldata2.DT: converted alldata2 to a data.table.
alldata.MeanMeans: contains the Means of the Means from alldata dataframe (via process through alldata2).

Transformations and Functions

three utility functions 
- get_features(dir) - load the file indexing the columns in the test and train data files and returns this in the features dataframe.
- get_activitynames(dir) - loads the activities and their codes so that the activities dataframe can be used to add in the activitityNames to the data.
- get_data(dir, sett_ype) - load three files to load for each of test and train. The actual source dir path is constructed and the three files loaded. During this process the ActivityNames are added in and the three files are merged into the returned dataset.

There are 2 groups of interesting functions (interest is in the eye of beholder).
1. at two steps I wanted to reduce the columns being carried. this was done by using colnames() to get column names then grepl() to find and tag the columns to keep.   The indexes of the columns to keep was then used to move these columns to new dataframe.
2. data.table plus a lapply() of mean() as used in part 2 to get the means of each of the mean columns. The details are in the comments in the R script.


