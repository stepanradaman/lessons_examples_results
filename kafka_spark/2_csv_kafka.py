# static batch csv -> kafka
# to do: stream batch csv -> kafka ()

# data
# {"id": 1, "value": 1}
# {"id": 2, "value": 2}
# {"id": 3, "value": 3}
# {"id": 4, "value": 4}

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
    "subscribe": "input",
    "startingOffsets": "latest",
    "failOnDataLoss": "false"
}

kafka_out = {
    "kafka.bootstrap.servers": "localhost:9092",
    "topic": "output",
    "checkpointLocation": "./check1.txt"
}

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

# --------------------------------------------------------------------1
# df_process = (spark
#     .readStream
#     .schema(schema_out)
#     .option("header", "true")
#     .option("sep", ",")
#     .csv("output_path/")
# )
#
# df_process.createOrReplaceTempView("table")
# table = spark.sql("select value from table")
#
# write = table.writeStream.format("console").start().awaitTermination()
# --------------------------------------------------------------------1

# --------------------------------------------------------------------2
# def foreach_batch_function(df, epoch_id):
#     # df.show()
#     df.write \
#         .mode("append") \
#         .format("jdbc") \
#         .option("url", "jdbc:postgresql://localhost:5432/postgres") \
#         .option("driver", "org.postgresql.Driver") \
#         .option("dbtable", "public.table") \
#         .option("user", "user") \
#         .option("password", "password") \
#         .save()
#
# df.writeStream \
#     .foreachBatch(foreach_batch_function) \
#     .trigger(processingTime='10 seconds') \
#     .start() \
#     .awaitTermination()
# --------------------------------------------------------------------2

spark.sparkContext.setCheckpointDir("checkpoint")
df_process = (spark
    .read
    .schema(schema_out)
    .option("header", "true")
    .option("sep", ",")
    .csv("output_path/")
    .checkpoint()
)

values = df_process.select("value").collect()
a = []
for row in values:
    val = row["value"]
    a.append(val)

n = df_process.count()
x = np.arange(0, n, 1, dtype=int)
y = np.array(a)
gradient, intercept, r_value, p_value, std_err = stats.linregress(x, y)

dfstream = dfstream \
    .withColumn("gradient", F.lit(gradient)) \
    .withColumn("intercept", F.lit(intercept)) \
    .select(F.col("id").cast("integer"), F.col("value").cast("integer"), F.col("gradient").cast("double"),
            F.col("intercept").cast("double"))

output_df = dfstream.select(F.to_json(F.struct(*dfstream.columns)).alias("value"))

write = output_df \
    .writeStream \
    .format("kafka") \
    .options(**kafka_out) \
    .start()

write.awaitTermination()