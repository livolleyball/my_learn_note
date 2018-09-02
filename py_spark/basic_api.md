# 新建会话
```
from pyspark import SparkContext
import  math

sc = SparkContext(master='local[1]')
print(sc.version)
print(sc.pythonVer)
str(sc.sparkHome)
str(sc.sparkUser())
sc.appName
```
# loading data 载入数据
```
rdd = sc.parallelize([('a', 7), ('a', 2), ('b', 2)])
rdd2 = sc.parallelize([('a', 2), ('d', 2), ('b', 2)])
rdd3 = sc.parallelize(range(100))
rdd4 = sc.parallelize([("a", ["x", "y", "z"]), ("b", ["p", "r"]),("a", ["x1", "y1", "z"])])
list1 = [1, 2, 3, 4, 1, 2, 3, 5, 6, 6, 7, 1, 7, 8, 9]
list2 = ['physics', 'chemistry', 1997, 2000]
list3 = ["a", "b", "c", "d"]
rdd5 = sc.parallelize(list1)
rdd6 = sc.parallelize(list2)
rdd7=sc.parallelize(range(5))
```

# baseic Information  基本信息
```
rdd.getNumPartitions()  # RDD 实例的分区数
rdd.count()  # RDD 实例的数量
rdd.countByKey()  # 按 RDD 的key 计数
rdd5.countByValue()  # 按 RDD value 计数 针对list,并且内部最好是 int/string
rdd6.countByValue()
rdd.collectAsMap()  # 返回一个（k,v）字典
rdd3.sum()  # RDD元素求和
rdd3.glom().collect()  #查看分区状况
```

# summary 总结
```
rdd3.count()
rdd3.max()
rdd3.min()
rdd3.mean()
rdd3.stdev()
rdd3.variance()
rdd3.histogram(3)
rdd3.stats()
```

# applying Function  函数
```
rdd.map(lambda x: x + (x[1] * 3, x[0])).collect()  # 将func 作用于每个元素
rdd3.map(lambda x:x*x).collect()

rdd5 = rdd.flatMap(lambda x: x + (x[1] * 3, x[0])).collect()  # 将func 作用于每个元素,并将结果平铺开

rdd4.flatMapValues(lambda x: x).collect()  # 将RDD4 的每一个（k,v）平铺开,并不改变keys
```
# select date 选择数据
## get
```
rdd.collect()  # 返回包含RDD元素的列表
rdd.take(2)  # 返回RDD 前两个元素的列表
rdd.first()  # 返回Rdd的第一个元素，数据类型和 元素本身有关
rdd.top(2)
```

## sampling
```
rdd3.sample(False, 0.15, 50).collect()  # 随机取样，seed=50
len(rdd3.sample(False, 0.15, 50).collect())
```

## filtering 过滤
```
rdd.filter(lambda x: "a" in x).collect()  # 过滤
rdd5.distinct().collect()  # 返回唯一值
rdd.keys().collect()  # 返回(k,v) RDD 的keys
```

# iterating 迭代
```
def g(x): print(x)     # 定义一个函数
def g1(x): print((x[1]+1000,x[0]))

rdd.foreach(g)         # 应用函数 与RDD 的每一个元素
rdd.foreach(g1)
```
# 重置数据
## reducing 规约
```
rdd.reduceByKey(lambda x,y:x+y).collect()   # 合并RDD元素中对应的值 ,针对每一个key , 将x+y 应用到对应的value 上
## [('a', 14), ('b', 2)]

rdd4.reduceByKey(lambda x,y:x+y).collect()  # 对于 value 是列表的key, reduce 的时候不会去重

rdd.reduce(lambda a,b:a+b)   # 合并RDD 的key, value
rdd4.reduce(lambda x,y:x+y)  # ('a', 7, 'a', 7, 'b', 2)
rdd3.reduce(lambda x,y:x+y)  # 将 数值 RDD 求和
rdd7.reduce(lambda x,y:x*10+y )
rdd7.reduce(lambda x,y:x+y)
rdd7.filter(lambda x:x!=0).reduce(lambda x,y:x*y)
```
## grouping by   分组
```
rdd3.groupBy(lambda x:x%2).mapValues(list).collect()

rdd = sc.parallelize([('a', 7), ('a', 7), ('b', 2)])
rdd.groupByKey().mapValues(set).collect()       #  [('a', {7}), ('b', {2})]
rdd.groupByKey().mapValues(tuple).collect()     #  [('a', (7, 7)), ('b', (2,))]  多了一个逗号?
rdd.groupByKey().mapValues(list).collect()      #  [('a', [7, 7]), ('b', [2])]
rdd.groupByKey().mapValues(bytearray).collect() # [('a', bytearray(b'\x07\x07')), ('b', bytearray(b'\x02'))]
```
## aggregating   聚合
```
seqOp =(lambda x,y:(x[0]+y,x[1]+1))
combOp=(lambda x,y:(x[0]+y[0],x[1]+y[1]))


rdd3.aggregate((0,0),seqOp,combOp)   # (4950, 100)
rdd3.sum()
rdd3.count()

rdd.aggregateByKey((0,0),seqOp,combOp).collect()  # [('a', (14, 2)), ('b', (2, 1))]
rdd3.fold(0,lambda x,y:x+y)    # 4950
rdd.foldByKey(0,lambda x,y:x+y).collect()   # [('a', 14), ('b', 2)]
rdd7.keyBy(lambda x:x+x).collect()
# [(0, 0), (2, 1), (4, 2), (6, 3), (8, 4)]  对RDD 的每一个元素应用函数,并返回 与元素对应的tuple
rdd.keyBy(lambda x:x).collect()  # [(('a', 7), ('a', 7)), (('a', 7), ('a', 7)), (('b', 2), ('b', 2))]
```
# 数学运算
```
rdd.subtract(rdd2).collect()   # 返回排除 rrd2 后元素  [('a', 7)]
rdd2.subtract(rdd).collect()   # 返回 RRD 中不存在的 key
```
# 排序
```
rdd2.sortBy(lambda x:x[1],ascending=True).collect()  # 按指定的函数排序
rdd7.sortBy(lambda x:x,ascending=False).collect()
rdd.sortByKey().collect()    #  按RDD 的 key 排序

rdd = sc.parallelize([1, 2, 3, 4], 2)
sorted(rdd.glom().collect())  # 该函数是将RDD中每一个分区中类型为T的元素转换成Array[T]，这样每一个分区就只有一个数组元素


pairs = sc.parallelize([1, 2, 3, 4, 2, 4, 1]).map(lambda x: (x, x))  # [(1, 1), (2, 2), (3, 3), (4, 4), (2, 2), (4, 4), (1, 1)]
sets = pairs.partitionBy(2).glom().collect()
len(set(sets[0]).intersection(set(sets[1])))

rdd9=sc.parallelize(range(0, 6, 2), 5).glom().collect()  # [[], [0], [], [2], [4]]
rdd10=sc.parallelize([0, 2, 3, 4, 6], 5).glom().collect() # [[0], [2], [3], [4], [6]]

## 计算质数
import math
n=300000
rdd8 = sc.parallelize(range(2,n), 8)
rdd8.filter(lambda x: not [x % i for i in range(2, int(math.sqrt(x)) + 1) if x % i == 0 ]).collect()
```

# 重新分区 repartitions
```
rdd.getNumPartitions()
rdd.repartition(4)  # 重新分成4个分区
rdd.coalesce(1)     # 将分区数减为1
```


# 保存
```
rdd.saveAsTextFile('dir')
rdd.saveAsHadoopFile("hdfs://namenodehost/parent/child",
                         'org.apache.hadoop.mapred.TextOutputFormat')
```

# 停止会话
```
sc.stop()
```
