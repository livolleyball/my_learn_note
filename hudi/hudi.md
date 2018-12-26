HUDI Basic Introduce 基本概念介绍

[Hudi: Uber Engineering’s Incremental Processing Framework on Apache Hadoop](https://eng.uber.com/hoodie/)
> an incremental processing framework to power all business critical data pipelines at low latency and high efficiency
高效/低延地为所有业务提供关键数据管道支持的增量处理框架，是一种分析的，扫描优化的数据存储抽象，它能够在几分钟内将突变应用于HDFS中的数据，并且可以进行增量处理。

> Hudi数据集通过自定义的InputFormat 与当前的Hadoop生态系统（包括Apache Hive，Apache Parquet，Presto和Apache Spark）集成，使最终用户可以无缝地构建框架。


# 存储
Hudi将数据集组织到基本路径下的分区目录结构中，类似于传统的Hive表。数据集被分解为分区，分区是包含该分区的数据文件的目录。每个分区由其相对于基本路径的分区路径唯一标识。在每个分区中，记录分发到多个数据文件中。每个数据文件都由唯一的fileId和生成该文件的提交动作所标识。在更新的情况下，多个数据文件可以共享在不同提交时写入的相同fileId。

每条记录由记录键唯一标识并映射到fileId。一旦将记录的第一个版本写入文件，记录密钥和fileId之间的映射就是永久的。简而言之，fileId标识一组包含一组记录的所有版本的文件。
* Metadata 元数据
    >Hudi将对数据集执行的所有活动的元数据维护为时间线
   * 提交
   * 清除
   * 压缩

* 索引
    > hudi 维护一个索引，以便在记录的已经存在时，将其映射到索引中。索引实现是可插入的，以下是当前可用的选项：
    * Bloom过滤器存储在每个数据文件页脚中：首选默认选项，因为不依赖于任何外部系统。数据和索引始终彼此一致。
    * Apache HBase：高效查找一小批密钥。在索引标记期间，此选项可能会缩短几秒钟。
* 数据
    > 两种存储格式
    * 扫描优化的柱状存储格式（ROFormat）。默认是Apache Parquet 。
    * 写优化的基于行的存储格式（WOFormat）。默认是Apache Avro 。

    * Read Optimized View on Copy-On-Write
        * Raw Parquet Query Performance
        * Data Ingestion could be slow
    > Hudi 1.0依赖于一种名为copy-on-write的技术，只要有更新的记录，它就会重写整个源Parquet文件。这显着增加了写入放大，特别是当更新与插入的比率增加时，并且阻止在HDF中创建更大的Parquet文件。
    * Read Optimized View on Merge-On-Read
        * Raw Parquet Query Performance
        * Stale Data 
    * Real Time View on Merge-On-Read
        * Great Data Ingestion performance
        * Merge Cost during Read
    * Compaction
        * Build Read Optimized (Columnar) files from realtime views 




| *存储类型* | *视图* | 
| ------ | ------ | 
| copy-on-write | 读优化视图，日志视图 | 
| Merge On Read | 读优化视图，实时视图，日志视图 |

## 存储类型
### copy-on-write
* 单纯的列式存储
* 简单地生成新版本的文件

### Merge On Read
* 近实时
* shifts some write cost to reads 
* Merges on-the-fly

## 视图 ： 数据如何读取
### Read Optimized View 读优化视图
* Parquet 查询
* 30分钟延时 

### real time View 实时视图
* 行列混合数据 （Parquet + Avro）
* 1～5分钟延时
* 近实时表

### log View 日志视图
* 数据变化流
* 可以增量拉取


### 模型
Incremental data modeling 增量数据建模
* Latest mode view  最新模式视图
* Incremental mode view  增量模式视图
![Latest mode VS Incremental mode ](/hudi/Latest_mode_VS_Incremental_mode.png)

Standardized data model  标准化数据模型
* Changelog history table  更改日志历史记录表 
    * 应对缓慢变化维度， 保留数据每一次最细粒度的变更
* Merged snapshot table  合并快照表
    * 快照表

![change_log VS Snapshot](/hudi/change_log_tb.png)


# 优化
>Hudi存储针对HDFS使用模式进行了优化。压缩是将数据从写优化格式转换为扫描优化格式的关键操作。

> Compaction is the critical operation to convert data from a write-optimized format to a scan-optimized format.
压缩是将数据从写优化格式转换为扫描优化格式的关键操作。

> Since the fundamental unit of parallelism for a compaction is rewriting a single fileId, Hudi ensures all data files are written out as HDFS block-sized files to balance compaction parallelism, query scan parallelism, and the total number of files in HDFS. Compaction is also pluggable, which can be extended to stitch older, less frequently updated data files to further reduce the total number of files.

> 由于压缩的基本并行单元是重写单个fileId，因此Hudi确保将所有数据文件写出为HDFS块大小的文件，以平衡压缩并行性，查询扫描并行性和HDFS中的文件总数。压缩也是可插入的，可以扩展为缝合较旧的，不太频繁更新的数据文件，以进一步减少文件总数。

# 摄取路径
Hudi是一个Spark库，旨在作为流接收作业运行，并将数据作为小批量提取（通常大约一到两分钟）。但是，根据延迟要求和资源协商时间，摄取作业也可以使用Apache Oozie或Apache Airflow作为计划任务运行。
