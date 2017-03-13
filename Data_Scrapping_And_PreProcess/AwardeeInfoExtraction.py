from bs4 import BeautifulSoup
import time
import sys

# Get one html file from dir all-authors-html/ based on its appendix number, i.e., author_199.html
# Extract all the search results:
#     FirstName, LastName, Scopus_ID, Affiliation(University)
# Store result line-by-line into an csv file into dir authors_csv/ with naming convention: FirstName_LastName_HtmlFileNumber.csv
def htmlToCsv(htmlnumber):
    try:
        html_doc = open("all-authors-html/author_"+str(htmlnumber)+".html",'r').read()
        soup = BeautifulSoup(html_doc, 'html.parser')

        authorId = []
        authorNm = []
        authorUn = []

        st1 = soup.find("input", {"name":"st1"}) 
        if st1 is not None:
            st2 = soup.find("input", {"name":"st2"})   
            lastname = st1.get('value')
            firstname = st2.get('value')
            filename = "authors_csv/" + firstname + "_" + lastname + "_" + str(htmlnumber) + ".csv"
            target_file = open(filename, 'w')

            for a in soup.find_all('a'):
                if a.get('title') == 'View this author\'s profile':
                    href = a.get('href')
                    index_start = href.index('Id')
                    index_end = href.index('&origin')
                    authorId.append(href[index_start+3:index_end])
                    authorNm.append(a.getText())

            for uni in soup.findAll("div", { "class" : "dataCol5" }):
                authorUn.append(uni.getText())

            numberOfRows = len(authorId)
            target_file.write(str(numberOfRows)+"\n")
            numberOfUniversity = len(authorUn)

            for i in xrange(0,len(authorId)): 
                line = ""
                if i >= numberOfUniversity:
                    line = "\""+ authorNm[i] + "\",\"" + authorId[i] + "\",\"" + "N/A" + "\""
                else:
                    if authorUn[i][0] == '\n':
                        if len(authorUn[i]) > 1:
                            if authorUn[i][1] == '\n':
                                line = "\""+ authorNm[i] + "\",\"" + authorId[i] + "\",\"" + authorUn[i][2:] + "\""
                            else:
                                line = "\""+ authorNm[i] + "\",\"" + authorId[i] + "\",\"" + authorUn[i][1:] + "\""
                        else:
                            line = "\""+ authorNm[i] + "\",\"" + authorId[i] + "\",\"" + authorUn[i] + "\""
                    else:
                        line = "\""+ authorNm[i] + "\",\"" + authorId[i] + "\",\"" + authorUn[i] + "\""
                target_file.write(line.encode('utf-8'))
                target_file.write("\n")
            target_file.close()
    except IOError:
        print "No such input file!"
            
for i in xrange(2000, 3500):
    print i
    htmlToCsv(i)
