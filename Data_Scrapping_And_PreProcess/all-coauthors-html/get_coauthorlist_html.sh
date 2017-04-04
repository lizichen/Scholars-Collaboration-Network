#! /bin/bash

# Given a Scopus ID of a specific author, download a HTML file that contains 150 co-authors of the author.
# Sample:
#	https://www.scopus.com/author/coauthordetails.uri?authorId=26023359000

# Need to create the cookies file first
# 	curl -c cookies.txt -I "https://www.scopus.com/author/coauthordetails.uri?authorId=26023359000"

# Test on a url
# 	cat url_scopus | xargs curl -c cookies.txt -I

# echo "downloading csv file"
# curl -b cookies.txt "https://www.scopus.com/author/coauthordetails.uri?authorId=26023359000" > result.csv
# cat url_scopus | xargs curl -b cookies.txt > author.csv

# all-author-scopus-ids.txt 
# 	contains a list of scopus ids, which belong to all the awardees and 'possible awardees'

# output should be a list of html files
#	i.e.,
#		26023359000.html
#		96043330123.html
#	where
#		26023359000 and 96043330123 are both possible awardees' scopus ids. 

# Loop through a file that contains many lines of URLs:
#nl all-author-scopus-ids.txt | xargs -n 2 -P 8 sh -c 'curl -b cookies_mar15.txt https://www.scopus.com/author/coauthordetails.uri?authorId="$1" > "$1".html'

#https://www.scopus.com/author/coauthordetails.uri?authorId=

# Alert! -- Pause 0.7 to get less zero-byte data!
let COUNTER=$2
while [ $COUNTER -lt 10 ]; read NAME
     do curl -b cookies.txt "https://www.scopus.com/author/coauthordetails.uri?authorId=$NAME" > author_$NAME.html
     sleep 0.5
     let COUNTER=COUNTER+1
done < $1
