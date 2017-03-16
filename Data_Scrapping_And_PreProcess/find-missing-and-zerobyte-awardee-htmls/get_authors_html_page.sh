#! /bin/bash

# This command grab the html website of a search result.
# if search for firstname = James, lastname = Kurose, we have a website specifically for all possible James Kurose
#nl ../../authorslist_urls.txt | xargs -n 2 -P 8 sh -c 'curl -b cookies_feb28.txt "$1" > author-$0.html'

let COUNTER=$2
while [ $COUNTER -lt 10 ]; read NAME
     do curl -b ../cookies/cookies.txt "$NAME" > author_$COUNTER.html
     sleep 0.8
     let COUNTER=COUNTER+1
done < $1