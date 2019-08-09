FROM parrotstream/centos-openjdk:8

MAINTAINER Matteo Capitanio <matteo.capitanio@gmail.com>

USER root

ADD cloudera-cdh6.repo /etc/yum.repos.d/
RUN rpm --import https://archive.cloudera.com/cdh6/6.3.0/redhat7/yum/RPM-GPG-KEY-cloudera
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
ADD etc/hadoop/conf/mapred-site.xml /etc/impala/conf/
ADD etc/impala/conf/hive-site.xml /etc/impala/conf/

# Various helper scripts
ADD bin/start-impala.sh /
ADD bin/supervisord-bootstrap.sh /
ADD bin/wait-for-it.sh /
RUN chmod +x ./*.sh

EXPOSE 21000 21050 25000 25010 25020

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
