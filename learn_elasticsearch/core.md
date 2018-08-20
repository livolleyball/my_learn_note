
[elasticsearch的Doc Values 和 Fielddata](https://blog.csdn.net/thomas0yang/article/details/64905926)
```
DocValues就是一个种列式的数据存储结构（docid、termvalues）。
倒排索引的优势在于查找包含某个项的文档，即通过Term查找对应的docid
1. 定位数据范围term。检索到Term=’brown’的docid（doc1,doc2），此时使用倒排索引
2. 进行聚合计算docvalues。根据doc1,doc2定位到term2的字段均为brown2，进行聚合累加得到计算结果。browm2的count(1)=2。
```

[es 常用查询手册](http://elasticsearch-cheatsheet.jolicode.com/ )

[面试小结之 Elasticsearch 篇](https://segmentfault.com/p/1210000009823111/read)

[Hbase Elasticsearch](https://segmentfault.com/a/1190000002702747)

[elasticsearch 性能指标](https://blog.csdn.net/pangyemeng/article/details/77524332)

[ElasticSearch聚合](https://www.cnblogs.com/duanxz/p/6528161.html)
[ES之六：ElasticSearch中Filter和Query的异同](https://www.cnblogs.com/duanxz/p/6528168.html)

快照与恢复
```
PUT /_snapshot/my_backup
{
  "type": "fs",
  "settings": {
    "location": "my_backup_location"
  }
}
```
快照与恢复  结合HDFS
插件 repository-hdfs
1.创建快照仓库
```
curl -XPUT 'localhost:9200/_snapshot/backup' -d
{
  "type":"hdfs",
  "settings":{
    "path":"/test/repo",
    "uri":"hdfs://<uri>:<port>"
  }
}
```
2.索引快照
```
curl -XPUT 'http://localhost:9200/_snapshot/backup/snapshot_1' -d
{
  "indices":"index_01,index_02"
}
```
3.备份恢复
```
curl -XPOST "localhost:9200/_snapshot/backup/snapshot_1/_restore"
```
4.备份删除
```
curl -XDELETE "localhost:9200/_snapshot/backup/snapshot_1"
```
5.查看仓库信息
```
curl -XGET 'http://localhost:9200/_snapshot/backup?pretty"
```
