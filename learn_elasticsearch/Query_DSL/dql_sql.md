* ## 通用查询
* ### 字段、排序、limit

```javascript
GET  van-gogh-driver-2018.07.02/_search
{
  "query": { "match_all": {} },
  "_source": [
    "cargo_driver_daily_call_cnt_30",
    "user_id",
    "profile_driver_daily_gender"
    ],
  "sort": [
    {"cargo_driver_daily_call_cnt_30":"desc"},
    { "user_id": "desc" }
  ],
  "from": 0,
  "size": 1
}
```

* ### and or not

``` javascript
## and must
GET van-gogh-driver-2018.07.02/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "profile_driver_daily_gender": "男" } },
        { "match": { "profile_driver_daily_truck_type": "高栏" } }

      ]
    }
  }
}


## or should
GET van-gogh-driver-2018.07.02/_search
{
  "query": {
    "bool": {
      "should": [
        { "match": { "profile_driver_daily_gender": "男" } },
        { "match": { "profile_driver_daily_gender": "女" } }

      ]
    }
  }
}

## not
GET van-gogh-driver-2018.07.02/_search
{
  "query": {
    "bool": {
      "must_not": [
        { "match": { "profile_driver_daily_gender": "男" } },
        { "match": { "profile_driver_daily_gender": "女" } }

      ]
    }
  },
    "_source": [
    "profile_driver_daily_gender"
    ]
}

## not and 
GET van-gogh-driver-2018.07.02/_search
{
  "query": {
    "bool": {
      "must_not": [
        { "match": { "profile_driver_daily_gender": "男" } },
        { "match": { "profile_driver_daily_gender": "女" } }

      ],
      "must": [
        {"match": {
          "profile_driver_daily_truck_type": "高栏"
        }}
      ]
    }
  },
    "_source": [
    "profile_driver_daily_gender",
    "profile_driver_daily_truck_type"
    ]
}
```
* ### filter （与 must 同级在bool中）

``` javascript
GET van-gogh-driver-2018.07.02/_search
{
  "query": {
    "bool": {
      "must": [
        {"match": {
          "profile_driver_daily_truck_type": "高栏"
        }}
      ],
      "filter": {
        "range": {
          "profile_driver_daily_truck_age": {
            "gte": 10,
            "lte": 20
          }
        }
      }
    }
  },
    "_source": [
    "profile_driver_daily_gender",
    "profile_driver_daily_truck_type",
    "profile_driver_daily_truck_age"
    ]
}
```
* ### Aggregations
*










# reindex
```
GET _tasks?detailed=true&actions=*reindex

POST _tasks/8e7RT5dARVCHUmwEvpUq-g:973012/_cancel
```
