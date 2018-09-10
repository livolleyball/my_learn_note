``` java
PUT /my_index_0
{

    "mappings": {
      "my_child": {
        "_parent": {
          "type": "my_parent"
        },
        "_routing": {
          "required": true
        },
        "properties": {
          "gender": {
            "type": "long"
          },
          "user_id": {
            "type": "keyword"
          },
          "tag_id":{
            "type":"text",
            "fielddata":true
          }
        }
      },
      "my_parent": {
        "properties": {
          "age": {
            "type": "long"
          },
          "user_id": {
            "type": "keyword"
          }
        }
      }
    },
    "settings": {
      "index": {
        "number_of_shards": "1",
        "number_of_replicas": "1"
      }
    }

}

PUT  my_index_0/parent/2
{
  "user_id":2,
  "age":12
}

PUT  my_index_0/my_child/1?parent=1
{
  "user_id":1,
  "gender":1,
  "tag_id" : ["red1"]
}


POST my_index_0/my_child/2/_update?routing=2&refresh
{
    "script" : {
        "inline": "ctx._source.tag_id.add(params.tag)",

        "lang": "painless",
        "params" : {
            "tag" : "70"
        }
    }
}

GET my_index_0/my_child/_search
```
