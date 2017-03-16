
# coding: utf-8

# In[13]:

# Read the Investigator.csv file for all the names.
# Find accordingly the name in all-authors-csv
import glob
import csv
import sys

target_file = open('MISSING_AWARDEES.txt', 'w')
    
count = 1
with open("investigator.csv", "rb") as f:
    reader = csv.reader(f, delimiter=",")
    for i, line in enumerate(reader):
        search = line[1] + "_" + line[2]
        if len(glob.glob('all-authors-csv/'+search+'*.csv')) == 0:
            print str(count) + " " + search
            target_file.write(search.encode('utf-8'))
            target_file.write("\n")
            count += 1

target_file.close()


# In[ ]:




# In[ ]:



