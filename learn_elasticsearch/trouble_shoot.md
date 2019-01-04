hive2es
```
Error: java.io.IOException: java.lang.reflect.InvocationTargetException
Caused by: java.lang.reflect.InvocationTargetException
Caused by: java.lang.IndexOutOfBoundsException: Index: 1, Size: 1
ParquetRecordReaderWrapper
DocValues是一个种列式的数据存储结构（docid、termvalues）。

参考原因：
Caused by: java.io.IOException  
org.apache.hadoop.hive.io.HiveIOExceptionHandlerChain.handleRecordReaderCreationException(HiveIOExceptionHandlerChain.java:97)
Caused by: java.lang.IndexOutOfBoundsException: Index: 13, Size: 13   下标溢出

原因：
ORC格式是列式存储的表，不能直接从本地文件导入数据，只有当数据源表也是ORC格式存储时，才可以直接加载，否则会出现上述报错。
解决办法：
要么将数据源表改为以ORC格式存储的表，要么新建一个以textfile格式的临时表先将源文件数据加载到该表，然后在从textfile表中insert数据到ORC目标表中。
```
```
Hive loading data into ES error: org.elasticsearch.hadoop.rest.EsHadoopNoNodesLeftException: Connection error (check network and/or proxy settings)- all nodes failed

'es.batch.write.retry.wait' = '10s',
'es.batch.write.refresh' = 'false',
'es.nodes.discovery' = 'true',
'es.nodes.client.only' = 'false'

https://github.com/elastic/elasticsearch-hadoop/issues/606
```
