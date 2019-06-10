
#!/bin/bash

# for(( i=0;i<${#array[@]};i++)) do echo ${array[i]}; done;
function showArr(){
 
    array=$1
 
    for(( i=0;i<${#array[@]};i++)) ; do
        echo aa+${array[i]}
        echo date_${i}
        # export date_${i}=${array[i]}
        
    done;
 
}
 
regions=(-1 3 5)
 
showArr "${regions[*]}"
 



