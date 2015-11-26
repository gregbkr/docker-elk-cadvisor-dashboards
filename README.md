## RUN LOGGING INFRA : ELK STACK (+ docker syslog driver)

![ELK_Infra.png](https://github.com/gregbkr/docker-elk-cadvisor-dashboards/raw/master/ELK_Infra.png)

## 0. Summary:

This build will setup ELK stack, and bring you dashboards in order to visualize ELK logs as a first example. 
You can run on the vagrant provided, or on a test host, where logs from already running docker containers will automatically be forwarded to ELK.

One Docker Compose will run: 

* ElasticSearch 1.7 (+data container)
* Logstash 1.5.3 (+conf for elk logs)
* Kibana 4 (+Dashboard for elk logs)
* cAdvisor (Collect & View containers performance)
* Ngnix Proxy 1.9.3 (for SSL + password access).

The result:
![Dashboard.png](https://github.com/gregbkr/docker-elk-cadvisor-dashboards/raw/master/Dashboard.png)

## 1.  Prerequisite: at the end of README.

## 2. Get all files from github
    git clone https://github.com/gregbkr/docker-elk-cadvisor-dashboards

## 3. Rename and go to elk folder:    
    mv docker-elk-cadvisor-dashboards elk
    cd elk

## 4. Run all containers:
(you probably get the error with port 80, see error section below)

    docker-compose up -d

## 5. Deploy initialization:

Wait 5 min Deploy all init:

    ./deploy-init.sh



OR one by one:

Configure Kibana index pattern: 
    
    es-conf/indexpattern-init.sh

Configure storage for backup:

    es-conf/backup-init.sh

Deploy fake logs (good to test Web dashboard for IP map):

    kibana-conf/deploy-fake-logs.sh

    
## 6. Log on kibana to see the result
(If script failed configure manually the index pattern: in Setting > Indice : tick both boxes and select @timestamp)

http://dev.local:5601 (direct without proxy)

https://dev.local:5600 (!HTTPS ONLY! enter the credentials admin/Kibana05) 

## 7. Import all dashboards and Searches: 
    Setting > Object > Import > /kibana-conf/export_vX.json

If some dashboards do not display well, need to wait 2 min for the data to come in, then refresh the fields in order to force ELK to initialize  them now:

    Setting > Indices > [logstash-]YYYY.MM.DD > Reload field list (the circle arrow in orange)


## 9. cAdvisor --> ELK

cAdvisor will catch containers metrics running on your docker host, and then send it to ELK.
cAdvisor should already be running through docker-compose.

You can run other instance, on another host, via this standalone container: (if on another host, you will have to correct storage_driver_es_host)

    docker run \
      --volume=/:/rootfs:ro \
      --volume=/var/run:/var/run:rw \
      --volume=/sys:/sys:ro \
      --volume=/var/lib/docker/:/var/lib/docker:ro \
      --publish=8888:8080 \
      --detach=true \
      --name=cadvisor \
      --link=elk_elasticsearch_1:elasticsearch \
      google/cadvisor:latest \
      -storage_driver="elasticsearch" -alsologtostderr=true -storage_driver_es_host="http://elk_elasticsearch_1:9200"

### Access cAdvisor for live logs
http://dev.local:8888

### Access metric through ELK:
You should already have some data in the dashboard cAdvisor.
If not, please check index-mgmt.md setting index-pattern, or template (raw field)


#
#---------------------- Config  -------------------------------

## 10. Logstash

### Validate your config 

You can run logstash to easily collect input string. Each input you paste in the invite will be process and output on screen by logstash. To setup, please run this container: 
  
    docker run -it --rm --name logstash -p 5001:5000 -p 5001:5000/udp -v $PWD/logstash-conf:/opt/logstash/conf.d logstash:1.5.3  -f /opt/logstash/conf.d/logstash-test.conf
  
And paste log messages like this and check if the output is correct. Make modification to logstash-test.conf and restart logstash container to refresh.

    <14>2015-08-31T15:20:00 vagrant-ubuntu-trusty-64 docker/proxyelk[870]: 2015/07/20 17:19:13 routing all to syslog://dev.local:5000

If you got the field tags = ParseFailure, means your parsing is wrong somewhere... :-(

### Modify log parsing

You can use https://grokdebug.herokuapp.com/ in order to check a log parsing. 

#
#------ Backup and Restore and optimize ------

## 12. Index management (backup, restore, rotate)

Configure backup storage  : (done in initialization step - in our case, backups will go in the $PWD/backup local folder)

    es-conf/backup-init.sh

Edit as you wish (correct with you --host IP) and set cron job for backup, restore, index rotation:

    crontab -l | cat es-conf/backup.crontab | crontab -

You can now monitor the backup via CURATOR dashboard

More info in file: index-mgmt.md

#
#---------------------- Stop and refresh -------------------
## 13. To stop compose
    docker-compose stop

## 14. To refresh logstash after a modification in the logstash.conf file:
    docker restart elk_logstash_1


#--------------------- TODO NEXT --------------------------

* cAdvisor stats: correct some bugs and add more graphs.
* Backup and restore: tests full recovery
* Docker daemon logs to listen to container crashes
* Event alerting (via email)

#
#---------------------- Errors  ----------------------------------
## Port in use:
listen tcp 0.0.0.0:80: bind: address already in use: --> stop nginx service:

    sudo service nginx stop

## Container seems to not run:

Checks logs on compose and container:

    docker-compose logs
    docker log -f elk_logstash_1

#--------------------Prerequisite -----------------------------

### a. Use the vagrantfile provided in the root in order to have a configured environment with docker and compose already up to date.

### b. In the whole page we use dev.local = your_host_ip = where the containers run. Please use your IP or map it in your local hosts file (laptop and vagrant VM).
    ip a | grep 'scope global eth'

For Linux/MAC:

    sudo nano /etc/hosts

For Windows (copy file to desktop, edit, and copy back ;-):

    c:\windows\system32\etc\driver\hosts

### c. Install Docker (1.8.1)

    wget -qO- https://get.docker.com/ | sed 's/lxc-docker/lxc-docker-1.8.1/' | sh
    gpasswd -a vagrant docker
    service docker restart

### d. Install Compose (1.4.0)
    
    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/1.4.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

### e. Firewall + Docker

Be carefull if you have firewall activated on the docker host. PLease follow that config:
 
start docker with --iptables=false : edit DOCKER_OPTS="--iptables=false"
    
    sudo nano /etc/default/docker
    sudo restart docker

FORWARD chain policy set to ACCEPT, edit DEFAULT_FORWARD_POLICY="ACCEPT" 

    sudo nano /etc/default/ufw
    sudo ufw reload

Add the following NAT rule to allow outgoing connection from docker network:

    iptables -t nat -A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE


#-------------------- MISC -----------------------------

### configure your own logo 
(height: 45px; width: 252px)
    
    docker cp kibana-conf/no_border.png elk_kibana_1:/opt/kibana/s rc/public/images


### Clean up Docker to free space on host
 
Treesize: install and check your disk 

    apt-get install ncdu
    ncdu /

Size of one path:

    du -hs /path

Find all our data container:

    docker ps -a | grep 'data'

Check your db size:

    docker exec elk_elasticsearch_1 du -hs /var/lib/elasticsearch/data

BACKUP : Make a backup of your datacontainers: copy datacontainer data --> host:

    cd to/your/backup/folder
    docker run --rm --volumes-from elk_elasticdata_1 -v $PWD:/backup ubuntu tar cvf /backup/datacontainer-var-lib-elasticsearch-data_`date +%d-%m-%Y"_"%Hh%Mm%Ss`.tar /var/lib/elasticsearch/data

LIST dangling/orphan images:

    docker images -f dangling=true | awk '{if(NR>1) print $0}'

DELETE dangling/orphan image: (not use or orphan images)

    docker images -f dangling=true | awk '{if(NR>1) print $3}' | xargs docker rmi

LIST only created/exited weeks ago (and NOT minute/day), and NOT data container (container_name NOT contains "data") (please double check if no datacontainer inside that list)

    docker ps -a -f status=exited | grep -v 'data'| grep -v 'minute' | grep -v 'day' | grep week

DELETE this list above:

    docker ps -a -f status=exited | grep -v 'data'| grep -v 'minute' | grep -v 'day' | grep week | awk '{if(NR>1) print $1}' | xargs -r docker rm

LIST dead container:

    docker ps -a -f status=dead | grep -v 'data'

DELETE dead container:

    docker ps -a -f status=dead | grep -v 'data' | awk '{if(NR>1) print $1}' | xargs -r docker rm
