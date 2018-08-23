[Hbase列族数量限制思考](https://blog.csdn.net/r1soft/article/details/63253985)
```
列族数量最优不超过3个
每个 RegionServer 包含多个 Region，每个 Region 包含多个Store，每个 Store 包含一个 MemStore 和多个 StoreFile。

在 Hbase 的表中，每个列族对应 Region 中的一个Store，Region的大小达到阈值时会分裂，因此如果表中有多个列族，则可能出现以下现象：

1）一个Region中有多个Store，如果每个CF的数据量分布不均匀时，比如CF1为100万，CF2为1万，则Region分裂时导致CF2在每个Region中的数据量太少，查询CF2时会横跨多个Region导致效率降低。

2）如果每个CF的数据分布均匀，比如CF1有50万，CF2有50万，CF3有50万，则Region分裂时导致每个CF在Region的数据量偏少，查询某个CF时会导致横跨多个Region的概率增大。

3）多个CF代表有多个Store，也就是说有多个MemStore，也就导致内存的消耗量增大，使用效率下降。

4）Region 中的 缓存刷新 和 压缩 是基本操作，即一个CF出现缓存刷新或压缩操作，其它CF也会同时做一样的操作，当列族太多时就会导致IO频繁的问题。
```
[HBase 列族数据库](https://blog.csdn.net/u013378306/article/details/52442654)
[HBase官方文档](https://www.w3cschool.cn/hbase_doc/)
