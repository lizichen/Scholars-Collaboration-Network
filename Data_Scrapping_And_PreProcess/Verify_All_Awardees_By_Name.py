# Read the Investigator.csv file for all the names.
# Find accordingly the name in all-authors-csv
import glob
import csv
import sys

target_file = open('MISSING_AWARDEES.txt', 'w')
    
mis_counter = 1
csv_counter = 1
write_counter = 0

with open("investigator.csv", "rb") as f:
    reader = csv.reader(f, delimiter=",")
    for i, line in enumerate(reader):
        search = line[1] + "_" + line[2]
        if len(glob.glob('authors_csv/'+search+'*.csv')) == 0:
            if write_counter % 100 == 0:
                target_file.close()
                target_file = open('MISSING_AWARDEES.txt', "a+")
            print "(" + str(mis_counter) + "/" + str(csv_counter) + ")_" + search
            target_file.write(search.encode('utf-8'))
            target_file.write("\n")
            mis_counter += 1
            write_counter += 1
        csv_counter += 1 # increment 1 by reading csv file line-by-line

target_file.close()


# In[ ]:




# In[ ]:



