# **docker-impala**
___

### Description
___

This image runs [*Apache Impala*](https://impala.incubator.apache.org/) on HDFS.

The *latest* tag of this image is build with the Cloudera Impala distribution.

You can pull it with:

    docker pull mcapitanio/impala


You can also find other images based on different Apache HBase releases, using a different tag in the following form:

    docker pull mcapitanio/impala:[impala-kudu-release]

Run with Docker Compose:

    docker-compose -p docker up

Setting the project name to *docker* (or something else) with the **-p** option is useful to run different containers belonging to the same network and having the relative hostnames shared.

IMPORTANT: To run this Docker you also need to pull the [*Hive*](https://hub.docker.com/r/mcapitanio/hive/) and [*Hadoop*](https://hub.docker.com/r/mcapitanio/hadoop/) images and following the instructions. Impala searches for the Hive Metastore and Hadoop HDFS to start.

Once started you'll be able to access to the following UIs:

| **HBase Web UIs**           |**URL**                    |
|:----------------------------|:--------------------------|
| *Impala State Store Server* | http://localhost:25010    |
| *Impala Catalog Server*     | http://localhost:25020    |
| *Impala Server Daemon*      | http://localhost:25000    |
