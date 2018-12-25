now=$(date "+%Y-%m-%d %H:%M:%S")
echo $now
curl 'https://oapi.dingtalk.com/robot/send?access_token=token值' \
-H 'Content-Type: application/json' \
-d '{
    "msgtype": "text", 
    "text": {"content":"'"$now"' 司机和货主索引推送完成"}
    }'