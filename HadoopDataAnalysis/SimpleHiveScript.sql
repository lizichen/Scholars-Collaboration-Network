-- Prepare CSV Files:
	-- /home/lc3397/CleanedInvestigator.csv
	-- /home/lc3397/all-investigator-csv-final48134-merged.csv
	-- /home/lc3397/coauthor_id_fn_ln_quoted.csv
	-- /home/lc3397/programelement.csv

---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ TABLE INITIALIZATION WITH CSV FILES --------------------------------------
---------------------------------------------------------------------------------------------------------------------------
--INVESTIGATOR
create table investigator (firstname STRING, lastname STRING, awardid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
describe investigator; 
load data local inpath '/home/lc3397/CleanedInvestigator.csv' overwrite into table investigator; 

-- POTENTIALINVESTIGATOR
create table potentialInvestigator (lastname STRING, firstname STRING, scopusid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
describe potentialInvestigator; 
load data local inpath '/home/lc3397/all-investigator-csv-final48134-merged.csv' overwrite into table potentialInvestigator; 

-- COAUTHORIDANDNAME
create table coauthorIdAndName (potentialSID STRING, coauthorSID STRING, firstname String, lastname String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
describe coauthorIdAndName; 
load data local inpath '/home/lc3397/coauthor_id_fn_ln_quoted.csv' overwrite into table coauthorIdAndName; 

-- PCODE_AwardID
create table PCODE_AwardID (primary String, Pcode String, description String, AwardId String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
load data local inpath '/home/lc3397/programelement.csv' overwrite into table PCODE_AwardID; 


---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- RE-ARRANGE TABLES ----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- PCODE_AWARDID_CLEANED
CREATE TABLE PCODE_AwardID_Cleaned row format delimited fields terminated by ',' 
STORED AS TEXTFILE AS SELECT PCODE_AwardID.Pcode, PCODE_AwardID.awardid FROM PCODE_AwardID
ORDER BY PCODE_AwardID.awardid;

-- allPotentialAwardeesAndScopusID
CREATE TABLE allPotentialAwardeesAndScopusID row format delimited fields terminated by ',' 
STORED AS TEXTFILE AS SELECT investigator.firstname, investigator.lastname, potentialInvestigator.scopusid, investigator.awardid FROM potentialInvestigator, investigator
WHERE instr(SPLIT(potentialInvestigator.firstname, '"')[1], SPLIT(investigator.firstname,'"')[1]) > 0
AND instr(SPLIT(potentialInvestigator.lastname,'"')[1], SPLIT(investigator.lastname,'"')[1]) > 0 
ORDER BY investigator.awardid;

-- Save the new tables into CSV files
hive -e 'select * from lc3397.allpotentialawardeesandscopusid' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/allpotentialawardeesandscopusid.csv
hive -e 'select * from lc3397.PCODE_AwardID_Cleaned' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/pcode_awardid_cleaned.csv

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- QUERYING RESULTS -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Display the details of the findings and proof:
USE lc3397;
SELECT allPotentialAwardeesAndScopusID.firstname, allPotentialAwardeesAndScopusID.lastname, allPotentialAwardeesAndScopusID.scopusid, allPotentialAwardeesAndScopusID.awardid, coauthorIdAndName.coauthorsid, coauthorIdAndName.firstname, coauthorIdAndName.lastname 
FROM allPotentialAwardeesAndScopusID, coauthorIdAndName WHERE
allPotentialAwardeesAndScopusID.scopusid = coauthorIdAndName.potentialsid AND
coauthorIdAndName.coauthorsid
IN (
SELECT potentialscopusidandawardid.scopusid FROM potentialscopusidandawardid, PCODE_AwardID_Cleaned WHERE
potentialscopusidandawardid.awardid = allPotentialAwardeesAndScopusID.awardid AND

)limit 100;

-- Create new table for the result1:
USE lc3397;
CREATE TABLE result1 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE AS
SELECT DISTINCT allPotentialAwardeesAndScopusID.firstname, allPotentialAwardeesAndScopusID.lastname, allPotentialAwardeesAndScopusID.scopusid, allPotentialAwardeesAndScopusID.awardid
FROM allPotentialAwardeesAndScopusID, coauthorIdAndName WHERE
allPotentialAwardeesAndScopusID.scopusid = coauthorIdAndName.potentialsid AND
coauthorIdAndName.coauthorsid
IN (
SELECT potentialscopusidandawardid.scopusid FROM potentialscopusidandawardid WHERE
potentialscopusidandawardid.awardid = allPotentialAwardeesAndScopusID.awardid
);

-- Export the result1 table to a csv file:
hive -e 'select * from lc3397.result1' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/result1.csv

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- OTHERS AND TO_DOs -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Add Program Code aside to the Award ID:
select * from INVESTIGATOR
join PCODE_AWARDID_CLEANED
on INVESTIGATOR.awardid = PCODE_AWARDID_CLEANED.awardid


-- Problems:
	-- James vs Jim
	-- Nicknames and Previously Used Name should be included in the all-investigator-csv-final48134-merged.csv file.

-- unique investigators: 48152
SELECT distinct firstname, lastname FROM investigator 






