## Analysis File

The file "run_analysis.R" generates the file "HUA_AvgStd.txt" from the 
source files at the 
<a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">Center for Machine Learning and Intelligent Systems</a>
It performs the following operations:

* Reads in the activity and variable (feature) names.  Feature names are modified
to be readable by R functions.

* Reads in the observations for both the test data subset, as well as the subject
and activity labels.  These are merged.  

* The numerical code for the activity is replaced with the name.  

* Only variables which are a mean or standard deviation are kept.

* The same operations are performed on the training data subset.

* The training and test data sets are merged.

* The average of each variable is calculated for each subject and each activity.

* The standard deviation is calculated for each subject and each activity.

* The average and standard deviation results are merged into a data frame.

* Final data frame is written to the file "HUA_AvgStd.txt".
