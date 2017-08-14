1. publication_url_list.new.txt - contains a list of URLs that points to a scrap-able publications list for a matched author.   
2. Get the latest cookie by running the get-fresh-cookies.sh: ./get-fresh-cookies.sh
3. cookies.txt contains the latest use-able cookies for publication scrapping.
4. Run: ./get_author_publicationsCsvList.sh publication_url_list.new.txt cookies.txt
5. All the CSV files will be scrapped in publicationsList_CSV folder.
6. Run PublicationDetails_To_SID_and_EID_Table.scala in Spark environment.
7. A folder, SID_EID_Table, which includes all the JSON files for SID and EID pairs will be created.
8. Run the aggregate_sid_eid_json_files.sh script to aggregate all generated json files and remove the scattered files.
9. 
