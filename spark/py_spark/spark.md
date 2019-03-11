1.使用高性能算子：

mapPartitions替代map：每个Task执行一次Function，需深刻了解RDD数量和程序的内存使用防止OOM。

mapPartitionsWithIndex：增加分区索引参数提高性能。

reduceByKey替代groupByKey：相对于普通shuffle操作会进行map端的本地聚合（类combiner），减少磁盘I/O和占用，减少Reduce端的数据量和内存开销。

aggregateByKey：分别定义Map和Reduce两端的aggregate函数。

foreachPartition替换foreach：常用来写存储，创建或者获取一次数据库连接，同样需要注意OOM。

coalesce()：fliter之后使用可以重新整合并行度，需要注意分区数据可序列化。

repartitionAndSortWithinPartitions替代repartitions：一边shuffle一边sort，比repartition先Shuffle再sort快

cache()，缓存多次使用的DStream，防止网络开销。action后unpersist()

 

2.针对Kafka流处理的SparkStreaming优化

spark.streaming.kafka.maxRatePerPartition ，  默认kafka当中有多少数据它就会直接全部拉出。

spark.default.parallelism ，  Spark中的Partition和Kafka中的Partition是一一对应的，所以一般默认设置为Kafka中Partition的数量。

--conf "spark.executor.extraJavaOptions=-XX:+UseConcMarkSweepGC"，使用CMS(标记清除)，使GC更频繁且对吞吐率要求更低。

                                                                  -XX:CMSInitiatingOccupancyFraction  ,   使用CMS

                                                                  -XX:CMSInitiatingOccupancyFraction=10， 年老代使用率10%时触发GC

spark.serializer ， 使用Kryo做序列化，org.apache.spark.serializer.KryoSerializer

                              注册自定义类，registerKryoClasses(new  Class[]{YourClass.class})

                              
使用广播变量，
反压，
spark.streaming.backpressure.enabled ，默认false
spark.streaming.backpressure.initialRate ，默认直接取所有
spark.streaming.blockInterval ，默认200