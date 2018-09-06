3.1.0
``` scala
声明 array 的方式不推荐

var greetStrings = new Array[String](3)

greetStrings(0) = "Hello"
greetStrings(1) = ", "
greetStrings(2) = "world!\n"

for (i <- 0 to 2)
  print(greetStrings(i))
```

3.1.1
``` scala
var greetStrings: Array[String] = new Array[String](3)

greetStrings(0) = "Hello"
greetStrings(1) = ", "
greetStrings(2) = "world!"

for (i <- 0 to 2)
  print(greetStrings(i))
```

3.1.2
``` scala
var greetStrings: Array[String] = new Array[String](3)

greetStrings.update(0,"hello")
greetStrings.update(1," , ")
greetStrings.update(2,"world!\n")

for (i <- 0 to 2 )
  print(greetStrings.apply(i))
```
3.2 create and initialize ab array
```scala
val numNames2 = Array.apply("zero","one","two")
val numNames =  Array("zero","one","two")
```
3.3 lists
``` scala
val onTwoThree = List(1,2,3)
val threeFourFive = List(3,4,5)
val a = onTwoThree ::: threeFourFive
```

###  Scala list 常用的方法
``` scala
List() or Nil  // 空列表
List("a","b","c")  //
val thrill = "a":: "b"::"c":: Nil
List("a","b") ::: List("c","b")
thrill(2)
thrill.count(s=>s.length == 4)  
thrill.drop(2)  

thrill.dropRight(2)  // 丢弃前i个元素

thrill.exists(s => s == "a")   //  判断 thrill 是否含有元素 a
thrill.filter(s => s.length ==4)  // 元素长度等于4 的元素

val a = "1a" :: "2a" :: "3a" :: Nil
a.forall(s =>s.endsWith("a"))   // 每一个元素是否以 "a" 结尾

thrill.foreach(s => print(s))

thrill.foreach(print)

thrill.head   // 第一个元素

val b = a ::: thrill
b.init  // 返回前 n-1 个元素

thrill.isEmpty  
b.last  
thrill.length

thrill.map(s => s + "y")  //  List[String] = List(ay, by, cy)

thrill.mkString(", ")  // String = a, b, c
b.filterNot(s =>s.length == 4)  

thrill.reverse
thrill.sorted
thrill.sorted.reverse
b.sortBy(s => s.charAt(0).toLower).reverse
thrill.sort((s, t) => s.charAt(0).toLower < t.charAt(0).toLower)
b.sortWith(_<_)  // 升序
b.sortWith(_>_)  // 降序
thrill.tail    // 后n-1 个元素
numbers.drop(5)   // 丢弃前i个元素

numbers.dropWhile(_ % 2 != 0)  //从左向右丢弃元素，直到条件p不成立

numbers.exists(_ % 2 != 0)  //返回一个布尔值，指明迭代器元素中是否存在满足p的元素。

numbers.filter(_ % 2 != 0).filter(_ %3 != 0)  // 返回一个新迭代器 ，指向迭代器元素中所有满足条件p的元素。
```
