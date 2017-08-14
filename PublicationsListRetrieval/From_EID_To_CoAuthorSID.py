# in SID_EID_Table.json, each line has two values:
# 1. SID, represents the awardee's Scopus ID
# 2. EID, represents the publication identifier
#
# Adapt EID into the url below to get the html file of the specific publication:
# https://www.scopus.com/record/display.uri?eid=[eid]&origin=resultslist
#
# From the HTML file, use BeautifulSoup to scrap the Scopus ID of all the co-authors. SID only.
