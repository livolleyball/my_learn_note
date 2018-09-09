``` java
GET /my_index/_search?human=true
{
  "profile": true,
  "query" : {
    "match" : { "message" : "some number" }
  }
}
```
query 部分包括 collectors、 rewrite 和 query 部分。 对于复杂的 query , profile 会将query 拆分成多个基础的 TermsQuery ,
然后每个 termquery 再显示各自的分阶段耗时。
``` java
"profile": {
  "shards": [
    {
      "id": "[AJwTf2UCToKxNuY94rrPBA][van-gogh-driver-2018.08.28][1]",
      "searches": [
        {
          "query": [
            {
              "type": "TermQuery",
              "description": "tasks_activity_daily_task_tag_set:OPEN_17154_11_3_1_20180725",
              "time": "18.87708800ms",
              "time_in_nanos": 18877088,
              "breakdown": {
                "score": 0,
                "build_scorer_count": 10,
                "match_count": 0,
                "create_weight": 21807,
                "next_doc": 6553814,
                "match": 0,
                "create_weight_count": 1,
                "next_doc_count": 7672,
                "score_count": 0,
                "build_scorer": 12293784,
                "advance": 0,
                "advance_count": 0
              }
            }
          ],
          "rewrite_time": 1688,
          "collector": [
            {
              "name": "CancellableCollector",
              "reason": "search_cancelled",
              "time": "13.10421400ms",
              "time_in_nanos": 13104214,
              "children": [
                {
                  "name": "TotalHitCountCollector",
                  "reason": "search_count",
                  "time": "9.132146000ms",
                  "time_in_nanos": 9132146
                }
              ]
            }
          ]
        }
      ],
      "aggregations": []
    },
    {
      "id": "[R6ppQiLoQBS2He-FJEse1g][van-gogh-driver-2018.08.28][2]",
      "searches": [
        {
          "query": [
            {
              "type": "TermQuery",
              "description": "tasks_activity_daily_task_tag_set:OPEN_17154_11_3_1_20180725",
              "time": "10.43396200ms",
              "time_in_nanos": 10433962,
              "breakdown": {
                "score": 0,
                "build_scorer_count": 14,
                "match_count": 0,
                "create_weight": 22774,
                "next_doc": 6519006,
                "match": 0,
                "create_weight_count": 1,
                "next_doc_count": 7511,
                "score_count": 0,
                "build_scorer": 3884656,
                "advance": 0,
                "advance_count": 0
              }
            }
          ],
          "rewrite_time": 2550,
          "collector": [
            {
              "name": "CancellableCollector",
              "reason": "search_cancelled",
              "time": "6.313649000ms",
              "time_in_nanos": 6313649,
              "children": [
                {
                  "name": "TotalHitCountCollector",
                  "reason": "search_count",
                  "time": "2.106430000ms",
                  "time_in_nanos": 2106430
                }
              ]
            }
          ]
        }
      ],
      "aggregations": []
    }
  ]
}
```
聚合统计 分为初始化阶段 initialise/收集阶段 collect/构建 build /汇总 reduce
