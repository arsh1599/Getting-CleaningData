f <- read.table("features.txt", col.names = c("n","functions"))
act <- read.table("activity_labels.txt", col.names = c("code", "activity"))
s_test <- read.table("test/subject_test.txt", col.names = "subject")
X_test <- read.table("test/X_test.txt", col.names = f$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
s_train <- read.table("train/subject_train.txt", col.names = "subject")
X_train <- read.table("train/X_train.txt", col.names = f$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

#1 Merge data into 1 dataframe
X <- rbind(X_train,X_test)
Y <- rbind(y_train,y_test)
S <- rbind(s_train, s_test)
M_Data <- cbind(S, Y, X)

#2 Extract only mean and std. for each measurement
M_S_Data <- M_Data %>% select(subject, code, contains("mean"), contains("std"))

#3 Using activity names for naming in dataset
M_S_Data$code <- act[M_S_Data$code, 2]

#4 Label data set with var names
names(M_S_Data)[2] = "activity"
names(M_S_Data)<-gsub("Acc", "Accelerometer", names(M_S_Data))
names(M_S_Data)<-gsub("Gyro", "Gyroscope", names(M_S_Data))
names(M_S_Data)<-gsub("BodyBody", "Body", names(M_S_Data))
names(M_S_Data)<-gsub("Mag", "Magnitude", names(M_S_Data))
names(M_S_Data)<-gsub("^t", "Time", names(M_S_Data))
names(M_S_Data)<-gsub("^f", "Frequency", names(M_S_Data))
names(M_S_Data)<-gsub("tBody", "TimeBody", names(M_S_Data))
names(M_S_Data)<-gsub("-mean()", "Mean", names(M_S_Data), ignore.case = TRUE)
names(M_S_Data)<-gsub("-std()", "STD", names(M_S_Data), ignore.case = TRUE)
names(M_S_Data)<-gsub("-freq()", "Freq", names(M_S_Data), ignore.case = TRUE)
names(M_S_Data)<-gsub("angle", "Angle", names(M_S_Data))
names(M_S_Data)<-gsub("gravity", "Gravity", names(M_S_Data))

#5 Create final Tidy dataset, with average of each var
Final_Tidy_Data <- M_S_Data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(Final_Tidy_Data, "Final_Tidy_Data.txt", row.name=FALSE)
