FROM openjdk:8-jdk

WORKDIR /opt

# disable HBase embedded ZooKeeper (we launch ZK separately in bootstrap.sh)
ENV HBASE_MANAGES_ZK=false

# Hadoop, HBase e Hive
COPY hadoop-2.7.7.tar.gz ./
COPY hbase-2.4.15-bin.tar.gz ./
COPY apache-hive-3.1.3-bin.tar.gz ./

RUN tar -xzf hadoop-2.7.7.tar.gz && mv hadoop-2.7.7 hadoop \
 && tar -xzf hbase-2.4.15-bin.tar.gz && mv hbase-2.4.15 hbase \
 && tar -xzf apache-hive-3.1.3-bin.tar.gz && mv apache-hive-3.1.3-bin hive \
 && echo 'export HBASE_MANAGES_ZK=false' >> /opt/hbase/conf/hbase-env.sh \
 && echo 'export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -Dhbase.master.manage.zookeeper=false"' >> /opt/hbase/conf/hbase-env.sh

# Configurazioni
COPY core-site.xml   /opt/hadoop/etc/hadoop/core-site.xml
COPY hdfs-site.xml   /opt/hadoop/etc/hadoop/hdfs-site.xml
COPY hbase-site.xml  /opt/hbase/conf/hbase-site.xml
COPY hive-site.xml   /opt/hive/conf/hive-site.xml

# Script di bootstrap
COPY bootstrap.sh /opt/bootstrap.sh
RUN chmod +x /opt/bootstrap.sh

EXPOSE 9000 50070     
EXPOSE 16010          
EXPOSE 16030         
EXPOSE 2181 2182     
EXPOSE 9090           
EXPOSE 10000          

CMD ["/opt/bootstrap.sh"]
