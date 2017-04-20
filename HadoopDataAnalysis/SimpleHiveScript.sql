-- Prepare CSV Files:
	-- /home/lc3397/CleanedInvestigator.csv
	-- /home/lc3397/all-investigator-csv-final48134-merged.csv
	-- /home/lc3397/coauthor_id_fn_ln_quoted.csv
	-- /home/lc3397/programelement.csv

---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ TABLE INITIALIZATION WITH CSV FILES --------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- INVESTIGATOR
create table investigator (firstname STRING, lastname STRING, awardid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
describe investigator; 
load data local inpath '/home/lc3397/csvdata/CleanedInvestigator.csv' overwrite into table investigator; 

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
-- Awardid -> many pcode
CREATE TABLE aid_pcodesarr row format delimited fields terminated by ',' STORED AS TEXTFILE AS 
SELECT pcode_awardid_cleaned.awardid, collect_set(pcode_awardid_cleaned.pcode) as pcodearr FROM pcode_awardid_cleaned
GROUP BY pcode_awardid_cleaned.awardid
ORDER BY pcode_awardid_cleaned.awardid;

-- PCODE_AWARDID_CLEANED
CREATE TABLE PCODE_AwardID_Cleaned row format delimited fields terminated by ',' STORED AS TEXTFILE AS 
SELECT PCODE_AwardID.Pcode, PCODE_AwardID.awardid FROM PCODE_AwardID
ORDER BY PCODE_AwardID.awardid;

-- allPotentialAwardeesAndScopusID
CREATE TABLE allPotentialAwardeesAndScopusID_NewApr19 row format delimited fields terminated by ',' STORED AS TEXTFILE AS 
SELECT investigator.firstname, investigator.lastname, potentialInvestigator.scopusid, investigator.awardid FROM potentialInvestigator, investigator
WHERE instr(LOWER(SPLIT(potentialInvestigator.firstname, '"')[1]), LOWER(SPLIT(investigator.firstname,'"')[1])) > 0
AND instr(LOWER(SPLIT(potentialInvestigator.lastname,'"')[1]), LOWER(SPLIT(investigator.lastname,'"')[1])) > 0 
ORDER BY investigator.awardid;

CREATE TABLE aid_aids ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE AS
SELECT A.awardid as aid1, B.awardid as aid2 FROM pcode_awardid_cleaned as A inner join pcode_awardid_cleaned as B on A.pcode = B.pcode ORDER BY aid1 ;

CREATE TABLE aid_aids_cleaned ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE AS
SELECT DISTINCT * FROM aid_aids ORDER BY aid1;

CREATE TABLE name_scpid_aid ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE AS
SELECT allpotentialawardeesandscopusid_newapr19.firstname, allpotentialawardeesandscopusid_newapr19.lastname, allpotentialawardeesandscopusid_newapr19.scopusid, aid_aids_cleaned.aid1 FROM allpotentialawardeesandscopusid_newapr19 
JOIN aid_aids_cleaned ON aid_aids_cleaned.aid2 = allpotentialawardeesandscopusid_newapr19.awardid ;

CREATE TABLE scpid_aid ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE AS
SELECT scopusid, aid1 as aid FROM name_scpid_aid ;

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
CREATE TABLE result1 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE AS
SELECT DISTINCT allPotentialAwardeesAndScopusID.firstname, allPotentialAwardeesAndScopusID.lastname, allPotentialAwardeesAndScopusID.scopusid, allPotentialAwardeesAndScopusID.awardid
FROM allPotentialAwardeesAndScopusID, coauthorIdAndName WHERE
allPotentialAwardeesAndScopusID.scopusid = coauthorIdAndName.potentialsid AND
coauthorIdAndName.coauthorsid
IN (
SELECT potentialscopusidandawardid.scopusid FROM potentialscopusidandawardid WHERE
potentialscopusidandawardid.awardid = allPotentialAwardeesAndScopusID.awardid
);

USE lc3397;
CREATE TABLE result2 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE AS
SELECT DISTINCT allpotentialawardeesandscopusid_newapr19.firstname, allpotentialawardeesandscopusid_newapr19.lastname, allpotentialawardeesandscopusid_newapr19.scopusid, allpotentialawardeesandscopusid_newapr19.awardid
FROM allpotentialawardeesandscopusid_newapr19, coauthorIdAndName WHERE
allpotentialawardeesandscopusid_newapr19.scopusid = coauthorIdAndName.potentialsid AND
coauthorIdAndName.coauthorSID
IN (
SELECT scpid_aid.scopusid FROM scpid_aid WHERE
allpotentialawardeesandscopusid_newapr19.awardid = scpid_aid.aid
);

USE lc3397;
CREATE TABLE result3 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE AS
SELECT allpotentialawardeesandscopusid_newapr19.firstname, allpotentialawardeesandscopusid_newapr19.lastname, allpotentialawardeesandscopusid_newapr19.scopusid, allpotentialawardeesandscopusid_newapr19.awardid
FROM allpotentialawardeesandscopusid_newapr19, coauthorIdAndName WHERE
allpotentialawardeesandscopusid_newapr19.scopusid = coauthorIdAndName.potentialsid AND
coauthorIdAndName.coauthorSID
IN (
SELECT scpid_aid.scopusid FROM scpid_aid WHERE
allpotentialawardeesandscopusid_newapr19.awardid = scpid_aid.aid
);

-- NEXT STEP: Use Java MapReduce to Count Repetitions for each Distinct(firstname, lastname, scopusid, awardid)
-- We will get:
--		firstname, lastname, scopusid, awardid, repetitions
-- Then, we pick the one that has the highest reps.

---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- Export to Files ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- Save the new tables into CSV files
hive -e 'select * from lc3397.allpotentialawardeesandscopusid' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/allpotentialawardeesandscopusid.csv
hive -e 'select * from lc3397.PCODE_AwardID_Cleaned' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/pcode_awardid_cleaned.csv
hive -e 'select * from lc3397.allpotentialawardeesandscopusid_newapr19' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/allpotentialawardeesandscopusid_newapr19.csv

-- Export the result1 table to a csv file:
hive -e 'select * from lc3397.result1' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/result1.csv
hive -e 'select * from lc3397.result2' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/result2.csv
hive -e 'select * from lc3397.result3' | sed 's/[[:space:]]\+/,/g' > /home/lc3397/result3.csv
---------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- TESTINGS TABLE Start with T_ ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
-- Add Program Code aside to the Award ID:
select * from INVESTIGATOR
join PCODE_AWARDID_CLEANED
on INVESTIGATOR.awardid = PCODE_AWARDID_CLEANED.awardid

-- Test Join:
CREATE TABLE T_Table_A (pcode String, aid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE;
INSERT INTO TABLE T_Table_A values('"1360"','"2"'), ('"1360"','"3"'), ('"1480"','"4"'), ('"1480"','"2"');
-- T_Table_A.pcode	T_Table_A.aid
-- "1360"	"2"
-- "1360"	"3"
-- "1480"	"4"
-- "1480"	"2"

CREATE TABLE T_aid_aid ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE AS
SELECT A.aid as aid1, B.aid as aid2 from T_Table_A as A inner join T_Table_A as B on A.pcode = B.pcode ;
-- a.aid	b.aid
-- "2"	"3"
-- "2"	"2"
-- "2"	"2"
-- "2"	"4"
-- "3"	"3"
-- "3"	"2"
-- "4"	"4"
-- "4"	"2"

CREATE TABLE T_aid_aid_cleaned ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE AS
SELECT DISTINCT * FROM t_aid_aid ORDER BY aid1;

CREATE TABLE t_scpid_aid (sid String, aid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE;
INSERT INTO TABLE T_scpid_aid values
('"7201720872"','"2"'), 
('"55179670200"','"2"'), 
('"16437554300"','"2"'), 
('"8511476600"', '"2"'),
('"57189206832"', '"3"'),
('"36893667100"', '"3"'),
('"7201720792"', '"3"'),
('"35246445500"', '"3"'),
('"24380721700"', '"3"'),
('"55837129400"', '"3"'),
('"55665045600"', '"4"'),
('"7201720718"', '"4"'),
('"24286160200"', '"4"'),
('"16038333200"', '"4"'),
('"7201720751"', '"4"'),
('"35622897600"', '"4"');

-- This Complex Array type element may need fancy syntax to work with.
CREATE TABLE T_aid_scpidarr ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE AS
SELECT T_aid_aid_cleaned.aid1, collect_set(t_scpid_aid.sid) FROM T_aid_aid_cleaned join t_scpid_aid on T_aid_aid_cleaned.aid2 = t_scpid_aid.aid GROUP bY T_aid_aid_cleaned.aid1;
+----------------------+----------------------------------------------------+--+
| t_aid_scpidarr.aid1  |                 t_aid_scpidarr._c1                 |
+----------------------+----------------------------------------------------+--+
| "2"                  | ["\"7201720872\"","\"55179670200\"","\"16437554300\"","\"8511476600\"","\"57189206832\"","\"36893667100\"","\"7201720792\"","\"35246445500\"","\"24380721700\"","\"55837129400\"","\"55665045600\"","\"7201720718\"","\"24286160200\"","\"16038333200\"","\"7201720751\"","\"35622897600\""] |
| "3"                  | ["\"7201720872\"","\"55179670200\"","\"16437554300\"","\"8511476600\"","\"57189206832\"","\"36893667100\"","\"7201720792\"","\"35246445500\"","\"24380721700\"","\"55837129400\""] |
| "4"                  | ["\"7201720872\"","\"55179670200\"","\"16437554300\"","\"8511476600\"","\"55665045600\"","\"7201720718\"","\"24286160200\"","\"16038333200\"","\"7201720751\"","\"35622897600\""] |
+----------------------+----------------------------------------------------+--+

CREATE TABLE T_aid_scpidarr2 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE AS
SELECT T_aid_aid_cleaned.aid1, t_scpid_aid.sid FROM T_aid_aid_cleaned join t_scpid_aid on T_aid_aid_cleaned.aid2 = t_scpid_aid.aid;

CREATE TABLE T_scpid_pot_scpsid (scpid String, pot_scpid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE;
INSERT INTO TABLE T_scpid_pot_scpsid values
('"7201720872"','"7402093178"'),
('"7201720872"','"36670921900"'),
('"7201720872"','"6602822106"'),
('"7201720872"','"7201540118"'),
('"55179670200"','"16038333200"'), 
('"55179670200"','"24380721700"'), 
('"16437554300"','"7202959020"');

SELECT distinct t_scpid_aid.sid, t_scpid_aid.aid FROM t_scpid_aid, t_scpid_pot_scpsid WHERE
t_scpid_aid.sid = T_scpid_pot_scpsid.scpid AND
t_scpid_pot_scpsid.pot_scpid
IN (
SELECT T_aid_scpidarr2.sid as scpid FROM T_aid_scpidarr2, T_scpid_aid WHERE
T_scpid_aid.aid = T_aid_scpidarr2.aid1
);
+------------------+------------------+--+
| t_scpid_aid.sid  | t_scpid_aid.aid  |
+------------------+------------------+--+
| "55179670200"    | "2"              |
+------------------+------------------+--+

SELECT t_scpid_aid.sid, t_scpid_aid.aid FROM t_scpid_aid, t_scpid_pot_scpsid WHERE
t_scpid_aid.sid = T_scpid_pot_scpsid.scpid AND
t_scpid_pot_scpsid.pot_scpid
IN (
SELECT T_aid_scpidarr2.sid as scpid FROM T_aid_scpidarr2, T_scpid_aid WHERE
T_scpid_aid.aid = T_aid_scpidarr2.aid1
);
+------------------+------------------+--+
| t_scpid_aid.sid  | t_scpid_aid.aid  |
+------------------+------------------+--+
| "55179670200"    | "2"              |
| "55179670200"    | "2"              |
+------------------+------------------+--+

CREATE TABLE t_result1 (sid String, aid String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','STORED AS TEXTFILE;
INSERT INTO TABLE t_result1 values
('"55179670200"','"2"'),
('"55179670200"','"2"'),
('"55179670200"','"2"'),
('"16437554300"','"3"'),
('"16437554300"','"3"'),
('"66028221067"','"4"');

SELECT count(*) from t_result1;
SELECT count(*) from t_result1 GROUP BY sid, aid;

---------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------- Notes and Others --------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- Work on 'With' and 'Explode' Function
-- Example from https://community.hortonworks.com/questions/35877/trying-to-use-hive-explode-function-to-unfold-an-a.html 
SELECT distinct firstname, lastname FROM investigator 
with q as
(
select quote_id,
get_json_object(message_full,'$.event.quote.vehicles.coverages.limits.type') as coverage_type
from dcbi_dev
where event_class = 'events.quote.QuoteCreated' and quote_id = '57226f1e01a9c82283d02ff8'
)
select quote_id, b from q lateral view explode(split(substr(q.coverage_type,2,length(q.coverage_type) - 2),',')) exploded as b;

-- How to use UDF?

-- How to use Map Function!?

-- How to check repetitions?

-- How to visualize? https://github.com/facebookresearch/visdom








