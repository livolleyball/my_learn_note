```
Dt ='2016-01-01'

WHILE ( ${Dt}<GETDATE() )
do
    SELECT * FROM 表 WHERE DAY BETWEEN ${Dt} AND ${${Dt}+1}
    Dt=${${Dt}+1}
done
```

```
day1=${zdt.addDay(-0).format("yyyyMMdd")}
used=`hadoop fs -du -s -h /| awk '{print $3}'`
var=`hadoop dfsadmin -report`
all1=${var:0:42}
all1=${all1% *}
all1=`expr ${all1##* } / 1024 / 1024 / 1024 / 1024`

hive -e "insert overwrite table rpt.mytb partition(day=$day1) select $day1,$all1,$used,hive_udf.ymm_current_millis() from rpt.oth_tb limit 1;"
```
