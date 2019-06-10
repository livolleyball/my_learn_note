hive-site.xml
metastore.warehouse.dir       hive管理的所有数据都存放在使用hive定义的顶层目录下




术语 
SerDe  是 serializer/deserializer 的缩写， 
create table json_serde_table (

)
row format serde 'org.openx.data.jsonserde.JsonSerDe'
with serdeproperties ("mapping._id"="id")