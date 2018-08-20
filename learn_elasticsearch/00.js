PUT /_template/van-gogh-driver-template
{
  "template": "van-gogh-driver-*",
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
    "driver": {
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
