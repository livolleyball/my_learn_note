00 max()
```scala
function name
parameter
function'result type

def max(x: Int,y: Int) : Int= {
  if (x>y) x else y
  }
```

01
``` scala
def greet() = {
  println("Hello world")
}
```

02
``` scala
def echoargs (args: String) = {
  var i=0
  while(i < args.length){
    if (i !=0)
      print(" ")
    print(args(i))
    i +=1
  }

}
```

03
``` scala
def printargs (args: String)= {
  var i=0
  while(i < args.length){
    print(args(i))
    i +=1
  }
}
```


04
``` scala
def pa(args: String) = {
  args.foreach(arg => println(arg))
}
```
