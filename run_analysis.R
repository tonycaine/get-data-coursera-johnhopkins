#author: Tony Caine
#date  : April 2014
#purpose: manipulate Samsung data to create 2 data frames for Coursera Course
#         https://class.coursera.org/getdata-002

library(plyr)
library(data.table)

#zips extracted to this location
#and 'dir' is used to build paths to data to load
dir<-'C:/_store/@stats/data-course/get-data/assessment/data/UCI HAR Dataset'

#load the features file - contains the column index and title of all the movement data
#
get_features <- function(basepath) {
  #load the features names
  
  featuresfile<-paste(dir,'/features.txt',sep='')
  features <- read.table(featuresfile, header=FALSE)
  colnames(features) <- c("ColumnNumber", "VariableName")
  
  #of all these only wish to keep a few
  #requirement is to Keep the columns that are -mean() or _std()
  #regular expression below adds that Keep flag to the dfFeatures dataframe
  #nb: deliberately excluding those that are not pure -mean()
  # eg. meanfreq as these are a subset of group that contains a mean already
  features$Keep<-grepl('-mean\\(|-std\\(', features$VariableName , ignore.case=TRUE, fixed=FALSE, perl=TRUE)
  
  return(features)
}

get_activitynames <- function(basepath) {
  #load the activity names to look up the meaning of activities in test and train data
  
  activitesfile<-paste(dir,'/activity_labels.txt',sep='')
  activities <- read.table(activitesfile, header=FALSE)
  colnames(activities) <- c("Activity", "ActivityName")
  
  return(activities)
}

get_data <- function(basepath, set_type ){
  
  #make the file names for 3 files in dir
  #ignoring the Inertial Signals files - see readme.md
  #
  subjectfile<-paste(dir,'/',set_type,'/subject_',set_type,'.txt', sep='')
  activityfile<-paste(dir,'/',set_type,'/y_',set_type,'.txt', sep='')
  datafile<-paste(dir,'/',set_type,'/X_',set_type,'.txt', sep='')
  
  #get the data
  subjectdata <-read.table(subjectfile, header=FALSE)
  activitydata<-read.table(activityfile, header=FALSE)
  data <- read.table(datafile, header=FALSE, sep="")
  
  #clean house and label data with names
  colnames(subjectdata)<-c('Subject')
  colnames(activitydata)<-c('Activity')
  #
  #add in the activitynames with the Activity codes so have meaningful Activities
  #using plyr.join()
  activitydata<-join(activitydata, activities, by="Activity")
  
  #apply the Feature names to the Data - before delete unwanted columns
  colnames(data)<-features[,'VariableName']
  #then
  #reduce down to the means and std columns
  data<-data[ , features$ColumnNumber[ which(features$Keep==TRUE)]]
  
  #combine these three dataframes into one
  data<-cbind(subjectdata, activitydata, data)
  
  return(data)
}

#main routine starts here

#load the features information to use to label the data columns
features<-get_features(dir)
#load info about the activities
activities<-get_activitynames(dir)

#nb two dataframes above are used in the get_data()
  
#load the two data sets
testdata<-get_data(dir, 'test')
traindata<-get_data(dir, 'train')

#combine into a single dataframe
alldata <-rbind(traindata,testdata)

#Step3/4 done
#Save the combined file to a csv file for submission or later use
write.csv(alldata, file='alldata.csv', row.names=FALSE)


#Step 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#approach taken is to use data.table


#    A. Meaningless to take mean of std() cols
#         so for fun remove them.
#         and then the mean of the means will be calculated

#only want to keep the Activity|ActivityName and the columns with mean ()
#so build a dataframe of the columns in the alldata
#
alldataCols<-as.data.frame(colnames(alldata))
colnames(alldataCols)<-c('Name')
alldataCols$Number<-as.numeric(row.names(alldataCols))
#
#and add a Keep(er) column  using regex 
alldataCols$Keep<-grepl('-mean\\(|Subject|Activity|ActivityName', alldataCols$Name , ignore.case=TRUE, fixed=FALSE, perl=TRUE)
#
#reduce down to the these Kept columns
alldata2<-alldata[ , alldataCols$Number[ which(alldataCols$Keep==TRUE)]]

#    B. use a data.table approach to get the means accross this reduced table
#
alldata2.DT <- data.table(alldata2)
setkey(alldata2.DT, Subject,ActivityName)

#from data.table help
#.SD is constructed as containing the Subset of x's Data for each group, excluding any columns used in by
#lapply signature is lapply(X, FUN, ...) where X is data to apply FUN on
# lapply(.SD,mean) gets the columns one by one and applies the mean()
#
#the result is the mean of the means from the alldata dataframe so
alldata.MeanMeans <- alldata2.DT[, lapply(.SD,mean), by=list(Subject,ActivityName)]

#Save the summary file to a csv file for submission or later use
write.csv(alldata.MeanMeans, file='alldata.MeanMeans.csv', row.names=FALSE)

