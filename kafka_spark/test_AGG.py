# win very slow
# python 3.10

import findspark
findspark.init()
import os
import pyspark.sql.functions as F
import numpy as np
from pyspark.sql.types import *
from pyspark.sql import SparkSession
from scipy import stats

os.environ['PYSPARK_SUBMIT_ARGS'] = ('--jars ' +
                                     'postgresql-42.7.4.jar,' +
                                     'spark-streaming-kafka-0-10_2.12-3.5.0.jar,' +
                                     'spark-sql-kafka-0-10_2.12-3.5.0.jar,' +
                                     'kafka-clients-3.9.0.jar,' +
                                     'commons-pool2-2.12.0.jar,' +
                                     'spark-token-provider-kafka-0-10_2.12-3.3.0.jar' +
                                     ' pyspark-shell')

spark = SparkSession \
    .builder \
    .appName("session") \
    .master("local[*]") \
    .getOrCreate()

kafka_in = {
    "kafka.bootstrap.servers": "localhost:9092",
    "subscribe": "myinput",
    "startingOffsets": "latest",
    "failOnDataLoss": "false"
}

# kafka_out = {
#     "kafka.bootstrap.servers": "localhost:9092",
#     "topic": "myoutput",
#     "checkpointLocation": "./check2.txt"
# }

schema_out = StructType([
    StructField("id", IntegerType(), True),
    StructField("value", IntegerType(), True)
])

dfstream = spark \
    .readStream \
    .format("kafka") \
    .options(**kafka_in) \
    .load() \
    .select(F.from_json(F.col("value").cast("string"), schema_out).alias("json_data")) \
    .select("json_data.*")

dfstream = dfstream \
    .select(F.col("id").cast("integer"), F.col("value").cast("integer"))

def sum_of_squares(nums):
    n = len(nums)
    x = np.arange(0, n, 1, dtype=int)
    y = np.array(nums)
    gradient, intercept, r_value, p_value, std_err = stats.linregress(x, y)
    return [float(gradient), float(intercept)]

sum_of_squares_udf = F.udf(sum_of_squares, ArrayType(FloatType()))

# df = spark.createDataFrame([(1, 2.2), (1, 3.1), (1, 10.3)], ['id', 'value'])
# df_grouped = df.groupBy('id').agg(collect_list('value').alias('values'))
df_grouped = dfstream.groupBy('id').agg(F.collect_list('value').alias('values'))
df_result = (df_grouped
             .withColumn('grad', sum_of_squares_udf('values')[0])
             .withColumn('inter', sum_of_squares_udf('values')[1]))
# df_result.show()

# groupDf = dfstream.groupBy("id").agg(F.avg("value")).alias("avg_min"))
# output_df = groupDf.select(F.to_json(F.struct(*groupDf.columns)).alias("value"))

write = df_result \
    .writeStream \
    .trigger(processingTime='10 seconds') \
    .outputMode("update") \
    .format("console") \
    .start() \
    .awaitTermination()

