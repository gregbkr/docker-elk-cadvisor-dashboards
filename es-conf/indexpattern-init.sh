
#!/bin/bash
# enable script execution: sudo chmod +x *.sh

echo "## BEGING DEPLOY INITIALISATION FOR ELASTICSEARCH #####################################"
echo ""
echo "For successfull script - check: # created:true #"

echo ""
echo "--> Create ES index pattern for : [logstash-]YYYY.MM.DD"
curl -XPUT http://localhost:9200/.kibana/index-pattern/\%5Blogstash-%5DYYYY.MM.DD -d '{"title" : "[logstash-]YYYY.MM.DD",  "timeFieldName": "@timestamp", "intervalName": "days"}'
echo ""
echo ""

echo "--> Make index pattern [logstash-]YYYY.MM.DD as primary"
curl -XPUT http://localhost:9200/.kibana/config/4.1.1 -d '{"defaultIndex" : "[logstash-]YYYY.MM.DD"}'
echo ""
echo ""

echo "--> Create ES index pattern for : cadvisor"
curl -XPUT http://localhost:9200/.kibana/index-pattern/cadvisor -d '{"title" : "cadvisor",  "timeFieldName": "container_stats.timestamp"}'
echo ""
echo ""

echo "## END DEPLOY INITIALISATION FOR ELASTICSEARCH #####################################"
	