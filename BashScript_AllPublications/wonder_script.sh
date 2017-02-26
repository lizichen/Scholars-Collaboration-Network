#! /bin/bash

#echo "creating cookie file"
#cat url_scopus | xargs curl -c cookies.txt -I

#variables: scopusID, author.csv

#echo "downloading csv file"
#cat url_scopus | xargs curl -b cookies.txt > author.csv

#nl url_scopus | xargs curl -b cookies.txt sh -c '"$1" > logfile-$0'
#nl url_scopus | xargs -n 2 -P 8 sh -c './myScript.sh "$1" > logfile-$0'
nl url_scopus | xargs -n 2 -P 8 sh -c 'curl -b cookies.txt "$1" > logfile-$0.csv'



#7006843462
#56261433100
#7005071296
#7102605212
#7102080550
#6601983917
#7102014925

