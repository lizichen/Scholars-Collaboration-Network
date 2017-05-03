/*Loading: */
Investigator = LOAD 'hdfs://babar.es.its.nyu.edu:8020/user/lc3397/collaboration_networks/CleanedInvestigator.csv' USING PigStorage(',') as (FN:chararray, LN:chararray, AwardID:chararray);

AllPossibleAwardeeAndID = LOAD 'hdfs://babar.es.its.nyu.edu:8020/user/lc3397/collaboration_networks/all-investigator-csv-final48134-merged.csv' USING PigStorage(',') as (P_LN:chararray, P_FN:chararray, PossibleID:chararray)


GroupedAwardee = GROUP Investigator by AwardID;
/*
("42486",{("Charles","Owens","42486"),("John","Courtney","42486"),("Cathleen","Campbell","42486")})

GroupedAwardee: {group: chararray,Investigator: {(FN:chararray, LN: chararray, AwardID:chararray)}}
*/

FOREACH GroupedAwardee {
	FOREACH Investigator {
		SelectedRows = Filter AllPossibleAwardeeAndID By P_FN MATCHES FN AND P_LN MATCHES LN;
		
	}
	GENERATE
}


