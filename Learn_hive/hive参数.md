


## metastore.warehouse.dir
位于 hive-site.xml
metastore.warehouse.dir       hive管理的所有数据都存放在使用hive定义的顶层目录下


## SerDe  是 serializer/deserializer 的缩写  序列化和反序列化
``` sql
create table json_serde_table (

)
row format serde 'org.openx.data.jsonserde.JsonSerDe'
with serdeproperties ("mapping._id"="id")
```


## hive 谓词下推 (predicate pushdown)
谓词下推的基本思想：尽可能早的处理表达式(expressions)，默认产生的执行计划在看到数据的地方添加过滤器filter
属于逻辑优化，优化器将谓词过滤下推到数据源，使物理执行跳过无关数据
谓词下推可通过设置参数hive.optimize.ppd=true来打开

``` java
public class PredicatePushDown implements Transform {

}
```
``` sql 
-- 生效
select a.id,a.value1,b.value2 from table1 a
join (select b.* from table2 b where b.ds>='20181201' and b.ds<'20190101') c
on (a.id=c.id)

select a.id,a.value1,b.value2 from table1 a
join table2 b on a.id=b.id
where b.ds>='20181201' and b.ds<'20190101'

-- 外连接失效
select a.id,a.value1,b.value2 from table1 a
left outer join table2 b on a.id=b.id
where b.ds>='20181201' and b.ds<'20190101'

```

``` 
hive -S -e "set" | grep aggr

hive.fetch.task.aggr=false
hive.groupby.mapaggr.checkinterval=100000
hive.map.aggr=true
hive.map.aggr.hash.force.flush.memory.threshold=0.9
hive.map.aggr.hash.min.reduction=0.5
hive.map.aggr.hash.percentmemory=0.5

```


## fetch.task.conversion
``` sql
简单的不需要聚合的类似SELECT <col> from <table> LIMIT n语句，不需要起MapReduce job，直接通过Fetch task获取数据
-- 会话级别
set hive.fetch.task.conversion=more;  -- value(none, minimal, more)  
``` 
``` shell
-- 会话级别
hive --hiveconf hive.fetch.task.conversion=more

-- 永久
在${HIVE_HOME}/conf/hive-site.xml里面加入以下配置：
<property>
  <name>hive.fetch.task.conversion</name>
  <value>more</value>
  <description>
    Some select queries can be converted to single FETCH task
    minimizing latency.Currently the query should be single
    sourced not having any subquery and should not have
    any aggregations or distincts (which incurrs RS),
    lateral views and joins.
    1. minimal : SELECT STAR, FILTER on partition columns, LIMIT only
    2. more    : SELECT, FILTER, LIMIT only (+TABLESAMPLE, virtual columns)
  </description>
</property>
``` 

## set hive.cli.print.header=true;


## 分区数据重载
第一种情况：一层分区的情况

        执行 MSCK REPAIR TABLE table_name;

第二种情况：多层分区情况

        执行 set hive.msck.path.validation=ignore;
                MSCK REPAIR TABLE table_name;