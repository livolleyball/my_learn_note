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
FROM stocks s JOIN dividends d ON s.ymd = d.ymd AND s.symbol = d.symbol > WHERE s.symbol = 'AAPL';
```

```SQL
------------------------- 数据倾斜参数优化  ----------------------------------
SET hive.map.aggr=true;
会触发在map阶段的 “顶级” 聚合过程。
非顶级聚合过程将会在执行一个 group by 之后进行。
启动方式一：(自动判断）
set.hive.auto.convert.join=true;
hive.mapjoin.smalltable.filesize 默认值是25mb
小表小于25mb自动启动mapjoin
启动方式二：(手动）
select /*+mapjoin(A)*/ f.a,f.b from A t join B f on (f.a=t.a)


mapjoin支持不等值条件
reducejoin不支持在ON条件中不等值判断

hive.optimize.skewjoin=true;
如果是join过程出现倾斜，应该设置为true
set hive.skewjoin.key=100000;
这个是join的键对应的记录条数超过这个值则会进行优化
简单说就是一个job变为两个job执行HQL
