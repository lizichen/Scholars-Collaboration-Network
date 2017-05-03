-- Verify the Final Result:

-- 1. Given one PCode = 1360, to get all awards belong to it, and all awardees' name and sid for each award.
SELECT result_maxreps.firstname, result_maxreps.lastname, result_maxreps.awardid, result_maxreps.sid 
FROM pcode_awardid_cleaned, result_maxreps 
WHERE pcode_awardid_cleaned.pcode = '"1360"' 
AND pcode_awardid_cleaned.awardid = result_maxreps.awardid
order by result_maxreps.awardid;

-- One part from the result:
-- +---------------------------+--------------------------+-------------------------+---------------------+
-- | firstname				   | lastname				  | awarid    				| sid				  |
-- +---------------------------+--------------------------+-------------------------+---------------------+
-- | "sandra"                  | "cruz-pol"               | "3"                     | "6601983917"        |
-- | "david"                   | "mclaughlin"             | "3"                     | "7102605212"        |
-- | "michael"                 | "zink"                   | "3"                     | "7102014925"        |
-- | "kelvin"                  | "droegemeier"            | "3"                     | "56261433100"       |
-- | "ming"                    | "xue"                    | "3"                     | "7102080550"        |
-- +---------------------------+--------------------------+-------------------------+---------------------+

-- 2. Verify the result by looking for all awardees from the Investigator whose awardid = 3
select * from investigator where awardid = '"3"';

-- From the NSF Database (Investigator):
-- +-------------------------+------------------------+-----------------------+--+
-- | investigator.firstname  | investigator.lastname  | investigator.awardid  |
-- +-------------------------+------------------------+-----------------------+--+
-- | "James"                 | "Kurose"               | "3"                   | [Missing]
-- | "Kelvin"                | "Droegemeier"          | "3"                   |
-- | "V."                    | "Chandrasekar"         | "3"                   | [Missing]
-- | "David"                 | "McLaughlin"           | "3"                   |
-- | "Ming"                  | "Xue"                  | "3"                   |
-- | "Sandra"                | "Cruz-Pol"             | "3"                   |
-- | "Michael"               | "Zink"                 | "3"                   |
-- +-------------------------+------------------------+-----------------------+--+
"Vidya","Chandrasekaran","36720576400","28666"

From the result:
| "james"                   | "weiland"                | "2"                     | "7006322846"        |
| "mark"                    | "humayun"                | "2"                     | "7101691575"        |

From the NSF database:
+-------------------------+------------------------+-----------------------+--+
| investigator.firstname  | investigator.lastname  | investigator.awardid  |
+-------------------------+------------------------+-----------------------+--+
| "James"                 | "Weiland"              | "2"                   |
| "Gerald"                | "Loeb"                 | "2"                   |
| "Mark"                  | "Humayun"              | "2"                   |
+-------------------------+------------------------+-----------------------+--+

Other program code to look for:
+------------------------------+--------------------------------+--+
| pcode_awardid_cleaned.pcode  | pcode_awardid_cleaned.awardid  |
+------------------------------+--------------------------------+--+
| "1360"                       | "2"                            |
| "7218"                       | "2"                            |
| "1480"                       | "2"                            |
+------------------------------+--------------------------------+--+

select result_maxreps.firstname, result_maxreps.lastname, result_maxreps.awardid, result_maxreps.sid from pcode_awardid_cleaned, result_maxreps 
where 
pcode_awardid_cleaned.pcode in ( '"1360"', '"7218"', '"1480"') 
and pcode_awardid_cleaned.awardid = result_maxreps.awardid 
and result_maxreps.awardid = '"2"'
order by result_maxreps.awardid;

curl -b cookies.txt https://www.scopus.com/onclick/export.uri?oneClickExport=%7b%22Format%22%3a%22CSV%22%2c%22View%22%3a%22CiteOnly%22%7d&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=56261433100&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA%3a73