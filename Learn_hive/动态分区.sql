分区种类
分区分为两种： 
静态分区static partition 
动态分区dynamic partition 
静态分区和动态分区的区别在于导入数据时，是手动输入分区名称，还是通过数据来判断数据分区。对于大数据批量导入来说，显然采用动态分区更为简单方便。

动态分区配置方法
修改一下hive的默认设置以支持动态分区：

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

其他参数
hive.exec.dynamic.partition 
默认值：false 
是否开启动态分区功能，默认false关闭。 
使用动态分区时候，该参数必须设置成true;

hive.exec.dynamic.partition.mode 
默认值：strict 
动态分区的模式，默认strict，表示必须指定至少一个分区为静态分区，nonstrict模式表示允许所有的分区字段都可以使用动态分区。 
一般需要设置为nonstrict

hive.exec.max.dynamic.partitions.pernode 
默认值：100 
在每个执行MR的节点上，最大可以创建多少个动态分区。 
该参数需要根据实际的数据来设定。 
比如：源数据中包含了一年的数据，即day字段有365个值，那么该参数就需要设置成大于365，如果使用默认值100，则会报错。

hive.exec.max.dynamic.partitions 
默认值：1000 
在所有执行MR的节点上，最大一共可以创建多少个动态分区。 
同上参数解释。

hive.exec.max.created.files 
默认值：100000 
整个MR Job中，最大可以创建多少个HDFS文件。 
一般默认值足够了，除非你的数据量非常大，需要创建的文件数大于100000，可根据实际情况加以调整。

hive.error.on.empty.partition 
默认值：false 
当有空分区生成时，是否抛出异常。 
一般不需要设置。
