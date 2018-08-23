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
