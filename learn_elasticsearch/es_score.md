在elasticsearch复合框输入搜索语句到结果显示，展现给我们的是一个按score得分从高到底排好序的结果集。


     coord(q,d) 评分因子，基于文档中出现查询项的个数。越多的查询项在一个文档中，说明文档的匹配程度越高。
     queryNorm(q)查询的标准查询
     tf(t in d) 指项t在文档d中出现的次数frequency。具体值为次数的开根号。
     idf(t) 反转文档频率, 出现项t的文档数docFreq
     t.getBoost 查询时候查询项加权
     norm(t,d) 长度相关的加权因子

Make something people want


添加距离权重 
GET poi-hotel-map-index/_search
{
    "query": {
        "function_score": {
          "query": {"match": {
             "name_cn_word": {
                "query":                "和颐至尊",
                "minimum_should_match": "100%"
            }}},
 
          "functions": [
        {
          "gauss": {
            "location": { 
              "origin": { "lat": 31.24058, "lon": 121.52826 },
              "offset": "1km",
              "scale":  "5km"
            }
          },
            "weight": 2
        }
          ]
        }
    }
}