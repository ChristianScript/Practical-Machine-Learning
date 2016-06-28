# Practical-Machine-Learning
## Week 4 Peer Graded Assignment

### Structur
* Background
* Task
* Data Discription
* Data Preparation
* Modeling
* Evaluation

### Background
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it.

### Task
In this project, the goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. The task is, to predict the manner in which they did the exercise for 20 different test cases.

### Data Discription
The given training data contains 19622 entries with 158 discribing attributes and the "classe" variable which is to predict for the 20 entries in the test data. The attributes inlcude the name of the participants, timestamps and several sensors. The "classe" variable has 5 levels(A, B, C, D, E) corresponding to how well an exercise is performed and the variable is quiet similar distributed among the traing data. 

  A  |  B  |  C  |  D  |  E 
-----|-----|-----|-----|----
5580 |3797 |3422 |3216 |3607 

### Data Preparation
First off, i decided to split the training data into a training set (70%) and test set(30%). After that i did some preparation and cleaning in the following way:

* removed ID
* removed all attributes that have zero or near zero variance
* removed columns with more than 20% data missing 
* normalization
* convert category to binary

Nothing special about that but there are some issues. First, there are no columns with more then 0% but less then 20% missing values. So removing missing values like i did removed the whole columns. I also tried to impute the missing values instead of discarding them. I tried knnImpute and it didnt work probably so i chosed median imputation as quick and dirty solution but there are too many missing values per column for proper imputation.  
Another thing i have to mention is that i didn't use a distinct handling for the date attributes.

### Modeling
I chosed the algorithms i used in two different ways. The first algorithm is LogitBoost (http://www.inside-r.org/packages/cran/caTools/docs/LogitBoost) that decision was made based on my personal prefrences (i like the logistic cost function and the boosting scheme) and i just wanted to know how well it performs.
The second algorithm is C5.0. It comes with some kind of robustness (like almost all tree-based algorithms, unless the data isnt skewed) and based on my quick and dirty data preparation this one seemed to be a good idea.

### Evaluation
I trained both algorithms once on the training set and predicted the values for the test set. The tables below show some statistics for both algorithms

LogitBoost Accuracy: 0.9763  |Class:A |Class:B |Class:C |Class:D |Class:E
-----------------------------|--------|--------|--------|--------|--------
Sensitivity                  |0.9868  |0.9581  |0.9751  |0.9584  |0.9952
Specificity                  |0.9931  |0.9916  |0.9933  |0.9952  |0.9971
Pos Pred Value               |0.9831  |0.9628  |0.9667  |0.9761  |0.9877
Neg Pred Value               |0.9947  |0.9905  |0.9950  |0.9915  |0.9989


C5.0 Accuracy: 0.9992        |Class:A |Class:B |Class:C |Class:D |Class: E
-----------------------------|--------|--------|--------|--------|-------- 
Sensitivity                  |0.9982  |1.0000  |1.0000  |0.9979  |1.0000
Specificity                  |1.0000  |0.9994  |0.9998  |1.0000  |0.9998
Pos Pred Value               |1.0000  |0.9974  |0.9990  |1.0000  |0.9991
Neg Pred Value               |0.9993  |1.0000  |1.0000  |0.9996  |1.0000

My first impression was that the results were to good to be true and it would be better to use crossvalidation and lookup the average values. However, i decided to test the c5.0 algorithm on the given test data and it ended up with 100% accuracy (20/20 in the Quiz).
