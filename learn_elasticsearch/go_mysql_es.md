
github地址:
https://github.com/shengxianye/go-mysql-elasticsearch



安装步骤：
1.安装go
2.go get github.com/siddontang/go-mysql-elasticsearch
3.cd $GOPATH/src/github.com/siddontang/go-mysql-elasticsearch
4.make (bin/下自动生成go-mysql-elasticsearch可执行文件)



使用限制:
1.mysql binlog日志格式必须是row
2.更新主键时会丢失数据
3.不能再运行时使用alter语句
4.mysql表必须有主键，如果是联合主键，我们可以用"a:b"作为es的_id
5.如果有特殊需求，我们可以动手创建mapping，否则会自动生成mapping
6.mysqldump必须在运行主机上存在，否则只会同步binlog，不会全量导入
7.不要批量更改多行记录

```
./go-mysql-elasticsearch -config=./etc/.toml

curl -XDELETE 'http://192.168.199.110:9205/index*'   （删除es中的mapping）
rm -rf var                                                  （删除binlog位置记录，否则不会mysqldump）
vim ./etc/.toml                                        （修改配置文件
```

```
[root@ etc]#grep -v "^#"  .toml
my_addr = "192.168.199.36:3306"
my_user = "root"
my_pass = "zq"
my_charset = "utf8"
es_addr = "192.168.199.110:9205"
es_user = ""
es_pass = ""
data_dir = "./var"
stat_addr = "192.168.199.111:12802"
server_id = 1002
flavor = "mysql"
mysqldump = "mysqldump"

bulk_size = 128
flush_bulk_time = "200ms"
[[source]]
schema = "logistics"
tables = ["profiles"]
[[rule]]
schema = "logistics"
table = "profiles"
index = "index_v1"
type = "dInfo"
filter = ["user_id", "user_name","telephone","type","length","number","user_type","update_time","create_time"]
id = ["user_id"]
parent = "position_id"  
[rule.field]
user_id="userId"
user_name="userName"
telephone="phoneNum"
type="truckType"
length="truckLens"
number="truckNum"
user_type="dStatus"
update_time="updateTime"
create_time="createTime"
```
