FROM parrotstream/centos-openjdk

MAINTAINER Matteo Capitanio <matteo.capitanio@gmail.com>

USER root

ADD cloudera-cdh5.repo /etc/yum.repos.d/
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/5/x86_64/cdh/RPM-GPG-KEY-cloudera
RUN yum install -y impala impala-server impala-shell impala-catalog impala-state-store
RUN yum clean all

RUN mkdir -p /var/run/hdfs-sockets; \
    chown hdfs.hadoop /var/run/hdfs-sockets
RUN mkdir -p /data/dn/
RUN chown hdfs.hadoop /data/dn

RUN groupadd supergroup; \ 
    usermod -a -G supergroup impala; \
    usermod -a -G hdfs impala; \
    usermod -a -G supergroup hive; \
    usermod -a -G hdfs hive

WORKDIR /

ADD etc/supervisord.conf /etc/
ADD etc/hadoop/conf/core-site.xml /etc/impala/conf/
ADD etc/hadoop/conf/hdfs-site.xml /etc/impala/conf/
ADD etc/impala/conf/hive-site.xml /etc/impala/conf/
ADD etc/impala/conf/hbase-site.xml /etc/impala/conf/

# Various helper scripts
ADD bin/start-impala.sh /
ADD bin/supervisord-bootstrap.sh /
ADD bin/wait-for-it.sh /
RUN chmod +x ./*.sh

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
