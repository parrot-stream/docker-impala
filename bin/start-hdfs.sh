#!/bin/bash

if [[ ! -e /var/lib/hadoop-hdfs/cache/hdfs/dfs/name/current ]]; then
	/etc/init.d/hadoop-hdfs-namenode init
fi
supervisorctl start hdfs-namenode
supervisorctl start hdfs-datanode

./wait-for-it.sh hadoop:8020 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n---------------------------------------"
    echo -e "     HDFS not ready! Exiting..."
    echo -e "---------------------------------------"
    exit $rc
fi

sudo -u hdfs hdfs dfs -chown hdfs:supergroup /
sudo -u hdfs hdfs dfs -chmod 777 /
sudo -u hdfs hdfs dfs -mkdir -p /tmp
sudo -u hdfs hdfs dfs -chmod 777 /tmp

