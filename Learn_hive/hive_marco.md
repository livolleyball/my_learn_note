#### nvl_array
```sql
DROP TEMPORARY MACRO IF EXISTS nvl_array;
CREATE TEMPORARY MACRO nvl_array(in_array array<string>)
    if(size(in_array) =-1 ,
	hive_udf.array_intersect(array('A'),array('C')),
in_array);
```

#### macro_daydiff
```sql
DROP TEMPORARY MACRO IF EXISTS macro_daydiff;
CREATE TEMPORARY MACRO macro_daydiff (in_day_1 int,in_day_2 int)
    if(in_day_1 is not null and in_day_2 is not null ,
 datediff(from_unixtime(unix_timestamp(cast(in_day_1 as string),'yyyyMMdd'),'yyyy-MM-dd')
 ,from_unixtime(unix_timestamp(cast(in_day_2 as string),'yyyyMMdd'),'yyyy-MM-dd'))
,null);
```
