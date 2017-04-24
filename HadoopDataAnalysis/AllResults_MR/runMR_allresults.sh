#!/bin/bash

echo "Running MR"
javac -classpath `yarn classpath` -d . AllResultsMapper.java
javac -classpath `yarn classpath` -d . AllResultsReducer.java
javac -classpath `yarn classpath`:. -d . AllResults.java

jar -cvf allresults.jar *.class


