#! /bin/bash

#echo "creating cookie file"
#curl -c cookies.txt -I "http://www.yourfancyurl.com"
#cat url_scopus | xargs curl -c cookies.txt -I

#echo "downloading csv file"
#curl -b cookies.txt "http://www.yourfancyurl.com" > result.csv
#cat url_scopus | xargs curl -b cookies.txt > author.csv

# This command works: 
#	1. Verify if three_cookies.txt works
#	2. Verify if only cookies.txt works
nl author_publication_urls.txt | xargs -n 2 -P 8 sh -c 'curl -b ../cookies/cookies.txt "$1" > author-$0.csv'