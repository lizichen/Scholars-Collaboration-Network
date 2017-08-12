#! /bin/bash

curl -c cookies.txt -I "https://www.scopus.com/onclick/export.uri?oneClickExport=%7B%22Format%22%3A%22CSV%22%2C%22View%22%3A%22CiteOnly%22%7D&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=7006843462&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA%3A73"

# for publication html webpage retrieval
# curl -c cookies.txt -I "https://www.scopus.com/onclick/export.uri?oneClickExport=%7b%22Format%22%3a%22CSV%22%2c%22View%22%3a%22CiteOnly%22%7d&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=55765581600&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA%3a73"
