-- sqlContext.sql("show databases").show()
spark.sql("select 1").show()
spark.sql("SELECT abs(-1)").show(10,false)
spark.sql("SELECT aggregate(array(1, 2, 3), 0, (acc, x) -> acc + x)").show(10,false) # 2.4 之后

spark.sql("SELECT array(1, 2, 3)").show(10,false)

spark.sql("SELECT array_contains(array(1, 2, 3), 2)").show(10,false)
spark.sql("SELECT array_distinct(array(1, 2, 3, null, 3))").show(10,false) -- Since: 2.4.0
spark.sql("").show(10,false)

spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)
spark.sql("").show(10,false)