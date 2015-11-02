#!/bin/bash
echo "## BEGING BACKUP INITIALIZE SCRIPT ######################################################"
echo ""

echo "For successfull script - check: # acknowledged:true #"

echo ""
echo "--> Give rights to backup folder to ES (please correct with your actual elasticsearch mount backup folder): "
	docker exec elk_elasticsearch_1 chown elasticsearch:elasticsearch /mount/backup/
echo ""

echo "--> Declare storage to ES"
echo ""
echo "* For today and yesterday backup:"
	curl -XPUT 'localhost:9200/_snapshot/index_shortterm_bck' -d '{
	    "type": "fs",
	    "settings": {
	        "location": "/mount/backup/index_shortterm_bck/",
	        "compress": true
	    }
	}'
    curl -POST localhost:9200/_snapshot/index_shortterm_bck?pretty=1

echo ""
echo "* For older than 2 days index:"
	curl -XPUT 'localhost:9200/_snapshot/index_longterm_bck' -d '{
	    "type": "fs",
	    "settings": {
	        "location": "/mount/backup/index_longterm_bck/",
	        "compress": true
	    }
	}'
    curl -POST localhost:9200/_snapshot/index_longterm_bck?pretty=1

echo ""
echo "## END BACKUP INITIALIZE SCRIPT ######################################################"
