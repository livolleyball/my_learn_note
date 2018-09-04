#### hadoop fs
```
[-appendToFile <localsrc> ... <dst>]
[-cat [-ignoreCrc] <src> ...]
[-checksum <src> ...]
[-chgrp [-R] GROUP PATH...]
[-chmod [-R] <MODE[,MODE]... | OCTALMODE> PATH...]
[-chown [-R] [OWNER][:[GROUP]] PATH...]
[-copyFromLocal [-f] [-p] [-l] <localsrc> ... <dst>]
[-copyToLocal [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
[-count [-q] [-h] <path> ...]
[-cp [-f] [-p | -p[topax]] <src> ... <dst>]
[-createSnapshot <snapshotDir> [<snapshotName>]]
[-deleteSnapshot <snapshotDir> <snapshotName>]
[-df [-h] [<path> ...]]
[-du [-s] [-h] <path> ...]
[-expunge]
[-find <path> ... <expression> ...]
[-get [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
[-getfacl [-R] <path>]
[-getfattr [-R] {-n name | -d} [-e en] <path>]
[-getmerge [-nl] <src> <localdst>]
[-help [cmd ...]]
[-ls [-d] [-h] [-R] [<path> ...]]
[-mkdir [-p] <path> ...]
[-moveFromLocal <localsrc> ... <dst>]
[-moveToLocal <src> <localdst>]
[-mv <src> ... <dst>]
[-put [-f] [-p] [-l] <localsrc> ... <dst>]
[-renameSnapshot <snapshotDir> <oldName> <newName>]
[-rm [-f] [-r|-R] [-skipTrash] <src> ...]
[-rmdir [--ignore-fail-on-non-empty] <dir> ...]
[-setfacl [-R] [{-b|-k} {-m|-x <acl_spec>} <path>]|[--set <acl_spec> <path>]]
[-setfattr {-n name [-v value] | -x name} <path>]
[-setrep [-R] [-w] <rep> <path> ...]
[-stat [format] <path> ...]
[-tail [-f] <file>]
[-test -[defsz] <path>]
[-text [-ignoreCrc] <src> ...]
[-touchz <path> ...]
[-usage [cmd ...]]

-ls 显示当前目录结构

-ls -R 递归显示目录结构

-du 统计目录下文件大小 ;  
-du  /  |sort  -r -h |awk '{print $1/(1024*1024),  $3}' 列出文件大小并倒序 ;
-du -s 汇总目录下文件大小,单位字节  ;
-du -h ,显示目录下各个文件的大小。
-du -s -h  /user/hive/warehouse/table_test ，汇总该表所占据的存储空间,显示单位。

-rm -f -r 递归删除目录文件

-cp -f 复制文件 source destination

-mv 移动文件或目录

-mkdir 创建目录

-get -f 下载文件

-put -f 上传文件

hadoop fs -rm -r -skipTrash 永久删除

```


3. hadoop fs ，hadoop dfs ，hdfs dfs 都可以进行操作。 hadoop fs 的使用面最广，可以操作所有的文件系统； hadoop dfs ，hdfs dfs 只能操作 HDFS相关的文件。【Linux 目录环境】

4. 在hive 模式下，使用 dfs 命令进行相关操作，
如删除文件：dfs -rm -r -f  /user/hive/warehouse/ods/t_column_to_row

5. hadoop fs -du  /user/hive/warehouse/ods  |sort -r -n -k 1 |awk '{ print $1/(1024*1024*1024),$3}'  |head -20   -- 查询指定目录下存储量最大的top20


##### regexp_extract
```sql
select regexp_extract('["merchantTag","3"],["ptId","100010820210"]','(merchantTag",")(.*?)("])',2)
from (select  0) t limit 1;

select
regexp_extract('foothebar', 'foo(.*?)(bar)', 1),       -- the
regexp_extract('foothebarfoothebar', 'foo(.*?)(bar)', 1)  -- the    匹配第一次出现的
     from (select 0 ) a

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
hive -S -e "show databases"  -- 过滤掉 time_taken and total_row
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


select stack(2,col1,col2) from mytb; -- col1 col2 数据类型需一致

set hive.exec.mode.local.auto = true; -- 本地执行模式

set hive.auto.convert.join=true;     -- map的时候将小表完全放到内存中
-- 设置mapjoin 优化时，小表的大小（单位字节），但是right outer join 和 full join 不支持这个优化
set hive.mapjoin.smalltable.filesize=25000000;
set hive.map.aggr=true;   -- 提高聚合性能；需要更多内存
