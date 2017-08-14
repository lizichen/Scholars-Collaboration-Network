// The dir: publicasList_CSV
//  contains files each contains list of publications in detail of an author.
//  the file name, i.e., 123456789.csv represents the Scopus ID of the author.

// Each CSV file has these columns:
// Authors,Title,Year,Source title,Volume,Issue,Art. No.,Page start,Page end,Page count,Cited by,DOI,Link,Document Type,Source,EID

// This Scala script extra the url of each publications in a csv file and store into another folder: publicationUrlCsvFiles.

// Execute Spark to start pricessing this script.

// spark-shell --packages com.databricks:spark-csv_2.11:1.5.0

import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.types.{StructType, StructField, IntegerType, StringType}
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.Dataset
import org.apache.spark.sql.functions.input_file_name

val publicationsDetailCsvFiles = "/home/lizichen/Desktop/collaboration_networks/PublicationsListRetrieval/publicationsList_CSV/*.csv"

val publicationsDetailCsvSchema = StructType(Array(
  StructField("Authors",        StringType, true),
  StructField("Title",          StringType, true),
  StructField("Year",           StringType, true),
  StructField("Source_Title",   StringType, true),
  StructField("Volume",         StringType, true),
  StructField("Issue",         StringType, true),
  StructField("Article_Number", StringType, true),
  StructField("Page_Start",     StringType, true),
  StructField("Page_End",       StringType, true),
  StructField("Page_Count",     StringType, true),
  StructField("Cited_By",       StringType, true),
  StructField("DOI",            StringType, true),
  StructField("Link",           StringType, true),
  StructField("Doc_Type",       StringType, true),
  StructField("Source",         StringType, true),
  StructField("EID",            StringType, true)
))

val sqlContext = new SQLContext(sc)
val publication_sid_and_eid = sqlContext.read.format("com.databricks.spark.csv").option("header","true").schema(publicationsDetailCsvSchema).load(publicationsDetailCsvFiles).select(input_file_name, $"EID").as[(String, String)]

val sid_eid_table = publication_sid_and_eid.map(s => ((s._1.split("/")(7)).split(".csv")(0), s._2))

val final_sid_eid_table = sid_eid_table.withColumnRenamed("_1", "sid").withColumnRenamed("_2", "eid")

final_sid_eid_table.write.mode("append").json("./SID_EID_Table")
