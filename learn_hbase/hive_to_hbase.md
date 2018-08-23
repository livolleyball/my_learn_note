[HBaseIntegration](https://cwiki.apache.org/confluence/display/Hive/HBaseIntegration#HBaseIntegration-ComplexCompositeRowKeysandHBaseKeyFactory)
* hive_to_hbase 字段的value 不能为null，会报 *org.apache.hadoop.hive.serde2.SerDeException: java.lang.NullPointerException*

```sql
CREATE TABLE hbase_table_1(key int, value string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf1:val")
TBLPROPERTIES ("hbase.table.name" = "xyz", "hbase.mapred.output.outputtable" = "xyz");
-- hbase.table.name 定义在hbase中的table名称

INSERT OVERWRITE TABLE hbase_table_1
select 1 key,'a' value
from (select 0) t ;



CREATE EXTERNAL TABLE hbase_table_2(key int, value string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = "cf1:val")
TBLPROPERTIES("hbase.table.name" = "some_existing_table", "hbase.mapred.output.outputtable" = "some_existing_table");


SET hive.hbase.bulk=true;
insert overwrite table hbase_hive_1 select * from pokes;
```

``` sql
创建有分区的表
CREATE TABLE hbase_hive_2(key int, value string)  
partitioned by (day string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf1:val")
TBLPROPERTIES ("hbase.table.name" = "xyz2");

INSERT OVERWRITE TABLE hbase_hive_2 partition (day='2012-01-01')
select 1 key,'a' value
from (select 0) t ;
```

```sql
两个map 指向 同一个列族，可以成功地将数据写入， 但是后续 通过hive 查询hbase_table_6 会将Hbase中的列，按照 int 和 string mapping 两份数据回来， 遇到数据类型无法转换的情况，将填充 null
CREATE TABLE hbase_table_6(row_key string,cf1 map<string,int>,cf2 map<string,string>)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES (
"hbase.columns.mapping" = ":key,cf1:,cf1:"
)
TBLPROPERTIES("hbase.table.name" = "xyz6", "hbase.mapred.output.outputtable" = "xyz6");

put 'xyz6','1','cf1:a','20180815'
-- hbase 中新增列 ，在hive中可查
hive 1	{"a":20180815}	{"a":"20180815"}

put 'xyz6','1','cf1:a_new','20180815'

hive> 1	{"a":20180815,"a_new":20180815}	{"a":"20180815","a_new":"20180815"}

put 'xyz6','1','cf1:a_new','201808.15'
-- 浮点型 map成int 时，浮点型数据精度截断
hive> 1	{"a":20180815,"a_new":201808}	{"a":"20180815","a_new":"201808.15"}


 put 'xyz6','1','cf1:a_new_0','2018084564613215464315461364651315'
 -- bigint map 成 int 时， bigint 无法转化，返回null
 hive> 1	{"a":20180815,"a_new":201808,"a_new_0":null}	{"a":"20180815","a_new":"201808.15","a_new_0":"2018084564613215464315461364651315"}

```
Note:
当maping 的字段过多时（100以上），建表语句不报错，但是insert 数据的时候， 会报错

org.apache.hadoop.hive.serde2.SerDeException org.apache.hadoop.hive.hbase.HBaseSerDe: columns has 223 elements while hbase.columns.mapping has 95 elements (counting the key if implicit))
