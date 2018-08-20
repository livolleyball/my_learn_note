### Term Query
#### 名词解释：
* content 会被切分成单独的单词 **（词（terms）或者表征（tokens））**
* **分析器（analyzer）**
  * 标准分析器（standard）
  ``` java
  POST _analyze
{
  "analyzer": "standard",
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}
将会得到以下分词
[ the, 2, quick, brown, foxes, jumped, over, the, lazy, dog’s, bone ]
  ```

  * Letter Tokenizer 单词表征标记器
  ``` java
  POST _analyze
{
  "tokenizer": "letter",
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}
将会得到以下分词
[ The, QUICK, Brown, Foxes, jumped, over, the, lazy, dog, s, bone ]
单词保留了大小写，filter掉了数字和 - / .
  ```
  * Lowercase Tokenizer 小写表征标记器
  ``` java
  POST _analyze
{
  "tokenizer": "lowercase",
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}
将会得到以下分词
[ The, QUICK, Brown, Foxes, jumped, over, the, lazy, dog, s, bone ]
单词转化为小写，filter掉了数字和 - / .
  ```
  * Whitespace Tokenizer 空格标记器
  ``` java
  POST _analyze
{
  "tokenizer": "whitespace",
  "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
}
将会得到以下分词
[ The, 2, QUICK, Brown-Foxes, jumped, over, the, lazy, dog’s, bone. ]
相当于将content按空格分割,保留了-/.
```
  * UAX URL Email Tokenizer
  * Classic Tokenizer ( good for english)

#### 建模板时指定分析器
``` java
PUT my_index
{
  "mappings": {
    "_doc": {
      "properties": {
        "title": {
          "type":     "text",
          "analyzer": "standard"
        }
      }
    }
  }
}
```

#### 建模板时指定自定义标记器
``` java
DELETE my_index_04

PUT my_index_04
{
    "settings":{
        "analysis":{
            "analyzer":{
                "my_analyzer":{
                    "tokenizer":"pattern" # 标记器为pattern
                }
            },
            "tokenizer":{
                "my_tokenizer":{
                    "type":"pattern", # 自定义pattern
                    "pattern":","
                }
            }
        }
    },
    "mappings":{
        "doc":{
            "properties":{
                "title":{
                    "type":"text",
                    "analyzer":"my_analyzer",
                    "fielddata":true  # text 类型用于检索，fielddata要设置 true
                }
            }
        }
    }
}


PUT my_index_04/doc/1
{"title" : "a_1,b_3,c_D,d,e,f,5"}


GET my_index_04/doc/_search
{
  "size": 0,
    "aggs" : {
        "genres" : {
            "terms" : { "field" : "title" }
        }
    }
}
```

#### 存储比较
``` java
POST _analyze
{
  "tokenizer" : "keyword",
  "filter" : ["lowercase"],
  "text" : "a,b,c,d,e,f"
}

POST _analyze
{
  "analyzer" : "standard",
  "filter" : ["lowercase"],
  "text" : "a,b,c,d,e,f,5"
}
```
