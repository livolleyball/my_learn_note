查询
``` java
GET _search
{
  "query": {
    "match": {
      "FIELD": "TEXT"
    }
  }
}

或者

GET _search
{
  "query": {
    "match": {
      "FIELD": {
        "query": "TEXT",
        "OPTION": "VALUE"
      }
    }
  }
}
```
通用查询
聚合支持
value_count
sum
avg
min
max
stats 统计
```java
{
    ...

    "aggregations": {
        "grades_stats": {
            "count": 2,
            "min": 50.0,
            "max": 100.0,
            "avg": 75.0,
            "sum": 150.0
        }
    }
}
```

``` java
GET /_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "smith"
          }
        }
      ],
      "must_not": [
        {
          "match_phrase": {
            "title": "granny smith"
          }
        }
      ],
      "filter": [
        {
          "exists": {
            "field": "title"
          }
        }
      ]
    }
  },
  "aggs": {
    "my_agg": {    --
      "terms": {  -- 词条统计
        "field": "user",
        "size": 10
      }
    }
  },
  "size": 20,   -- 获取 20条数据
  "from": 100,   -- 从100位置开始
  "_source": [  -- 选取字段
    "title",
    "id"
  ],
  "sort": [  -- 排序
    {
      "_id": { -- 排序字段
        "order": "desc"
      }
    }
  ]
}
```

索引和映射
生成一个索引，包括一些设置参数和映射值
```java
PUT /my_index_name
{
  "settings": {
    "number_of_replicas": 1, -- 副本数
    "number_of_shards": 3, -- 分片数
    "analysis": {},
    "refresh_interval": "1s"  -- 刷新频率
  },
  "mappings": {
    "my_type_name": {    -- type 名
      "properties": {   -- 属性
        "title": {   -- title 字段
          "type": "text",   -- 字段数据类型
          "analyzer": "english"   -- 分词器
        }
      }
    }
  }
}
```
动态地变更索引设置
``` java
PUT /my_index_name/_settings
{
  "index": {
    "refresh_interval": "-1",
    "number_of_replicas": 0
  }
}
```


模板 动态模板
```
PUT /_template/van-gogh-shipper-template
{
  "template": "van-gogh-shipper-*",
  "settings": {
	"index": {
			"number_of_shards": "3",
			"refresh_interval": "120s"
		  },
		  "analysis":{
            "analyzer":{
                "my_analyzer":{
                    "tokenizer":"pattern"
                }
            },
            "tokenizer":{
                "my_tokenizer":{
                    "type":"pattern",
                    "pattern":","
                }
            }
        }
  },
  "mappings": {
    "shipper": {
      "dynamic_templates": [
        {
          "double": {
            "match_mapping_type": "double",
            "mapping": {
              "type": "float"
            }
          }
        },
        {
          "long": {
            "match_mapping_type": "long",
            "mapping": {
              "type": "long"
            }
          }
        },
        {
          "strings": {
            "match_mapping_type": "string",
			      "unmatch": "tasks_activity_daily_task_tag_set",
            "mapping": {
              "type": "keyword"
            }
          }
        }
      ],
	"properties":{
			"tasks_activity_daily_task_tag_set":{
				"type":"text",
				"analyzer":"my_analyzer",
				"fielddata":true
			}
		}
    }
  }
}
```

更新 单个字段的数据类型
```
PUT /my_index_name/_mapping/my_type_name
{
  "my_type_name": {
    "properties": {
      "tag": {
        "type": "keyword"
      }
    }
  }
}
```

查看索引的字段映射和设置
```
GET /my_index_name/_mapping
GET /my_index_name/_settings
```

生成、更新一个文档
```
PUT /my_index_name/my_type_name/12abc
{
  "title": "Elastic is funny",
  "tag": [
    "lucene"
  ]
}
```
删除一个文档
```java
DELETE /my_index_name/my_type_name/12abc
```
打开/关闭索引 以节省性能
```
POST /my_index_name/_close
POST /my_index_name/_open
```

移除/生成 别名
```java
POST /_aliases
{
  "actions": [
    {
      "remove": {
        "index": "my_index_name",
        "alias": "foo"
      }
    },
    {
      "add": {
        "index": "my_index_name",
        "alias": "bar",
        "filter" : { "term" : { "user" : "damien" } }
      }
    }
  ]
}
```
展示别名
```
GET /_aliases
GET /my_index_name/_alias/*
GET /*/_alias/*
GET /*/_alias/foo
```


索引监控 以及索引信息
```
GET /my_index_name/_stats
GET /my_index_name/_segments
GET /my_index_name/_recovery?pretty&human
```

索引状态 和 管理
```
POST /my_index_name/_cache/clear
POST /my_index_name/_refresh
POST /my_index_name/_flush
POST /my_index_name/_forcemerge
```

集群 节点信息
```
GET /_cluster/health?pretty
GET /_cluster/health?wait_for_status=yellow&timeout=50s
GET /_cluster/state
GET /_cluster/stats?human&pretty
GET /_cluster/pending_tasks
GET /_nodes
GET /_nodes/stats
GET /_nodes/nodeId1,nodeId2/stats
```
