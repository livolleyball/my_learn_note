
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
```
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.disk.watermark.low": "80%",
    "cluster.routing.allocation.disk.watermark.high": "50gb",
    "cluster.info.update.interval": "1m"
  }
}


Elasticsearch使用两个配置参数决定分片是否能存放到某个节点上。
cluster.routing.allocation.disk.watermark.low：控制磁盘使用的低水位。默认为85%，意味着如果节点磁盘使用超过85%，则ES不允许在分配新的分片。当配置具体的大小如80MB时，表示如果磁盘空间小于80MB不允许分配分片。
cluster.routing.allocation.disk.watermark.high：控制磁盘使用的高水位。默认为90%，意味着如果磁盘空间使用高于90%时，ES将尝试分配分片到其他节点。
上述两个配置可以使用API动态更新，ES每隔30s获取一次磁盘的使用信息，该值可以通过cluster.info.update.interval来设置。

```
https://blog.csdn.net/laoyang360/article/details/78080602/
提示1：小分片会导致小分段(segment)，从而增加开销。目的是保持平均分片大小在几GB和几十GB之间。对于具有基于时间的数据的用例，通常看到大小在20GB和40GB之间的分片。

提示2：由于每个分片的开销取决于分段数和大小，通过强制操作迫使较小的段合并成较大的段可以减少开销并提高查询性能。一旦没有更多的数据被写入索引，这应该是理想的。请注意，这是一个消耗资源的（昂贵的）操作，较为理想的处理时段应该在非高峰时段执行。

提示3：您可以在集群节点上保存的分片数量与您可用的堆内存大小成正比，但这在Elasticsearch中没有的固定限制。 一个很好的经验法则是：确保每个节点的分片数量保持在低于每1GB堆内存对应集群的分片在20-25之间。 因此，具有30GB堆内存的节点最多可以有600-750个分片，但是进一步低于此限制，您可以保持更好。 这通常会帮助群体保持处于健康状态。
