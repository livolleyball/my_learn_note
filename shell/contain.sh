strA="12,09,11,14,17"
strB=${zdt.format("HH")}
echo ------- $strB ----------
result=$(echo $strA | grep "${strB}") 
if [[ $result != "" ]] 
then  
  echo "包含"
else  
  echo "不包含"
fi 

## 字符串运算符
strA="helloworld"
strB="low"
if [[ $strA =~ $strB ]] 
then  
  echo "包含"
else  
  echo "不包含"
fi 

## 通配符
A="helloworld"
B="low"
if [[ $A = *$B* ]] 
then  
  echo "包含"
else  
  echo "不包含"
fi 