
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
