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
```sql
DROP TEMPORARY MACRO IF EXISTS macro_daydiff_pow;
CREATE TEMPORARY MACRO macro_daydiff_pow (in_day_1 int,in_day_2 int, a DOUBLE)
    if(in_day_1 is not null and in_day_2 is not null ,pow(a,hive_udf.daydiff(in_day_1,in_day_2))
,null);

select macro_daydiff_pow(20180804,20180804,0.99)
```
#### date to day
``` sql
DROP TEMPORARY MACRO IF EXISTS macro_date_to_day;
CREATE TEMPORARY MACRO macro_date_to_day (in_date string)
    if(in_date is not null  ,
 cast(from_unixtime(unix_timestamp(cast(in_date as string),'yyyy-MM-dd'),'yyyyMMdd') as int)
 -- regexp_replace(substr(in_date,1,10),"-","")
,0);

select macro_date_to_day('2018-09-10')=20180910;
```


#### nvl nvl_enum
``` sql
DROP TEMPORARY MACRO IF EXISTS macro_nvl_enum;
CREATE TEMPORARY MACRO macro_nvl_enum (in_column string)
  if(in_column is null or in_column ='' or in_column ='null' or in_column ='NULL','未知', in_column));
  
```
