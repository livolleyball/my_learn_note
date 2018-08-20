[Hive中跑MapReduce Job出现OOM问题分析及解决](https://blog.csdn.net/oopsoom/article/details/41356251)
```
一是HiveQL的写法上，尽量少的扫描同一张表，并且尽量少的扫描分区。扫太多，一是job数多，慢，二是耗费网络资源，慢。
二是Hive的参数调优和JVM的参数调优，尽量在每个阶段，选择合适的jvm max heap size来应对OOM的问题。

1. 增加reduce个数，set mapred.reduce.tasks=300，。
2. 在hive-site.xml中设置，或者在hive shell里设置 set  mapred.child.java.opts = -Xmx512m
   或者只设置reduce的最大heap为2G，并设置垃圾回收器的类型为并行标记回收器，这样可以显著减少GC停顿，但是稍微耗费CPU。
   set mapred.reduce.child.java.opts=-Xmx2g -XX:+UseConcMarkSweepGC;
3. 使用map join 代替 common join. 可以set hive.auto.convert.join = true
4. 设置 hive.optimize.skewjoin = true 来解决数据倾斜问题
```
