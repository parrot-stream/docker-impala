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
