for i in $(seq 1 100)
do
    export var_$i=$i
done



array=(A B "C" D)

for i in ${array[@]};do echo $i ;done

array=(A B C D)

for (( i=0;i<${#array[@]};i++))
do 
    a=${array[i]}
    export ttt_$i=$a
    result=`eval echo '$'"ttt_$i"`
    echo '000'
    echo $result
done


for (( i=1;i<5;i++));do
    let test$i=1000
    echo test$i=$[test$i]
done



result1="r1"
result2="r2"
result3="r3"
 
for i in {1..3}
do
    result=`eval echo '$'"result$i"`
    echo $result
done
