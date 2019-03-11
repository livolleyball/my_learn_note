https://www.jianshu.com/p/d3e963ff8b70


### 目录
1.Kafka简介 
2.生产端-kafkaProducer  向broker发布消息的客户端应用程序
3.消费端-kafkaConsumer  从消息队列中请求消息的客户端应用程序
4.服务端-KafKaServer 用来接收生产者发送的消息并将这些消息路由给服务器中的队列
5.kafkaController 
6.kafkaTool

producer <-push-> Topic <-pull-> consumer

### kafka 
低延迟
高吞吐
持久化
扩展与容灾
顺序保证
缓冲&峰值处理能力
异步通信


### 概念
* Broker
* Topic
* Patition  一个topic中的消息数据按照多个分区组织，分区是kafka消息队列组织的最小单位，一个分区可以看做是一个FIFO的队列;
* 备份（Replication）：为了保证分布式可靠性,kafka0.8开始对每个分区的数据进行备份（不同Broker上），防止其中一个Broker宕机造成分区数据不可用
* isr
* hw&leo
* Controller
* zookeeper 一个提供分布式状态管理、分布式配置管理、分布式锁服务等的集群


#### 启动kafka集群命令:
```bash
kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
```

#### Producer config
最小配置:
bootstrap.servers 
key.serializer 
value.serializer 
client.id
数据安全:
acks
retries 
retry.backoff.ms
耗时: 
batch.size 
linger.ms
压缩:
compression.type (gzip, snappy, or lz4)
其它
timeout.ms
max.in.flight.requests.per.connection 
metadata.fetch.timeout.ms 
connections.max.idle.ms 
buffer.memory

acks:0 1 all 
unclean.leader.election.enable: true\false


#### consumer
* 不是线程安全的
* 线程封闭
* concurrentModificationException

#### 语义
At most once
At least once
Exactly once