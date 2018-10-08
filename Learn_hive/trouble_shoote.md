##  配置
### HIVE_DEFAULT_PARTITION
```sql
在hive里面表可以创建成分区表，但是当分区字段的值是'' 或者 null时 hive会自动将分区命名为默认分区名称。

默认情况下，默认分区的名称为__HIVE_DEFAULT_PARTITION__

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
FAILED: SemanticException [Error 10022]: DISTINCT on different columns not supported with skew in data

set hive.groupby.skewindata=true;
这个参数 不支持 对多列进行 count(DISTINCT columns)
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
size(collect_set(if((A.is_tap = 1 and car_interest_tap_cnt>0),A.user_id,0))) as full_cnt ,
size(hive_udf.ymm_array_remove(collect_set(if((A.is_tap = 1 and car_interest_tap_cnt>0),A.user_id,0)),0)) as car_interest_user_cnt

原因是 car_interest_tap_cnt 的类型是string ，在内嵌的计算逻辑中出现了 比较时类型不对。 最终比较隐蔽

```
