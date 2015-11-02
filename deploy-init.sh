#!/bin/bash
echo "## BEGING INITIALIZE ELK SCRIPT ######################################################"
#sudo chmod +x *.sh

es-conf/indexpattern-init.sh
es-conf/backup-init.sh
kibana-conf/deploy-fake-logs.sh


echo "## END INITIALIZE ELK SCRIPT ######################################################"
