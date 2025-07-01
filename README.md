# Apache Hive and HBase Docker Environment

DISCLAIMER:
This Docker image is intended only for development, testing, and sandbox experimentation. It is not suitable for production use due to its minimal configuration and lack of fault tolerance, security hardening, and resource isolation.

⸻

## 📦 Required Software (Manual Download)

Before building the image, you must manually download the following official Apache binary distributions:

  -	apache-hive-3.1.3-bin.tar.gz
  -	hbase-2.4.15-bin.tar.gz
  -	hadoop-2.7.7.tar.gz

Place all three .tar.gz archives in the same directory as the Dockerfile (i.e. the root of this repository) before building the image. The Docker build process expects to find them locally and will fail if they are not present.

⸻

## 🛠 Build the Docker Image

Once the .tar.gz files are placed in the directory, you can build the image using:

```bash
docker build -t hive-hbase-standalone .
```


This will install and configure:

	- Apache Hadoop (core runtime)
	- Apache Hive with HiveServer2
	- Apache HBase with Thrift and embedded web UI
	- A pseudo-distributed HDFS instance to support Hive and HBase

⸻

## 🚀 Run the Container

Launch the container with:

```bash
docker run -d \
  -p 10000:10000 \  # HiveServer2 JDBC/Thrift
  -p 9090:9090 \    # HBase Thrift API
  -p 16010:16010 \  # HBase Web UI
  hive-hbase-standalone
```

```bash
docker run -d -p 10000:10000 -p 9090:9090 -p 16010:16010 hive-hbase-standalone
```

⸻

## 🔗 Exposed Services
	
  
  - HiveServer2 (port 10000) — JDBC/Thrift endpoint (used by Beeline, PyHive, etc.)
  - HBase Thrift (port 9090) — API for programmatic access (e.g., via HappyBase)
  - HBase Web UI (port 16010) — Web interface for monitoring HBase

⸻

## 📓 Additional Notes
	
  -	Hive and HBase are configured to share the same Hadoop pseudo-distributed HDFS layer.
  -	ZooKeeper is bundled in standalone mode and will run inside the container, unless externalized.
  -	Hive is preconfigured to query HBase tables via HBaseStorageHandler. Ensure that HBase tables exist and are correctly mapped using CREATE EXTERNAL TABLE ... STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'.
