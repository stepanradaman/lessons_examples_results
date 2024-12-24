# kafka stream -> static csv

import findspark
findspark.init()
import os
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
from pyspark.sql.types import *

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

kafka_input_config = {
    "kafka.bootstrap.servers": "localhost:9092",
    "subscribe": "input",
    "startingOffsets": "latest",
    "failOnDataLoss": "false"
}

schema = StructType([
    StructField("id", IntegerType(), True),
    StructField("value", IntegerType(), True)
])

df = spark \
    .readStream \
    .format("kafka") \
    .options(**kafka_input_config) \
    .load() \
    .select(F.from_json(F.col("value").cast("string"), schema).alias("json")) \
    .select("json.*")

df = df.select(F.col("id").cast("integer"), F.col("value").cast("integer"))

query = df.writeStream \
    .format("csv") \
    .option("checkpointLocation", "checkpoint/") \
    .option("path", "output_path/") \
    .option("header", "true")  \
    .outputMode("append") \
    .start() \
    .awaitTermination()