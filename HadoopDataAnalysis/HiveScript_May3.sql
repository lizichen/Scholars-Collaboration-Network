-- Awardees (raw Investigator.csv)
create table awardees (rowId String, firstname String, lastname String, email String, startdate String, enddate String, role String, awardfk String)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
stored as textfile;
load data local inpath '/home/lc3397/csvdata/investigator.csv' overwrite into table awardees;

create table awardee_cleaned 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'   
stored as textfile as
select firstname, lastname, email, awardfk from awardees;

-- Awards (raw award.csv)
create table awards (rowid String, awardtitle String, awardeffectivedate String, awardexpirationdate String, awardamount String, abstractNarration String, minamdletterdate String, maxamdletterdate String, arraamount String, awardid String, awardfk String)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
stored as textfile;
load data local inpath '/home/lc3397/csvdata/award.csv' overwrite into table awards;

create table awards_cleaned
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile as
select awardeffectivedate, awardexpirationdate, awardamount, awardid, awardfk from awards;

-- ProgramElement (raw programelement.csv)
create table ProgramElement (rowid String, pcode String, description String, awardfk String)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
stored as textfile;
load data local inpath '/home/lc3397/csvdata/programelement.csv' overwrite into table ProgramElement;

create table ProgramElement_cleaned
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile as
select pcode, awardfk from programelement;

-- Institution (raw institution.csv)
create table Institution (rowid String, affiliation String, city String, zipcode String, phone String, streetAddr String, country String, state String, statecode String, awardfk String)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
stored as textfile;
load data local inpath '/home/lc3397/csvdata/institution.csv' overwrite into table Institution;

create table Institution_cleaned
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile as
select affiliation, city, country, state, awardfk from Institution;

-- foa (raw foainformation.csv)
create table foa (rowid String, code String, description String, awardfk String)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
stored as textfile;
load data local inpath '/home/lc3397/csvdata/foainformation.csv' overwrite into table foa;

create table foa_cleaned
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile as
select description, awardfk from foa;

-- Award with all information:
create table awards_allinfo
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as textfile as
select awards_cleaned.awardid, 
programelement_cleaned.pcode, 
Institution_cleaned.affiliation, 
Institution_cleaned.city, 
Institution_cleaned.state, 
Institution_cleaned.country, 
foa_cleaned.description, 
awards_cleaned.awardfk from awards_cleaned, programelement_cleaned, Institution_cleaned, foa_cleaned
where programelement_cleaned.awardfk = awards_cleaned.awardfk
and Institution_cleaned.awardfk = awards_cleaned.awardfk
and foa_cleaned.awardfk = awards_cleaned.awardfk;










