##  配置
### HIVE_DEFAULT_PARTITION
```sql
在hive里面表可以创建成分区表，但是当分区字段的值是'' 或者 null时 hive会自动将分区命名为默认分区名称。

默认情况下，默认分区的名称为 __HIVE_DEFAULT_PARTITION__ 

当然默认分区名称是可配置的

配置参数是 hive.exec.default.partition.name

set  hive.exec.default.partition.name;

-- sql：分区字段day出现了null值
select  date(create_time),count(1)
from mytb
where day is null
group by date(create_time)
```

```sql
--------------     Hive 分区表新增字段或者修改字段类型等不生效       ---------------------------
标题比较笼统，实际情况是： 
对于Hive 的分区外部表的已有分区，在对表新增或者修改字段后，相关分区不生效。

原因是：表元数据虽然修改成功，但是分区也会对应列的元数据，这个地方不会随表的元数据修改而修改.
处理办法：
有两种
第一种：修改表，然后对于需要生效的分区，先drop 再 add. （或者说：先drop 表在重新建表再添加分区）
第二种：修改表，对需要生效的分区也执行添加或者修改字段的操作，比如：

alter table dmp.table  partition(day='20181128') change column cargo_channel cargo_channel bigint;

alter table dmp.table  change column cargo_channel cargo_channel bigint CASCADE;

```

```sql
FAILED: SemanticException [Error 10022]: DISTINCT on different columns not supported with skew in data

set hive.groupby.skewindata=true;  -- 避免因数据倾斜造成的计算效率问题
这个参数 不支持 对多列进行 count(DISTINCT columns)


set hive.groupby.skewindata=true;
select count(distinct prov_id),
count(distinct deep)
from dim.dim_city;

set hive.groupby.skewindata=true;
select size(collect_set(prov_id)),
size(collect_set(deep))
from dim.dim_city;

-- collect_set  会将 null 过滤掉
set hive.groupby.skewindata=true;
select size(collect_set(if(prov_id>=0,prov_id,null)))
,size(collect_set(if(deep>=1,deep,null)))
,collect_set(if(deep>=1,deep,null))
from dim.dim_city;
```

```sql
Caused by: org.apache.hadoop.hive.ql.metadata.HiveException: Hive Runtime Error while processing row 
        at org.apache.hadoop.hive.ql.exec.vector.VectorMapOperator.process(VectorMapOperator.java:52)
        at org.apache.hadoop.hive.ql.exec.mr.ExecMapper.map(ExecMapper.java:176)
        ... 8 more


set hive.vectorized.execution.enabled=false;
```

```sql
Caused by: org.apache.hadoop.hive.ql.metadata.HiveException:
Hive Runtime Error while processing row [Error getting row data with exception java.lang.ClassCastException:
 org.apache.hadoop.io.Text cannot be cast to org.apache.hadoop.io.LongWritable
这个类型转换错误发生在

size(collect_set(if((A.is_tap = 1 and car_interest_tap_cnt>0),A.user_id,null))) as full_cnt

原因是 car_interest_tap_cnt 的类型是string ，在内嵌的计算逻辑中出现了 比较时类型不对。 最终比较隐蔽

```

``` sql
hive 不支持非等价关联


----------------------------Origin SQL-------------------------------
SELECT table1.id, table1.date_added, table2.date_added
FROM table1
LEFT JOIN table2 ON table1.id=table2.id
AND table1.date_added > table2.date_added


----------------------------Modified SQL-------------------------------
SELECT a.id, a.date_added, b.date_added
FROM table1 a
LEFT JOIN
(SELECT table1.id, table2.date_added
FROM table1
JOIN table2 ON table1.id=table2.id
WHERE table1.date_added > table2.date_added) b
ON a.id = b.id

表B 中如果 table2 数据较少， left join 会在  >  两边存在 null 的可能性，导致统计出错。

```

```SQL
--------------------------  mapjoin -------------------------------------------
-- deprecated as of Hive v0.7
SELECT /*+ MAPJOIN(d) */ s.ymd, s.symbol, s.price_close, d.dividend
FROM stocks s JOIN dividends d
ON s.ymd = d.ymd AND s.symbol = d.symbol WHERE s.symbol = 'AAPL';


set hive.auto.convert.join=true;
SELECT s.ymd, s.symbol, s.price_close, d.dividend
FROM stocks s JOIN dividends d ON s.ymd = d.ymd AND s.symbol = d.symbol 
WHERE s.symbol = 'AAPL';
```


``` sql
------------------------- 分区问题  ----------------------------------
create table tmp.lihm_20181118
(id bigint comment 'id')
comment 'a'
partitioned by (day int,hour int);

insert overwrite table tmp.lihm_20181118 partition (day =20181118,hour =12)
select id from dim.dim_city where name ='a'; -- 没有 name等于‘a’的数据

select day,hour from tmp.lihm_20181118 group by day,hour;
return
20181118,12

select day,hour,count(1) from tmp.lihm_20181118 group by day,hour;
return
0 rows；

select day,count(distinct hour),count(1) from tmp.lihm_20181118 group by day;
select day,count(distinct hour),count(*) from tmp.lihm_20181118 group by day;
return
0 results

select day,count(distinct hour) from tmp.lihm_20181118 group by day
return
20181118,1
```

八 特殊字符导致数据与字段错位
```sql
-- 特殊字符导致数据与字段错位
\t：tab，跳格（移至下一列）
\r：回车
\n：换行

select regexp_replace('\t abc \n def \r hij', '\n|\t|\r', '--');
```


九 Max block location exceeded for split   splitsize: 20 maxsize: 15

```
hive任务中间数据产生大量小文件，导致split超过了maxsize
通过设置
set mapreduce.job.max.split.locations=100;

This configuration is involved since MR v1. 
It serves as an up limit for DN locations of job split which intend to protect the JobTracker from overloaded by jobs with huge numbers of split locations. 
For YARN in Hadoop 2, this concern is lessened as we have per job AM instead of JT. 
However, it will still impact RM as RM will potentially see heavy request from the AM which tries to obtain many localities for the split. With hitting this limit, it will truncate location number to given limit with sacrifice a bit data locality but get rid of the risk to hit bottleneck of RM.
Depends on your job's priority (I believer it is a per job configuration now), you can leave it as a default (for lower or normal priority job) or increase to a larger number.
Increase this value to larger than DN number will be the same impact as set it to DN's number.
 当 mapreduce.job.max.split.locations 设置大于DN的数量时，将和等于DN数量时的影响相同
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

十二  Tez 表中存在 array 字段
Map-side join on Tez causes ClassCastException when a serialized table contains array column(s).
[Workaround] Try setting hive.mapjoin.optimized.hashtable off as follows:
``` SQL
set hive.mapjoin.optimized.hashtable=false;
```

十三  org.apache.hadoop.hive.ql.plan.ConditionalWork cannot be cast to org.apache.hadoop.hive.ql.plan.MapredWork

hive.ql.plan.ConditionalWork cannot be cast to hive.ql.plan.MapredWork
``` sql
SET hive.auto.convert.join.noconditionaltask=true;
```


十四 Job Submission failed with exception 'java.io.IOException(Unable to close file 
  because the last block BP-1418026952-10.200.200.7-1526660093855:blk_1106599924_32862496 does not have enough number of replicas.)'
```sql
not have enough number of replicas
分析：
可能是NameNode过于繁忙，locateFollowingBlock方法请求Name Node为文件添加新块发生错误，无法定位下一个块。建议增加locateFollowingBlock方法重试次数参
解决办法：
修改默认作业参数dfs.client.block.write.locateFollowingBlock.retries＝15 （默认是5)
```


十五 Hive on tez的insert union 子目录的问题

>最小分区文件夹下出现了二级目录 
>tez对于insert union操作会进行优化，通过并行加快速度，为防止有相同文件输出，所以对并行的输出各自生成成了一个子目录，在子目录中存放结果。

在Hive默认设置中，hive只能读取对应表目录下的文件，
* ~~如果表目录中同时存在目录和文件~~
  ~~则使用hive进行读取时，会报目录非文件的错误~~
* ~~表目录中只有目录，hive不会进行深层递归查询，只会读取到对应查询目录，会查询结果为空~~
* 表目录中只有文件，则可以正常查询
```sql
-- hive 开启mapreduce的递归查询模式：
set mapreduce.input.fileinputformat.input.dir.recursive=true;

-- impala  没有发现 recursive 参数
-- hive impala tez 混用场景建议，union 之后复写目标表 
-- 如果 将union部分嵌套为子查询,会被tez执行计划优化掉

```