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
