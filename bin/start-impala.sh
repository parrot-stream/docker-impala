#!/bin/bash

sudo -u hdfs hdfs dfs -ls /user/impala 2> /dev/null
if [[ "$?" != "0" ]]; then
	echo "Creating directories in HDFS for Impala"
        sudo -u hdfs hdfs dfs -mkdir  /user/impala
	sudo -u hdfs hdfs dfs -chmod 755  /user	
	sudo -u hdfs hdfs dfs -chown impala:impala /user/impala
fi

supervisorctl start impala-state-store
supervisorctl start impala-catalog
supervisorctl start impala-server

