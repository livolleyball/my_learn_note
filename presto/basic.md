### 名词解释
Coordinator:
Presto主角色，单一节点，负责接受客户端请求，SQL语句解析，生成执行计划，管理worker节点；

Worker:
presto实际处理处理运行任务的节点，从数据源获取数据，处理并互相数据，被coordinator调度，
将结果返回给coordinator，启动后通过心跳和coordinator中的discovery server保持连接。

Connector:
SPI接口的实现，（SPI为适配所有数据源的统一接口规范），以有多种connector的实现，
包括hive,mysql,redis,kudu,kafka,monodb等等

Catalog:
数据源配置，每个一个数据源配置一个catalog，通过connector连接catalog;

Schema:
一系列表的组合，等同于database的概念；

Table:
等同于表的概念，因此presto访问一个表的全限定为   select * from catalog.schema.tablename;


### 名词概念
Statement:
客户端提交的ANSI SQL语句，单纯只文本内容；

Query:
query为解析sql之后的执行计划，包含stage,tasks,splits,connectors等执行sql必要的组件的组合；

Stage:
Presto将执行计划逻辑上拆分为多个层次的stage,呈现树状结构，包含single stage(顶层聚合，返回结果给coordinator)，fixed stages (中间计算) ，
source stages（数据scan，读取数据源)，stage拆分成多个task并行执行；

Task:
并行运行在worker上的任务，包含输入输出，每个stage拆分为多个task，可以并行执行;

Split:
Task运行依赖的数据分片，每个task处理一个或多个split;

Driver:
split上一系列操作的集合，一个driver处理一个split，拥有输入输出，

Operator:
对split的一个操作，比如过滤，加权，转换等等；

Exchange:
完成tasks之间的数据交换；



### Presto优点
presto 不和 CDH绑定
支持多数据源，无需执行refresh 或者 invalidate metadata 来刷新元数据
完全java开发，后期方便维护和二次开发
目前主流互联网公司均使用presto做为大数据实时分析和即席查询引擎


### Presto缺点
Coordinator存在单点故障
