[HBase 常用Shell命令](http://www.cnblogs.com/nexiyi/p/hbase_shell.html)


```
hadoop fs -ls /data/hbase -- CDH hbase目录

get 'van_gogh_driver_daily','99941296609363469',{COLUMN=>['off:sign_shipper_daily_continuity_sign_cnt','off:tasks_activity_daily_task_id_set']}
scan 'van_gogh_driver_daily', FILTER=>"ColumnPrefixFilter('active_shipper_daily') AND ValueFilter(=,'substring:2017')"
get 'van_gogh_shipper_daily','703425406754806006', {COLUMN=>['off:tasks_activity_daily_task_id_set','off:profile_shipper_daily_register_date']}
get 'van_gogh_driver_daily','99941296609363469'
count 'van_gogh_driver_daily'
```
### 表管理
``` sql
list   -- 查看有哪些表

-- 语法：create <table>, {NAME => <family>, VERSIONS => <VERSIONS>}
-- 例如：创建表t1，有两个family name：f1，f2，且版本数均为2
create 't1',{NAME => 'f1', VERSIONS => 2},{NAME => 'f2', VERSIONS => 2}

```
