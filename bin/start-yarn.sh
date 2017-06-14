#!/bin/bash

supervisorctl start yarn-resourcemanager
/opt/docker/wait-for-it.sh localhost:8088 -t 60
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "YARN Resource Manager not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

supervisorctl start yarn-nodemanager
/opt/docker/wait-for-it.sh hadoop:8042 -t 60
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "YARN Node Manager not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

supervisorctl start mapreduce-historyserver
/opt/docker/wait-for-it.sh hadoop:19888 -t 60
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "MapReduce Job History not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

supervisorctl start yarn-timelineserver
/opt/docker/wait-for-it.sh hadoop:8188 -t 60
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "       YARN Application History..."
    echo -e "--------------------------------------------"
    exit $rc
fi

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
