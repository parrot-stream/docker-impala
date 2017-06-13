#!/bin/bash

./wait-for-it.sh zookeeper:2181 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "      Zookeeper not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

/opt/docker/start-hdfs.sh
/opt/docker/start-yarn.sh

echo -e "\n\n--------------------------------------------------------------------------------"
echo -e "You can now access to the following Hadoop Web UIs:"
echo -e ""
echo -e "Hadoop - NameNode:			http://localhost:50070"
echo -e "Hadoop - DataNode:			http://localhost:50075"
echo -e "Hadoop - YARN Node Manager:		http://localhost:8042"
echo -e "Hadoop - YARN Resource Manager:	http://localhost:8088"
echo -e "Hadoop - YARN Application History:	http://localhost:8188"
echo -e "Hadoop - MapReduce Job History:	http://localhost:19888/jobhistory"
echo -e "\nMantainer:   Matteo Capitanio <matteo.capitanio@gmail.com>"
echo -e "--------------------------------------------------------------------------------\n\n"


########################################
#	IMPALA
########################################
./wait-for-it.sh hive:10002 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n---------------------------------------"
    echo -e "     HIVE not ready! Exiting..."
    echo -e "---------------------------------------"
    exit $rc
fi

/opt/docker/start-impala.sh

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
