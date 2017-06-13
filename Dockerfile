FROM ubuntu:16.04

MAINTAINER Matteo Capitanio <matteo.capitanio@gmail.it>

ENV IMPALA_VER 2.8.0+cdh5.11.1
ENV HADOOP_VER 2.6.0+cdh5.11.1

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/

USER root

WORKDIR /opt/docker

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget apt-transport-https python-setuptools openjdk-8-jdk apt-utils sudo
RUN easy_install supervisor
RUN wget http://archive.cloudera.com/cdh5/one-click-install/trusty/amd64/cdh5-repository_1.0_all.deb
RUN dpkg -i cdh5-repository_1.0_all.deb
RUN apt-get update -y
RUN apt-get install -y --allow-unauthenticated hadoop-hdfs-namenode=$HADOOP_VER* hadoop-hdfs-datanode=$HADOOP_VER* hadoop-yarn-resourcemanager=$HADOOP_VER* hadoop-yarn-nodemanager=$HADOOP_VER* hadoop-mapreduce-historyserver=$HADOOP_VER*
RUN apt-get install -y --allow-unauthenticated impala=$IMPALA_VER* impala-server=$IMPALA_VER* impala-shell=$IMPALA_VER* impala-catalog=$IMPALA_VER* impala-state-store=$IMPALA_VER*

RUN mkdir -p /var/run/hdfs-sockets; \
    chown hdfs.hadoop /var/run/hdfs-sockets
RUN mkdir -p /data/dn/
RUN chown hdfs.hadoop /data/dn

ADD etc/supervisord.conf /etc/
ADD etc/hadoop/conf/core-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/mapred-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/core-site.xml /etc/impala/conf/
ADD etc/hadoop/conf/hdfs-site.xml /etc/impala/conf/
ADD etc/impala/conf/hive-site.xml /etc/impala/conf/

# Various helper scripts
ADD bin/start-hdfs.sh ./
ADD bin/start-impala.sh ./
ADD bin/start-yarn.sh ./
ADD bin/supervisord-bootstrap.sh ./
ADD bin/wait-for-it.sh ./
RUN chmod +x ./*.sh
RUN chown mapred:mapred /var/log/hadoop-mapreduce

# Impala Ports
EXPOSE 21000 21050 22000 23000 24000 25010 26000 28000

##########################
# Hadoop Ports
##########################
# hdfs-default.xml ports
EXPOSE 50010 50020 50070 50075 50090 50091 50100 50105 50475 50470 8020 8485 8480 8481
# mapred-default.xml ports
EXPOSE 50030 50060 13562 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8040 8042 8046 8047 8088 8090 8188 8190 8788 10200

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
