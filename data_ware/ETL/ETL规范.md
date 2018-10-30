### JOB命名规范
ETL的命名采用该ETL转换或抽取之后，生成的数据所在的 目的库名+目的模型名 的方式， 格式：<目的库名>.<目的模型名>
比如
1. 数据抽取ETL：ods_dbname.table_name
2. 数据转换ETL：dwd_dbname.table_name
3. 数据加载Mysql ETL：bd_report_center.ogin_excep_region_daily

### HQL开发规范
1. 由于小文件会对namenod造成很大的压力，所以当发现表里面过多的小文件时。在ETL时加上如下合并参数：
```SQL
set hive.mergejob.maponly = true;
set hive.merge.mapfiles = true;
set hive.merge.mapredfiles = true;
set mapred.max.split.size=256000000;
set mapred.min.split.size.per.node=256000000;
set mapred.min.split.size.per.rack=256000000;
set hive.merge.size.per.task = 256000000;
set hive.merge.smallfiles.avgsize=100000000;
set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
```
2.  如果上游血缘表中有分区，必须使用分区查询，避免全表扫描
3.  所有关于金额的字段，都转换成分
4.  所有的HQL必须在第一行加注释，注释为ETL的名称（方便在Yarn查询的时候调查）

### HQL更新规范
检查hql对应的模型，查看依赖关系，评估影响面
更新完hql之后，zeus中根据需求配置依赖关系
Shell结构规范
1. GIT上的目录结构及目录名称与运行环境必须完全一致
2. 目录结构：
bin： shell脚本
script： hive/spark脚本
conf： 配置文件
lib： 放置jar包
logs： 日志文件
schema： 建库，建表语句
data： 数据文件
3. 文件名后缀规范
Shell脚本： .sh
配置文件：  .conf  
建库、建表语句：  .sql
Hive 脚本： .sql
日志文件： .log
4. 脚本规范
必须使用bash解释执行  #!/bin/bash （只针对shell脚本）
必须智能判断当前目录，例如：curDir=$(cd `dirname $0`;pwd)   cd $curDir
必须判断参数长度格式是否正确
必须脚本内部使用相对目录
内部必须不包含任何配置的信息
每个脚本必须注明开发人名字、脚本的用途描述，在一些难理解的方法注明方法作用
5.  shell文件名全部小写，多个单词用下划线分割
6. shell函数名全部小写，多个单词用下划线分割
7.  shell脚本的基本结构
```shell
#!bin/bash
CONFIGURATION_VARIABLES
FUNCTION_DEFINITIONS
MAIN_CODE
```

8. 配置文件规范
    采用key=value的样式，字符串用单引号或者双引号引起来， 如果有层级关系，用.号分割，比如：
    ```
    count=1
    password=”test”
    canal.instance.db=logistics
```
