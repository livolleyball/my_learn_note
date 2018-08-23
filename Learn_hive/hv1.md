##### regexp_extract

```sql
select regexp_extract('["merchantTag","3"],["ptId","100010820210"]','(merchantTag",")(.*?)("])',2)
from (select  0) t limit 1;
```

```sql
-- 在有些情况下要使用转义字符，下面的等号要用双竖线转义，这是java正则表达式的规则。

select data_field,
     regexp_extract(data_field,'.*?bgStart\\=([^&]+)',1) as aaa,
     regexp_extract(data_field,'.*?contentLoaded_headStart\\=([^&]+)',1) as bbb,
     regexp_extract(data_field,'.*?AppLoad2Req\\=([^&]+)',1) as ccc
     from pt_nginx_loginlog_st
     where pt = '2012-03-26'limit 2;
```

```sql
select regexp_extract('foothebar', 'foo(.*?)(bar)', 1) fromiteblog;
the
select regexp_extract('foothebar', 'foo(.*?)(bar)', 2) fromiteblog;
bar
select regexp_extract('foothebar', 'foo(.*?)(bar)', 0) fromiteblog;
foothebar
```

```sql
hive -e "show databases"
hive -S -e "show databases"
hive -S -e "show databases" > /tmp/myquery_result

export HIVE_SKIP_SPARK_ASSEMBLY=true  --设置HIVE_SKIP_SPARK_ASSEMBLY，过滤掉WARN: Please slf4j

hive -S -e "set" | grep warehouse   --查询 warehouse 的属性
hive -f /path/to/file/withqueries.hql

set hive.cli.print.header=true;   -- 打印列名
select * from mytb limit 10;
```

```sql
alter table mytb archive partition (day= ); -- 将分区内的文件打包成一个Hadoop 压缩包(HAR)文件，但不会减少存储空间

alter table mytb unarchive partition (day= );
```

##  数据操作
```sql
load data local inpath '${env:HOME}/path'
overwrite into table mytb 
partition (day = );

set hive.exec.dynamic.partition=true;           -- 开启动态分区功能
set hive.exec.dynamic.partition.mode=nonstrict; -- 非严格模式
set hive.exec.max.dynamic.partitions.pernode = 1000;  -- 每个mapper 或 reducer 可以创建的最大动态分区个数； 超出会报错；

insert overwrite table mytb partition (day)
select * ,day
from oth_tb ;
```
## 查询
```sql
set hive.map.aggr=true;   -- 提高聚合性能；需要更多内存

select stack(2,col1,col2) from mytb; -- col1 col2 数据类型需一致

set hive.exec.mode.local.auto = true; -- 本地执行模式

set hive.auto.convert.join=true;     -- map的时候将小表完全放到内存中
-- 设置mapjoin 优化时，小表的大小（单位字节），但是right outer join 和 full join 不支持这个优化
set hive.mapjoin.smalltable.filesize=25000000;  
