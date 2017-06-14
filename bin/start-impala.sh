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

./wait-for-it.sh localhost:21050 -t 120
./wait-for-it.sh localhost:24000 -t 120
./wait-for-it.sh localhost:25010 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n---------------------------------------"
    echo -e "     Impala not ready! Exiting..."
    echo -e "---------------------------------------"
    exit $rc
fi

echo -e "\n\n--------------------------------------------------------------------------------"
echo -e "You can now access to the following Impala UIs:\n"
echo -e "Impala State Store 		http://localhost:25010"
echo -e "\nMantainer:   Matteo Capitanio <matteo.capitanio@gmail.com>"
echo -e "--------------------------------------------------------------------------------\n\n"
