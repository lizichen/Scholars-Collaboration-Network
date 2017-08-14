import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.types.{StructType, StructField, IntegerType, StringType}
val sqlContext = new SQLContext(sc)

// the original files are:
val foainformation_csv = ""
val institution_csv = ""

val programelement_csv = "/home/lizichen/Desktop/collaboration_networks/Spark-Scripts/OriginalData/programelement.csv"
val programelement_csv_schema = StructType(Array(
  StructField("PrimaryKey", IntegerType, true),
  StructField("Code", StringType, true),
  StructField("Text", StringType, true),
  StructField("FK_rootTag",IntegerType, true)
))
val programelement_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").option("delimiter",",").option("quote","\"").option("escape", "\"").schema(programelement_csv_schema).load(programelement_csv)

val award_csv = "/home/lizichen/Desktop/collaboration_networks/Spark-Scripts/OriginalData/award.csv"
val award_csv_schema = StructType(Array(
  StructField("PrimaryKey", IntegerType, true),
  StructField("AwardTitle", StringType, true),
  StructField("AwardEffectiveDate", StringType, true),
  StructField("AwardExpirationDate",StringType, true),
  StructField("AwardAmount",IntegerType, true),
  StructField("AbstractNarration",StringType, true),
  StructField("MinAmdLetterDate",StringType, true),
  StructField("MaxAmdLetterDate",StringType, true),
  StructField("ARRAAmount",IntegerType, true),
  StructField("AwardID",IntegerType, true),
  StructField("FK_rootTag",IntegerType, true)
))
val award_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").option("delimiter",",").option("quote","\"").option("escape", "\"").schema(award_csv_schema).load(award_csv)

val investigator_csv = "/home/lizichen/Desktop/collaboration_networks/Spark-Scripts/OriginalData/investigator.csv"
val investigator_csv_schema = StructType(Array(
  StructField("PrimaryKey", IntegerType, true),
  StructField("FirstName", StringType, true),
  StructField("LastName", StringType, true),
  StructField("EmailAddress",StringType, true),
  StructField("StartDate", StringType, true),
  StructField("EndDate", StringType, true),
  StructField("RoleCode",StringType, true),
  StructField("FK_Award",IntegerType, true)
))
val investigator_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").option("delimiter",",").option("quote","\"").option("escape", "\"").schema(investigator_csv_schema).load(investigator_csv)

val potential_investigator_all_csv = "/home/lizichen/Desktop/collaboration_networks/Data_Scrapping_And_PreProcess/all-investigator-csv-final48134/*.csv"
val potential_investigator_csv_schema = StructType(Array(
  StructField("LN_FN", StringType, true),
  StructField("SID", StringType, true),
  StructField("Affiliation", StringType, true)
))
val potential_investigators_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").option("delimiter",",").option("quote","\"").option("escape", "\"").schema(potential_investigator_csv_schema).load(potential_investigator_all_csv)

val coauthor_authorid_coauthorid_cfn_cln_csv = "/home/lizichen/Desktop/collaboration_networks/Spark-Scripts/OriginalData/coauthor_id_fn_ln.csv"
val coauthor_authorid_coauthorid_cfn_cln_csv_schema = StructType(Array(
  StructField("Author_SID",StringType, true),
  StructField("Coauthor_SID",StringType, true),
  StructField("Coauthor_FN",StringType, true),
  StructField("Coauthor_LN",StringType, true)
))
val coauthor_sid_name_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").option("delimiter",",").option("quote","\"").option("escape", "\"").schema(coauthor_authorid_coauthorid_cfn_cln_csv_schema).load(coauthor_authorid_coauthorid_cfn_cln_csv)


// Join programelement and award: "For each programelement, connect to all its awards"
val join_programelement_award = programelement_df.join(award_df, programelement_df("FK_rootTag") === award_df("FK_rootTag"))


val matchedAwardee_firstname_lastname_csv = "/home/lizichen/Desktop/collaboration_networks/Spark-Scripts/OriginalData/result_maxreps_apr25.csv"
val matchedAwardee_firstname_lastname_csv_schema = StructType(Array(
  StructField("Awardee_FN", StringType, true),
  StructField("Awardee_LN", StringType, true),
  StructField("Wrong_AID", StringType, true),     // Need to Remvoe
  StructField("Awardee_SID", StringType, true),
  StructField("Reps", StringType, true)           // Need to Remove
))

val matchedAwardee_SID_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").option("delimiter",",").option("quote","\"").option("escape", "\"").schema(matchedAwardee_firstname_lastname_csv_schema).load(matchedAwardee_firstname_lastname_csv).drop("Wrong_AID").drop("Reps")
