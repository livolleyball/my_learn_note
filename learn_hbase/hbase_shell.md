[HBase 常用Shell命令](http://www.cnblogs.com/nexiyi/p/hbase_shell.html)

### 表查询
```sql
hadoop fs -ls /data/hbase -- CDH hbase目录

scan  'mytb',{LIMIT=>5}   -- 随机5行

scan 'mytb', FILTER=>"ColumnPrefixFilter('active_shipper_daily') AND ValueFilter(=,'substring:2017')"

scan  'mytb',{LIMIT => 150,COLUMN=>['cf1:c1','cf2:c1']}  -- 指定 列族、列，随机150

get 'mytb','99941296609363469',{COLUMN=>['off:c1','off:c2']}  -- 指定 row_key / 列族 / 列

get 'mytb','703425406754806006', {COLUMN=>['off:c2','off:profile_shipper_daily_register_date']}

get 'mytb','99941296609363469'

count 'mytb'


hbase
put't1','row1','f1:a','1'
put't1','row2','f1:b','2'
put't1','row3','f2:c','3'
put't1','row4','f2:d','4'

put't1','row1','f1:b','1'
put't1','row2','f1:a','2'
put't1','row1','f2:c','3'
put't1','row2','f2:c','4'


1.RowFilter ：基于行键来过滤数据；
	RowFilter
	根据rowkey的值过滤
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"RowFilter(>=,'binary:row2')"}

2.FamilyFilter ：基于列族（名）来过滤数据；
	FamilyFilter
	根据列族过滤
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"FamilyFilter(=,'substring:f1')"}

3.QualifierFilter ：基于列名来过滤数据；
	QualifierFilter
	根据列名过滤
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"QualifierFilter(=,'regexstring:a.')"}--.通配符

4.ValueFilter ：基于值来过滤数据；
	ValueFilter
	根据值过滤，只返回匹配的列
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"ValueFilter(=,'binary:2')"}

5.DependentColumnFilter ：返回（与（符合条件[列名，值]的参考列）具有相同的时间戳）的所有列，即 ：基于比较器过滤参考列，基于参考列的时间戳过滤其他列；

6.SingleColumnValueFilter ：基于参考列的值来过滤数据；
	SingleColumnValueFilter
	根据列值返回行
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',COLUMN=>'f1',FILTER=>"SingleColumnValueFilter('f1','a',>=,'binary:2')"}--f1:a>=3

7.SingleColumnValueExcludeFilter ：在SingleColumnValueFilter的基础上，不返回参考列；
8.PrefixFilter ：基于行键前缀来过滤数据；
9.PageFilter ：对结果按行分页；
	PageFilter
	返回多少行
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"PageFilter(1)"}
10.KeyOnlyFilter ：只返回行键；
11.FirstKeyOnlyFilter ：只返回每一行中最早创建的列；
12.InclusiveStopFilter ：将stoprow也一起返回；
	InclusiveStopFilter
	设置停止的行
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"InclusiveStopFilter('row2')"}

13.TimestampsFilter  ：基于时间戳来过滤数据；
	TimeStampsFilter
	返回指定时间戳的数据
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"TimestampsFilter(1539094113165,1539094113165)"}

14.ColumnCountGetFilter ：限制每行返回多少列；
	ColumnCountGetFilter
	返回多少列
	scan't1',{STARTROW=>'row0',STOPROW=>'row3',FILTER=>"ColumnCountGetFilter(5)"}--第一个列族取完后，会依次去取第二个列族
	scan't1',{STARTROW=>'row0',STOPROW=>'row3',FILTER=>"ColumnCountGetFilter('f1:a','f2:c')"}--不允许指定列名

15.ColumnPaginationFilter ：对一行的所有列分页，只返回[offset,offset+limit]范围内的列；
	ColumnPaginationFilter
	根据limit和offset得到数据
	scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"ColumnPaginationFilter(2,1)"}

16.ColumnPrefixFilter ：基于列名前缀来过滤数据；
	scan 't1', FILTER=>"ColumnPrefixFilter('a') AND ValueFilter(>=,'binary:1')"

17.RandomRowFilter ：随机获取一定比例（比例为参数）的数据；
18.SkipFilter ：当过滤器发现某一行中的一列要过滤时，就将整行数据都过滤掉；
19.WhileMatchFilter ：一旦遇到一条符合过滤条件的数据，就停止扫描；

20.FilterList ：多个过滤器组合过滤。

21.multipleColumnPrefixFilter ： 根据列名得前缀过滤，有范围，下面是列名‘a’开始到‘b’结束。
scan't1',{STARTROW=>'row0',STOPROW=>'row2',FILTER=>"MultipleColumnPrefixFilter('a','b')"}

使用AND
相当于FilterList的FilterList.Operator.MUST_PASS_ALL。
scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"(FamilyFilter(=,'substring:f1'))AND(ValueFilter(>=,'binary:2'))"}

使用OR
相当于FilterList的FilterList.Operator.MUST_PASS_ONE。
scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"((FamilyFilter(=,'substring:f1'))AND(ValueFilter(>=,'binary:2')))OR((FamilyFilter(=,'substring:f2'))AND(ValueFilter(>,'binary:1')))"}
scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"(FamilyFilter(=,'substring:f1'))AND(ValueFilter(>=,'binary:2'))"}
scan't1',{STARTROW=>'row0',STOPROW=>'row99',FILTER=>"(FamilyFilter(=,'substring:f2'))AND(ValueFilter(>=,'binary:1'))"}

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
