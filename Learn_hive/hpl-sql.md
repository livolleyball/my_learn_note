
### 下载 [hplsql](http://www.hplsql.org/download)
```
tar -xzvf hplsql.tar.gz
chmod +x <hplsql_dir>/hplsql
```

### 配置
针对CDH 版本，编辑 *hqlsql*  文件
```
删除
export "HADOOP_CLASSPATH=..."

后添加
export "HADOOP_CLASSPATH=/opt/cloudera/parcels/CDH/jars/*"
```

### test
```
./hplsql --version
HPL/SQL 0.3.31
```

### 添加环境变量
```
export PATH=$PATH:<hplsql_dir>

hplsql
usage: hplsql
 -d,--define <key=value>          Variable subsitution e.g. -d A=B or
                                  --define A=B
 -e <quoted-query-string>         HPL/SQL from command line
 -f <filename>                    HPL/SQL from a file
 -H,--help                        Print help information
    --hiveconf <property=value>   Value for given property
    --hivevar <key=value>         Variable subsitution e.g. --hivevar A=B
 -main <procname>                 Entry point (procedure or function name)
 -offline,--offline               Offline mode - skip SQL execution
 -trace,--trace                   Print debug information
 -version,--version               Print HPL/SQL version
```
### CDH 启动 hiveserver2
```
cd /opt/cloudera/parcels/CDH/bin
./hive  --service hiveserver2  2>&1 >/dev/null
命令						标准输出	错误输出
>/dev/null 2>&1	丢弃	丢弃
2>&1 >/dev/null	丢弃	屏幕
```
### 新建 FUNCTION 文件1.sql
``` sql
CREATE FUNCTION hello(text STRING)
 RETURNS STRING
BEGIN
 RETURN 'Hello, ' || text || '!';
END;

FOR item IN (
  SELECT tag_id FROM ods.table limit 10
)
LOOP
PRINT hello(item.tag_id);
END LOOP;
````
```
hplsql -f 1.sql

retrun

Hello, 300001000010186!
Hello, 300001000010186!
Hello, 300001000010190!
Hello, 300001000010190!
Hello, 300001000010191!
Hello, 300001000010191!
Hello, 300001000010231!
Hello, 300001000010231!
Hello, 300001000010300!
Hello, 300001000010300!

```
