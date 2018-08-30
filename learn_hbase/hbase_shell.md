[HBase 常用Shell命令](http://www.cnblogs.com/nexiyi/p/hbase_shell.html)

### 表查询
```
hadoop fs -ls /data/hbase -- CDH hbase目录

scan  'mytb',{LIMIT=>5}   -- 随机5行

scan 'mytb', FILTER=>"ColumnPrefixFilter('active_shipper_daily') AND ValueFilter(=,'substring:2017')"

scan  'mytb',{LIMIT => 150,COLUMN=>['cf1:c1','cf2:c1']}  -- 指定 列族、列，随机150

get 'mytb','99941296609363469',{COLUMN=>['off:c1','off:c2']}  -- 指定 row_key / 列族 / 列

get 'mytb','703425406754806006', {COLUMN=>['off:c2','off:profile_shipper_daily_register_date']}

get 'mytb','99941296609363469'

count 'mytb'
```
### 表管理
[易百Hbase](https://www.yiibai.com/hbase/hbase_describe_and_alter.html)
``` sql
list   -- 查看有哪些表

-- 语法：create <table>, {NAME => <family>, VERSIONS => <VERSIONS>}
-- 例如：创建表t1，有两个family name：f1，f2，且版本数均为2
create 't1',{NAME => 'f1', VERSIONS => 2},{NAME => 'f2', VERSIONS => 2}

--  更改版本数为5
alter 't1', NAME => 'f1', VERSIONS => 5

--
alter  't1',{NAME=>'f1', ATTRIBUTE=>'f11' }

-- 添加列族
alter 't1', 'f1', {NAME => 'f2', IN_MEMORY => true}, {NAME => 'f3', VERSIONS => 5}

-- 删除 列族 f1_new
alter 't1', NAME => 'f1_new', METHOD => 'delete'
alter 't1', 'delete'=>'f1_new'
```
``` shell
-- 更改表名
hbase shell:
# 停止表继续插入
disable 'tableName'
# 制作快照
snapshot 'tableName', 'tableSnapshot'
# 克隆快照为新的名字
clone_snapshot 'tableSnapshot', 'newTableName'
# 删除快照
delete_snapshot 'tableSnapshot'
# 删除原来表
drop 'tableName'


```

``` java
# 更改表名
void rename(HBaseAdmin admin, String oldTableName, String newTableName) {
 String snapshotName = randomName();
 admin.disableTable(oldTableName);
 admin.snapshot(snapshotName, oldTableName);
 admin.cloneSnapshot(snapshotName, newTableName);
 admin.deleteSnapshot(snapshotName);
 admin.deleteTable(oldTableName);
}
```
