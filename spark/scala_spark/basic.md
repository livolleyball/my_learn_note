spark-shell  --master local[2]

val textFile = spark.read.textFile("/user/hbase/parse/data/test_turing_eleme_Salse/dt=2019-06-26/part-m-00000")