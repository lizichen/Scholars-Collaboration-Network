#! /bin/bash

#echo "creating cookie file"
#cat url_scopus | xargs curl -c cookies.txt -I

echo "downloading csv file"
cat url_scopus | xargs curl -b cookies.txt > author.csv


# cat url_scopus | xargs curl -X POST -F 'username=username' -F 'password=password' -b cookies.txt > author.csv
