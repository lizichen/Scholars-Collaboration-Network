#### Note:    
In order to avoid the subscription fee from Scopus.com, web scrapping needs to be done with hardcoded urls and bash commands. These files are helpers to generate files that contain lists of urls and other stuff.




#### AwardeeNameToHisHtml.java:     
#### CsvToHtml.java:   
- Given a list of missing names in a file (missing-awardee-names_mar17.txt); each line in the file is a pair of {firstname, lastname}, the program reads the file line by line and produce a result file, which has the scopus url to the search result of a author's {firstname, lastname}.
- The result of this file is used for scrapping search result page of a pair of {firstname, lastname}.   


#### RetrieveAuthorPublicationURL.java:     
- Read in a ScopusID (line by line from Sample_SID.txt) and append it with url to produce a scrap-able of the author's full list of publications.

