### A Script to download all publications of an author

- **url_scopus**: A file that contains the url that has access to a csv file contains all publication details of this author.
- **cookies.txt**: A file that contains the cookies needed to have access and download the csv.
'''bash
cat url_scopus | xargs curl -c cookies.txt -I
'''

'''bash
cat url_scopus | xargs curl -b cookies.txt > author.csv
'''
