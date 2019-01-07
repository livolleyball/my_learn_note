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