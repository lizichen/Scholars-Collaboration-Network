## Data Scrapping and Preparation Scripts*

#### 1.Find the real Awardee's Scopus ID.
*(Because the Awards for NSF Programs does not have the Scopus IDs for the awardees)*   

We need a file that contains **all the awards** and each award has its list of awardees. (This data set can be retrieved from [NSF Award Website][NSF])
  
Sample **JSON** format: **(Awards.json)**  
```json
[
    {
        "Award ID": "548391011"
        "Awardees": [
            "Awardee Name": "Kyunghyun, Cho",
            "Awardee Name": "Richard, Cole",
            "Awardee Name": "Ernest, Davis",
        ]
    },
    {
        "Award ID": "893417493"
        "Awardees": [
            "Awardee Name": "Rob, Fergus",
            "Awardee Name": "Lecun, Yann",
            "Awardee Name": "Davi, Geiger"
        ]
    }
]
```

We need a file *(or many files)* that contains **all the possible search results of a awardee's name** from Scopus website. For example, when searching for FirstName = Rob, LastName = Fergus, we may have many authors from Scopus that have the same/similar FirstName and LastName pairs.  

Sample single csv file format: **(Rob_Fergus_237.csv)**
```text
"Rob, Fergus", "34975053400", "University of Lucknow"
"Rob, F.",     "6602097199",  "Jawaharlal Nehru University"
"Rob Fergus",  "34769779500", "New York University"
"Rob Fergus",  "34769032443", "Stony Brook University State University of New York"
```

This file is retrieved by first using [this script][get_authors_html_page] to download the html file of a curl call:
```sh
#! /bin/bash

# This command grab the html website of a search result.
# if search for firstname = James, lastname = Kurose, we have a website specifically for all possible James Kurose
#nl ../../authorslist_urls.txt | xargs -n 2 -P 8 sh -c 'curl -b cookies_feb28.txt "$1" > author-$0.html'
let COUNTER=$2
while [ $COUNTER -lt 10 ]; read NAME
     do curl -b ../cookies/cookies_feb28.txt "$NAME" > author_$COUNTER.html
     sleep 0.5
     let COUNTER=COUNTER+1
done < $1
```

Then, use the [AwardeeInfoExtraction.ipynd][htmltocsv] to extract the author names, scopus IDs, and affiliations/universities, from the html file into a csv file, as the above sample *Rob_Fergus_237.csv* shown. 

Base on a Scopus ID, we can retrieve a list of co-authors from Scopus. *(We will scrap the data from the website to local just to improve time efficiency.)*  

Sample co-author file format: **(6602097199.txt)**
```text
Fei-Fei, Li
Freeman, William T.
Eigen, David
Lecun, Yann
Wan, Li
Weston, Jason L.
Baranec, Christoph J.
Davi, Geiger
Tran, Du V.
```

The counterpart file that contains more names from the list of awardees will be chosen. The Scopus ID will be assigned to the corresponding Awardee Name.  
This step may be done via **HDFS & MapReduce Framework** to improve time efficiency.

Eventually, we will have a **Awardee-Scopus-ID-Enabled-Award-List.json** structured file.

## Object Relation Diagram:
![scopus_id_for_awardee](https://github.com/lizichen/collaboration_networks/blob/master/Data_Scrapping_And_PreProcess/Report_and_logs/FunctionalLevel.jpg "Diagram to show how to get the real Scopus ID for an awardee")

![data_level](https://github.com/lizichen/collaboration_networks/blob/master/Data_Scrapping_And_PreProcess/Report_and_logs/DataLevel.jpg "Diagram to show how to get the real Scopus ID for an awardee")



#### 2.Prepare the data clusters.  

- **/all-publications/author_publication_urls.txt**:   
  A file that contains a list of urls, one of which has access to a csv file that contains all publication details of a certain author.
- **/cookies/**: Directory that contains the cookies files that are needed to have access and download the csv. Currently use **cookies_feb28.txt**. 

```sh
cat url_scopus | xargs curl -c cookies.txt -I
```

```sh
cat url_scopus | xargs curl -b cookies.txt > author.csv
```

Sample CSV file for all **publications** of an author:
```text
Authors,Title,Year,Source title,Volume,Issue,Art. No.,Page start,Page end,Page count,Cited by,DOI,Link,Document Type,Source,EID
"Dehghan, M., Jiang, B., Seetharam, A.","On the Complexity of Optimal Request Routing Network",2016,"IEEE/ACM Transactions on Networking",,,,"","",,,10.1109/TNET.2016.2636843,"https://www.scopus.com/SampleLink.html",Article in Press,Scopus,2-s2.0-85007039888

// and many lines of publication information, each line refers to one publication.
```

## About the Data in this Repository:

**All the names and data are randomly chosen, does not mean anything related to the real scopus website or NSF programs. All data from Scopus and NSF program will NOT be published to anyone in this research.*

Large Data Set is not commited in Github due to size restrain.  
The 48134 CSV files are not checked in; however, a tar.gz compressed file **all-investigator-csv-final48134.tar.gz** (5.6 MB) is available in this Github directory.

[NSF]:https://www.research.gov/common/webapi/awardapisearch-v1.htm
[get_authors_html_page]:https://github.com/lizichen/collaboration_networks/blob/master/Data_Scrapping_And_PreProcess/all-authors-html/get_authors_html_page.sh
[htmltocsv]:https://github.com/lizichen/collaboration_networks/blob/master/Data_Scrapping_And_PreProcess/AwardeeInfoExtraction.ipynb
