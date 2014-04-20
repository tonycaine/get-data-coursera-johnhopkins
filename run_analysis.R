dir<-'C:/_store/@stats/data-course/get-data/assessment/data/UCI HAR Dataset'

get_fieldnames <- function(basepath) {
  #load the field names
  
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
  
  #make the file names
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
  #apply the Feature names to the Data - before delete unwanted columns
  colnames(data)<-features[,'VariableName']
  #reduce down to the means and std columns
  data<-data[ , features$ColumnNumber[ which(features$Keep==TRUE)]]
  
  #combine these dataframes into one
  data<-cbind(subjectdata,activitydata,data)
  
  return(data)
}

#load the features information to use to label the data columns
features<-get_fieldnames(dir)
#load info about the activities
activities<-get_activitynames(dir)
  
#load the two data sets
testdata<-get_data(dir, 'test')
traindata<-get_data(dir, 'train')

#combine into a single dataframe
alldata <-rbind(traindata,testdata)

#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#see http://stackoverflow.com/questions/11007813/r-row-means-on-multiple-columns-by-groups-or-unique-ids
# or rfm.

library(data.table)
alldata.DT <- data.table(alldata)
setkey(alldata.DT, Subject,Activity)
#tables()

#from data.table help
#.SD is constructed as containing the Subset of x's Data for each group, excluding any columns used in by
#lapply signature is lapply(X, FUN, ...) where X is data to apply FUN on
# so lapply(.SD,mean) get the columns one by one and applies the mean()
#
res<-alldata.DT[, lapply(.SD,mean), by=list(Subject,Activity)]






