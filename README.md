# Apache Hive and HBase Docker

Build the image with:

```bash
docker build -t hive-hbase-standalone .
```

Then run the image with: 

```bash
docker run -d -p 10000:10000 -p 9090:9090 -p 16010:16010 hive-hbase-standalone
```