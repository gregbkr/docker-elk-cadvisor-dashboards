##################################################################
# INDEX MGMT : backup, restore and manage indices
##################################################################

----------------------------------------------------
1. STORAGE SETUP (local)
----------------------------------------------------

*Setup the storage(already done): edit elasticsearch.yml and add the line : path.repo: ["/mount/backup", "/mount/longterm_backup"] --> it have to be a shared/mounted folder between container/host (or ony container)
# for dev: backup on local server: /root/elk/backup/
 
*Declare storage to ES: (if issue, give some right: docker exec elk_elasticsearch_1 chown elasticsearch:elasticsearch /mount/backup/)

# For today and yesterday backup
curl -XPUT 'localhost:9200/_snapshot/index_shortterm_bck' -d '{
    "type": "fs",
    "settings": {
        "location": "/mount/backup/index_shortterm_bck/",
        "compress": true
    }
}'

# For older than 2 days index
curl -XPUT 'localhost:9200/_snapshot/index_longterm_bck' -d '{
    "type": "fs",
    "settings": {
        "location": "/mount/backup/index_longterm_bck/",
        "compress": true
    }
}'

*check storage:
    curl -POST localhost:9200/_snapshot/index_shortterm_bck?pretty=1
    curl -POST localhost:9200/_snapshot/index_longterm_bck?pretty=1

Check storage space :
* DB size: docker exec elk_elasticsearch_1 du -hs /var/lib/elasticsearch/data
* Backup size: du -hs /root/elk/backup

----------------------------------------------------
2. INDICE
----------------------------------------------------
*Check all indices, or only one:
    curl -XGET localhost:9200/_aliases?pretty=1
    curl -XGET localhost:9200/.kibana?pretty=1

*CLOSE an index:
    curl -XPOST 'localhost:9200/logstash-2015.08.29/_close'

*DELETE an index:
    curl -XDELETE http://localhost:9200/logstash-2015.08.29

*OPEN an index:
    curl -XPOST 'localhost:9200/logstash-2015.08.29/_open'

----------------------------------------------------
3. SNAPSHOT (BACKUP)
----------------------------------------------------

*TAKE SNAPSHOT of ALL indices:
    curl -XPUT "localhost:9200/_snapshot/index_bck/snapshot_1?wait_for_completion=true"

*TAKE SNAPSHOT of ONE indice only:
    curl -XPUT 'localhost:9200/_snapshot/index_bck/snapshot_.kibana' -d '{
    "indices": ".kibana",
    "ignore_unavailable": "true",
    "include_global_state": false
    }'

*CHECK ALL snapshots:
    curl -s -XGET "localhost:9200/_snapshot/index_bck/_all"?pretty=1
    curl -s -XGET "localhost:9200/_snapshot/index_shortterm_bck/_all"?pretty=1

*CHECK ONLY ONE snapshot:
    curl -s XGET localhost:9200/_snapshot/index_shortterm_bck/curator-20151023210002?pretty=1

*CHECK only one snapshot STATUS or progression:
    curl -s XGET localhost:9200/_snapshot/index_bck/snapshot_.kibana/_status?pretty=1

*DELETE one snapshot:
    curl -X DELETE localhost:9200/_snapshot/index_bck/snapshot_.kibana

----------------------------------------------------
3. RESTORE
----------------------------------------------------

* RESTORE ALL index from snapshot
   
    curl -XPOST http://localhost:9200/_snapshot/index_shortterm_bck/curator-20150729133045/_restore

*RESTORE ONE index from snapshot containing ONE index:

    curl -XPOST localhost:9200/_snapshot/index_shortterm_bck/snapshot_.kibana/_restore
    curl -XPOST "localhost:9200/_snapshot/index_shortterm_bck/snapshot_.kibana/_restore?pretty=true&wait_for_completion=true"

*RESTORE ONE index from snapshot containing SEVERAL indexes:
    curl -XPOST localhost:9200/_snapshot/index_shortterm_bck/curator-20151023210002/_restore -d '{ "indices": "logstash-2015.09.21" }'

    curl -XPOST localhost:9200/_snapshot/index_shortterm_bck/snapshot-curator-20151023210002/_restore -d '{ "indices": "logstash-2015.10.22" }'

*CHECK restore status:
    curl -XGET "<hostname>:9200/snapshot_.kibana/_recovery?pretty=true"
 

----------------------------------------------------
3. CURATOR : backup, optimize indices
----------------------------------------------------

Backup through Curator is always incremental. If some other backup exist on the share storage, curator only take the diff.
http://untergeek.com/2014/02/18/curator-managing-your-logstash-and-other-time-series-indices-in-elasticsearch-beyond-delete-and-optimize/
https://github.com/elastic/curator/issues/174#issuecomment-57056621
Carefull your firewall: sudo nano /etc/default/ufw :  DEFAULT_OUTPUT_POLICY="ACCEPT"


*Take snapshot (of kibana index)
    docker run --rm bobrik/curator --host yourIP --port 9200 snapshot --repository index_bck --name new_snap indices --index .kibana

*view snapshots: 
    docker run --rm bobrik/curator --host yourIP --port 9200 show snapshots --all-snapshots --repository index_shortterm_bck


--------------------------------------------------------------
4. INDEX TEMPLATE : define how field are process in the index
--------------------------------------------------------------

For exemple, for cadvisor, we need a template in order to have a raw version of analysed field, to use for visualisation. By default, containe_Name=/user/1000.user field is analyzed and split in /user, /1000, User. The full name (raw version) isn't then available for query. We mapped then to elasticsearch container at start the template: - $PWD/es-conf/templates:/usr/share/elasticsearch/config/templates

If it doesnt work through mapping, we can do manually:


```
#!shell

curl -XPUT http://localhost:9200/_template/cadvisor -d '      
{
    "template" : "cadvisor*",
    "mappings" : {
      "_default_" : {
        "dynamic_templates" : [ {
          "message_field" : {
            "mapping" : {
              "index" : "analyzed",
              "omit_norms" : true,
              "type" : "string"
            },
            "match_mapping_type" : "string",
            "match" : "message"
          }
        }, {
          "string_fields" : {
            "mapping" : {
              "index" : "analyzed",
              "omit_norms" : true,
              "type" : "string",
              "fields" : {
                "raw" : {
                  "ignore_above" : 256,
                  "index" : "not_analyzed",
                  "type" : "string"
                }
              }
            },
            "match_mapping_type" : "string",
            "match" : "*"
          }
        } ],
        "_all" : {
          "omit_norms" : true,
          "enabled" : true
        },
        "properties" : {
          "geoip" : {
            "dynamic" : true,
            "type" : "object",
            "properties" : {
              "location" : {
                "type" : "geo_point"
              }
            }
          },
          "@version" : {
            "index" : "not_analyzed",
            "type" : "string"
          }
        }
      }
    },
    "aliases" : { }
  }
}'
```

Check the result (carefull, you will see a result only if setting added via curl, not via file mapping :-O :

    curl -XGET http://localhost:9200/_template?pretty


-------------------------------------------------------------------------
4. INDEX PATTERN : Define how elasticsearch data are presented to kibana
-------------------------------------------------------------------------

Setting > Indice

# logstash default pattern:
Logstash logs by default in one new index each day.
So to configure the pattern to see the log have to be:
New pattern > tick both boxes > Daily > the pattern name [logstash-]YYYY.MM.DD > select @timestamp.

# cAdvisor pattern: 
New pattern > name=cadvisor. Here your should see the time filed "container_stats.timestamp" come up. 

# To switch and view different index:
Go  to Discover, and click the small arrow near [logstash-]YYYY.MM.DD in order to change to cAdvisor index.


##################################################################
# ELASTICDUMP : Save and restore indices
##################################################################

Export/save all config and kibana index: 
    docker run \
      --rm \
      -v $PWD/kibana-conf:/kibana-conf \
      sherzberg/elasticdump \
        --input=http://192.168.33.10:9200/.kibana \
        --output=$ \
        --type=data \
    > kibana-conf/kibana4-index-export.json

Import: 
    docker run \
      --rm \
      -v $PWD/kibana-conf:/kibana-conf \
      sherzberg/elasticdump \
        --input=/kibana-conf/kibana4-index-export.json \
        --output=http://192.168.33.10:9200/.kibana \
        --type=data

