##  配置
### HIVE_DEFAULT_PARTITION
```
在hive里面表可以创建成分区表，但是当分区字段的值是'' 或者 null时 hive会自动将分区命名为默认分区名称。

默认情况下，默认分区的名称为__HIVE_DEFAULT_PARTITION__

当然默认分区名称是可配置的

配置参数是 hive.exec.default.partition.name

set  hive.exec.default.partition.name;

-- sql：分区字段day出现了null值
select  date(create_time),count(1)
from mytb
where day is null
group by date(create_time)
```
