[](http://www.importnew.com/3673.html)

## list
``` scala
val numbers = List(1, 2, 3, 4)
```
## set 集合中没有重复数据
``` scala
Set(1,2,1)
res0: scala.collection.immutable.Set[Int] = Set(1, 2)
```

## 元组（tuple）
``` scala
val hostPort = ("localhost", 80)
hostPort: (String, Int) = (localhost,80)

// 通过基于它们位置的名称进行访问
hostPort._1
res0: String = localhost

hostPort._2
res0: Int = 80

// 创建一个元组
 1 ->2
 res1: (Int, Int) = (1,2)
```

## map  可以存放基本的数据类型, key value
``` scala
Map(1 -> 2)
Map("foo" -> "bar")
Map(1 -> "one",2 -> "two")
Map(1 -> Map("foo" -> "bar"))    // map value 为 map
Map("timesTwo" -> { timesTwo(_) })  // map valuue 为 func
```

## option  是一个包含或者不包含某些事物的容器,Option本身是泛型的，它有两个子类：Some[T]和None
``` scala
val capitals = Map("china" -> "BJ","france" -> "Paris","Japan" -> "Tokyo")

capitals get "china"  // 不友好
capitals.get("china")

// 使用 模式匹配 获取 option 的值
def show(x:Option[String]) = x match {
  case Some(s) => s
  case None => "?"
}

show(capitals.get("china"))
```

## 函数组合器
### map
``` scala
val numbers = List(1, 2, 3, 4)
numbers.map((i :Int) => i * 2 )

def timesTwo(i :Int) : Int = i*2
numbers.map(timesTwo _)
```
### foreach
``` scala
numbers.foreach((i :Int) => i *2 )   // 没有返回值
```
### filter  移除任何使得传入的函数返回false的元素。返回Boolean类型的函数一般都称为断言函数。
``` scala
numbers.filter((i : Int) => i %2 ==0)

def isEven(i : Int): Boolean = i%2 == 0
numbers.filter(isEven _)
```
### zip zip把两个列表的元素合成一个由元素对组成的列表里
``` scala
List(1, 2, 3).zip(List("a", "b", "c"))
res12: List[(Int, String)] = List((1,a), (2,b), (3,c))
```

### partition 根据断言函数的返回值对列表进行拆分
``` scala
val numbers = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
numbers.partition(_ %2 == 0)
```

### find 返回集合里第一个匹配断言函数的元素
``` scala
numbers.find((i: Int) => i > 5)
res14: Option[Int] = Some(6)

def show_int(x:Option[ Int ]) = x match {
  case Some(s) => s
  case None => 0
}

show_int(numbers.find((i: Int) => i > 5))
```
## 匿名函数
``` scala
// 创建匿名函数
(x :  Int) => x+1   
res77: Int => Int = $$Lambda$1119/72440978@467c1aa9
res77(2)   // 返回 3

// 可以传递匿名函数，或将其保存成不变量
val addOne =(x : Int) => x+1
addOne(1)

// 如果函数有很多表达式，可以使用{}来格式化代码
def timesTwo(i: Int): Int = {
  println("hello world")
  i * 2
}

//匿名函数作为参数进行传递时，可以这么写
{ i: Int =>
  println("hello world")
  i * 2
}
```

## partial 部分应用函数
### 指一个函数有n个参数, 而我们为其提供少于n个参数, 那就得到了一个部分应用函数。偏应用函数类似于柯里化。
``` Scala
def adder(m: Int, n: Int) = m + n

val add2 = adder(2, _:Int)

add2(3)  // 返回 5
```

## 柯里化函数
``` Scala
