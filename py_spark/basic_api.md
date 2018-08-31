# 创建会话
```
from pyspark import SparkContext
sc = SparkContext(master ='local[1]')
print(sc.version)
print(sc.pythonVer)
str(sc.sparkHome)
str(sc.sparkUser())
sc.appName
```

# loading data 载入数据
```
rdd= sc.parallelize([('a',7),('a',2),('b',2)])
rdd2= sc.parallelize([('a',2),('d',2),('b',2)])
rdd3=sc.parallelize(range(100))
rdd4=sc.parallelize([("a",["x","y","z"]),("b",["p","r"])])
list1=[1,2,3,4,1,2,3,5,6,6,7,1,7,8,9]
list2 = ['physics', 'chemistry', 1997, 2000]
list3 = ["a", "b", "c", "d"]
rdd5=sc.parallelize(list1)
rdd6=sc.parallelize(list2)
```


# baseic Information  基本信息
```
rdd.getNumPartitions()   # RDD 实例的分区数
rdd.count()              # RDD 实例的数量
rdd.countByKey()         # 按 RDD 的key 计数
rdd5.countByValue()       # 按 RDD value 计数 针对list,并且内部最好是 int/string
rdd6.countByValue()
rdd.collectAsMap()        # 返回一个（k,v）字典
rdd3.sum()                 # RDD元素求和
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
rdd.map(lambda x:x+(x[1]*3,x[0])).collect()     # 将func 作用于每个元素

rdd5 = rdd.flatMap(lambda x:x+(x[1]*3,x[0])).collect()  #  将func 作用于每个元素,并将结果平铺开

rdd4.flatMapValues(lambda x:x).collect()         # 将RDD4 的每一个（k,v）平铺开,并不改变keys
```

# select date 选择数据
## get
```
rdd.collect()     # 返回包含RDD元素的列表
rdd.take(2)       # 返回RDD 前两个元素的列表
rdd.first()       # 返回Rdd的第一个元素，数据类型和 元素本身有关
rdd.top(2)
```
## sampling
```
rdd3.sample(False,0.15,50).collect()   # 随机取样，seed=50
len(rdd3.sample(False,0.15,50).collect())
```

## filtering 过滤
```
rdd.filter(lambda x: "a" in x).collect()  # 过滤
rdd5.distinct().collect()  # 返回唯一值
```
rdd.keys().collect()       # 返回(k,v) RDD 的keys
