val matchedResult = "/Users/lizichen1/Google_Drive/collaboration_networks/test_publication_list_retrieval/result_maxreps_apr25.csv"

val matchedResult_schema = StructType(Array(
  StructField("firstname", StringType, true),
  StructField("lastname", StringType, true),
  StructField("awardid", StringType, true),
  StructField("sid",StringType, true),
  StructField("reps",IntegerType, true)
))

val matched_result_df = sqlContext.read.format("com.databricks.spark.csv").option("header","false").schema(matchedResult_schema).load(matchedResult)

news_duringTradingHours.write.format("org.apache.spark.sql.json").mode(SaveMode.Append).save("News_10am_4pm_noSector");


