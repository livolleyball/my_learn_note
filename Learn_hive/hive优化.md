一、查看执行计划
```
explain extended hql；可以看到扫描数据的hdfs路径
```
二、hive表优化
```
分区（不同文件夹）：
动态分区开启：
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions = 130000; -- 根据实际情况调节
set hive.exec.max.dynamic.partitions.pernode = 130000; -- 根据实际情况调节

    默认值：strict
   描述：strict是避免全分区字段是动态的，必须有至少一个分区字段是指定有值的

   避免产生大量分区



分桶（不同文件）：
set hive.enforce.bucketing=true;
set hive.enforce.sorting=true;开启强制排序，插数据到表中会进行强制排序，默认false；
```

三、Hive SQL优化
```
groupby数据倾斜优化
hive.groupby.skewindata=true;（多起一个job）1.join优化

（1）数据倾斜
hive.optimize.skewjoin=true;
如果是join过程出现倾斜，应该设置为true
set hive.skewjoin.key=100000;
这个是join的键对应的记录条数超过这个值则会进行优化
简单说就是一个job变为两个job执行HQL

（2）mapjoin(map端执行join）
启动方式一：(自动判断）
set.hive.auto.convert.join=true;
hive.mapjoin.smalltable.filesize 默认值是25mb
小表小于25mb自动启动mapjoin
启动方式二：(手动）
select /*+mapjoin(A)*/ f.a,f.b from A t join B f on (f.a=t.a)

mapjoin支持不等值条件
reducejoin不支持在ON条件中不等值判断

（3）bucketjoin(数据访问可以精确到桶级别）
使用条件：1.两个表以相同方式划分桶
         2.两个表的桶个数是倍数关系
例子：
create table order(cid int,price float) clustered by(cid)   into 32 buckets;
create table customer(id int,first string) clustered by(id)   into 32/64 buckets;

select price from order t join customer s on t.cid=s.id;

（4）where条件优化
优化前（关系数据库不用考虑会自动优化）：
select m.cid,u.id from order m join customer u on m.cid =u.id where m.dt='2013-12-12';

优化后(where条件在map端执行而不是在reduce端执行）：
select m.cid,u.id from （select * from order where dt='2013-12-12'） m join customer u on m.cid =u.id;

（5）group by 优化
hive.groupby.skewindata=true;
如果group by过程出现倾斜应该设置为true
set hive.groupby.mapaggr.checkinterval=100000;
这个是group的键对应的记录条数超过这个值则会进行优化

也是一个job变为两个job
（6）count distinct优化
优化前（只有一个reduce，先去重再count负担比较大）：
select count(distinct id) from tablename;
优化后（启动两个job，一个job负责子查询(可以有多个reduce)，另一个job负责count(1))：
select count(1) from (select distinct id from tablename) tmp;

select count(1) from (select id from tablename group by id) tmp;

set mapred.reduce.tasks=3;

 (7)
优化前：
select a,sum(b),count(distinct c),count(distinct d) from test group by a;

优化后：
select a,sum(b) as b,count(c) as c,count(d) as d from
（
select a, 0 as b,c,null as d from test group by a,c
union all
select a,0 as b, null as c,d from test group by a,d
union all
select a, b,null as c ,null as d from test) tmp group by a;
```

四、Hive job优化
```
1.并行化执行
hive默认job是顺序进行的，一个HQL拆分成多个job，job之间无依赖关系也没有相互影响可以并行执行
set hive.exec.parallel=true;

set hive.exec.parallel.thread.number=16;
就是控制对于同一个sql来说同时可以运行的job的最大值，该参数默认为8.此时最大可以同时运行8个job

2.本地化执行（在存放数据的节点上执行）

set hive.exec.mode.local.auto=true;

本地化执行必须满足条件：
（1）job的输入数据大小必须小于参数
hive.exec.mode.local.auto.inputbytes.max(默认128MB）
（2）job的map数必须小于参数：
hive.exec.mode.local.auto.tasks.max(默认为4）太多没有足够的slots
（3）job的reduce数必须为0或1


3.job合并输入小文件
set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat
多个split合成一个,合并split数由mapred.max.split.size限制的大小决定

4.job合并输出小文件（为后续job优化做准备）
set hive.merge.smallfiles.avgsize=256000000;当输出文件平均大小小于该值，启动新job合并文件

set hive.merge.size.per.task=64000000;合并之后的每个文件大小
## set spark.sql.hive.mergeFiles=true;   合并小文件

5.JVM重利用
set mapred.job.reuse.jvm.num.tasks=20;

每个jvm运行多少个task；

JVM重利用可以使job长时间保留slot，直到作业结束。
6.压缩数据（多个job）
（1）中间压缩处理hive查询的多个job之间的数据，对于中间压缩，最好选择一个节省cpu耗时的压缩方式
set hive.exec.compress.intermediate=true;
set hive.intermediate.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
set hive.intermediate.compression.type=BLOCK;按块压缩，而不是记录
（2）最终输出压缩（选择压缩效果好的，减少储存空间）
set hive.exec.compress.output=true;
set mapred.output.compress = true;
set mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec;
set mapred.output.compression.type=BLOCK;按块压缩，而不是记录
```

五、Hive Map优化
```
1.set mapred.map.tasks=10 无效
（1）默认map个数
default_num=total_size/block_size;
 (2)期望大小(手动设置的个数）
goal_num =mapred.map.tasks;
（3）设置处理的文件大小(根据文件分片大小计算的map个数）
split_size=max(block_size,mapred.min.split.size);
split_num=total_size/split_size;
（4）最终计算的map个数（实际map个数）
compute_map_num=min(split_num,max(default_num,goal_num))

总结：
（1）如果想增加map个数，则设置mapred.map.tasks为一个较大的值；
（2）如果想减小map个数，则设置mapred.min.split.size为一个较大的值。

2.map端聚合
set hive.map.aggr=true;相当于map端执行combiner


```

六、Hive Shuffle优化
```
Map 端
io.sort.mb
io.sort.spill.percent
min.num.spill.for.combine
io.sort.factor
io.sort.record.percent

reduce端
mapred.reduce.parallel.copies
mapred.reduce.copy.backoff
io.sort.factor
mapred.job.shuffle.input.buffer.percent
```


七、HIve Reduce优化
```
1.推测执行（默认为true）

mapred.reduce.tasks.speculative.execution(hadoop里面的)
hive.mapred.reduce.tasks.speculative.execution（hive里面相同的参数，效果和hadoop里面的一样）
两个随便哪个都行

2.Reduce优化(reduce个数设置）
set mapred.reduce.tasks=10;直接设置

最大值
hive.exec.reducers.max 默认：999

每个reducer计算的文件量大小
hive.exec.reducers.bytes.per.reducer 默认：1G

计算公式：虽然设了这么多，但不一定用到这么多
numRTasks =min[maxReducers,input.size/perReducer]
maxReducers=hive.exec.reducers.max
perReducer=hive.exec.reducers.bytes.per.reducer
```



八、队列
```
set mapred.queue.name=queue3;设置队列queue3
set mapred.job.queue.name=queue3;设置使用queue3
set mapred.job.priority=HIGH；
```


九 数据倾斜
```
 涉及数据倾斜的话，主要是reduce中数据倾斜的问题，可能通过设置hive中reduce的并行数，reduce的内存大小单位为m，reduce中 shuffle的刷磁盘的比例，来解决。
SET mapred.reduce.tasks=50;
SET mapreduce.reduce.memory.mb=6000;
SET mapreduce.reduce.shuffle.memory.limit.percent=0.06;
```

十 outofmemoryError
```
OOM  in mapper
mapred.child.java.opts/mapred.map.child.java.opts 提升至一个比较大的值
如果仍然存在 OOM
SET mapred.max.split.size=67108864;
OOM in shuffle/merge
SET mapred.reduce.tasks=64;
```

十一 maximum number of mappers via setting
```
set mapreduce.job.maps=128;
```


十二 Map-side join on Tez causes ClassCastException when a serialized table contains array column(s).
[Workaround] Try setting hive.mapjoin.optimized.hashtable off as follows:
```
set hive.mapjoin.optimized.hashtable=false;
```

十三 效率和稳定性相关参数
```
推测执行（默认为true）
mapred.map.tasks.speculative.execution 
mapreduce.reduce.speculative 是否为Map Task打开推测执行机制,默认是 true
mapreduce.map.speculative 是否为Reduce Task打开推测执行机制，默认为 true

```

十四 容错相关参数
```
mapreduce.map.maxattempts: 每个Map Task最大重试次数，一旦重试参数超过该值，则认为Map Task运行失败，默认值：4。
mapreduce.reduce.maxattempts: 每个Reduce Task最大重试次数，一旦重试参数超过该值，则认为Map Task运行失败，默认值：4。
```

十五 资源相关参数 
```
(1) mapreduce.map.memory.mb: 一个Map Task可使用的资源上限（单位:MB），默认为1024。如果Map Task实际使用的资源量超过该值，则会被强制杀死。
set mapreduce.map.memory.mb = 8192; -- 每个Map Task需要的内存量

(2) mapreduce.reduce.memory.mb: 一个Reduce Task可使用的资源上限（单位:MB），默认为1024。如果Reduce Task实际使用的资源量超过该值，则会被强制杀死。set mapreduce.reduce.memory.mb = 10500; -- 每个Reduce Task需要的内存量

(3) mapreduce.map.java.opts: Map Task的JVM参数，你可以在此配置默认的java heap size等参数, e.g.
“-Xmx1024m -verbose:gc -Xloggc:/tmp/@taskid@.gc” （@taskid@会被Hadoop框架自动换为相应的taskid）, 默认值: “”
set mapreduce.map.java.opts = - Xmx9192m;  --  设置Map任务JVM的堆空间大小，默认-Xmx1024m

(4) mapreduce.reduce.java.opts: Reduce Task的JVM参数，你可以在此配置默认的java heap size等参数, e.g.
“-Xmx1024m -verbose:gc -Xloggc:/tmp/@taskid@.gc”, 默认值: “”
set mapreduce.reduce.java.opts = - Xmx10000m;   -- 设置reduce任务JVM的堆空间大小，默认-Xmx1024m

(5) mapreduce.map.cpu.vcores: 每个Map task可使用的最多cpu core数目, 默认值: 1
set mapreduce.map.cpu.vcores = 4;  -- 每个Map Task需要的虚拟CPU个数

(6) mapreduce.reduce.cpu.vcores: 每个Reduce task可使用的最多cpu core数目, 默认值: 1
set mapreduce.reduce.cpu.vcores = 8;  -- 每个Reduce Task需要的虚拟CPU个数

```