#!/bin/bash

echo "Remove previous dir"
rm GetMostRepSID*.class
hdfs dfs -rm -r /user/lc3397/getreps/output4/

echo "Compile Class and Get Jar"
javac -classpath `yarn classpath` -d . TextArrayWritable.java
javac -classpath `yarn classpath` -d . TextArrayWritable.java GetMostRepSIDMapper.java
javac -classpath `yarn classpath` -d . TextArrayWritable.java GetMostRepSIDReducer.java
javac -classpath `yarn classpath`:. -d . TextArrayWritable.java GetMostRepSID.java

jar -cvf getmostrepsid.jar *.class

echo "Run MR"
hadoop jar getmostrepsid.jar GetMostRepSID /user/lc3397/getreps/result3_reps.csv /user/lc3397/getreps/output4
