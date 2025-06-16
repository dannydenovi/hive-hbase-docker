#!/bin/bash
set -e

export HADOOP_HOME=/opt/hadoop
export HBASE_HOME=/opt/hbase
# export HBASE_MANAGES_ZK=false

export HIVE_HOME=/opt/hive
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin:$HIVE_HOME/bin

export HBASE_OPTS="-Djava.net.preferIPv4Stack=true -Dhbase.manages.zookeeper=false"
export HBASE_MASTER_OPTS="$HBASE_OPTS"
export HBASE_REGIONSERVER_OPTS="$HBASE_OPTS"
# Use the standalone ZooKeeper started above; do not start an embedded one

# Ensure HBase logs directory exists
mkdir -p $HBASE_HOME/logs
chown -R root:root $HBASE_HOME/logs

# 1) HDFS pseudo-distributed
mkdir -p $HADOOP_HOME/hdfs/namenode $HADOOP_HOME/hdfs/datanode $HADOOP_HOME/logs
chown -R root:root $HADOOP_HOME/logs
hdfs namenode -format -force
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
echo "[INFO] HDFS avviato"
sleep 5

# 2) Storage HBase
mkdir -p /opt/hbase-data

# 3) ZooKeeper stand-alone di HBase
$HBASE_HOME/bin/hbase-daemon.sh start zookeeper
echo "[INFO] HBase ZooKeeper avviato"
sleep 5

# 4) Master + RegionServer
$HBASE_HOME/bin/hbase-daemon.sh start master
$HBASE_HOME/bin/hbase-daemon.sh start regionserver
echo "[INFO] HBase Master e RegionServer avviati"
sleep 10

# 5) Metastore Hive (Derby embedded)
$HIVE_HOME/bin/schematool -dbType derby -initSchema
echo "[INFO] Schema metastore Hive inizializzato"

# 6) HiveServer2
$HIVE_HOME/bin/hiveserver2 &
echo "[INFO] HiveServer2 avviato"

# 7) Thrift framed+threadpool su 9090
$HBASE_HOME/bin/hbase-daemon.sh start thrift
echo "[INFO] HBase Thrift Server avviato su porta 9090"

# 8) Mantieni vivo
tail -f $HBASE_HOME/logs/hbase--master-*.out
