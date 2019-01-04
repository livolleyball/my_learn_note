#### nvl_array
```sql
DROP TEMPORARY MACRO IF EXISTS nvl_array;
CREATE TEMPORARY MACRO nvl_array(in_array array<string>)
    if(size(in_array) =-1 ,
	hive_udf.array_intersect(array()),
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
  if(in_column is null or in_column ='' or in_column ='null' or in_column ='NULL','未知', in_column);

```

### cst_to_datetime
``` sql
DROP TEMPORARY MACRO IF EXISTS cst_to_datetime;
CREATE TEMPORARY MACRO cst_to_datetime(in_cst string)
    if(in_cst is not null  ,
	case
when split(in_cst,' ')[1]="Jan" then concat(split(in_cst,' ')[5],'-01-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Feb" then concat(split(in_cst,' ')[5],'-02-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Mar" then concat(split(in_cst,' ')[5],'-03-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Apr" then concat(split(in_cst,' ')[5],'-04-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="May" then concat(split(in_cst,' ')[5],'-05-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Jun" then concat(split(in_cst,' ')[5],'-06-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Jul" then concat(split(in_cst,' ')[5],'-07-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Aug" then concat(split(in_cst,' ')[5],'-08-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Sep" then concat(split(in_cst,' ')[5],'-09-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Oct" then concat(split(in_cst,' ')[5],'-10-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Nov" then concat(split(in_cst,' ')[5],'-11-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
when split(in_cst,' ')[1]="Dec" then concat(split(in_cst,' ')[5],'-12-',split(in_cst,' ')[2],' ',split(in_cst,' ')[3] )
end ,
null);

SELECT cst_to_datetime('Thu Dec 27 16:51:55 CST 2018')
```