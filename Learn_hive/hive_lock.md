### Unable to acquire IMPLICIT, EXCLUSIVE lock
```
shared  共享索;
开启并发功能后，锁 就会自动被启动。
表被读取时，需要使用共享索。多重并发共享索也是允许使用的。

EXCLUSIVE  排它锁
An exclusive lock is required for all other operations that modify the table in some way.
They not only freeze out other table-mutating operations, they also prevent queries by
other processes.
更改表的时候出现排它锁,
1 冻结表本身的其他变更操作;
2 阻止其他进程的查询操作;

当表是分区表时，对一个分区获取排他索时会导致需要对表本身获取共享索来防止发生不相容的变更。
对表的排它锁会作用全局，影响所有分区


查看是否被锁：

show locks
show locks TABLE_NAME;

列出相关查看锁表语句：

SHOW LOCKS <TABLE_NAME>;
SHOW LOCKS <TABLE_NAME> extended;
SHOW LOCKS <TABLE_NAME> PARTITION (<PARTITION_DESC>);
SHOW LOCKS <TABLE_NAME> PARTITION (<PARTITION_DESC>) extended
解决办法：

关闭锁（并发）机制：
set hive.support.concurrency=false; 默认为true
```

### 显式索和排他索
``` sql
 LOCK TABLE TABLE_NAME EXCLUSIVE;

 UNLOCK TABLE TABLE_NAME;
```

```sql
lock table oyo_tmp.dw_lihm_01 exclusive; -- 排他锁  不可查询 DQL ( select )
select * from  oyo_tmp.dw_lihm_01;
show locks oyo_tmp.dw_lihm_01;




lock table  oyo_tmp.lihm_01  SHARED ; --共享锁 不可插入 DML （insert delete ）  ddl (create drop )
show locks  oyo_tmp.lihm_01;
select * from oyo_tmp.lihm_01;
insert into oyo_tmp.lihm_01 select 2 ;

set hive.support.concurrency =false;  -- 锁失效
drop table oyo_tmp.lihm_01
```