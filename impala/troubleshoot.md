> * has invalid file metadata at file offset 190517561

```
In Impala 3.2 and higher, file handle caching also applies to remote HDFS file handles. This is controlled by the cache_remote_file_handles flag for an impalad. It is recommended that you use the default value of true as this caching prevents your NameNode from overloading when your cluster has many remote HDFS reads.

Because this feature only involves HDFS data files, it does not apply to non-HDFS tables, such as Kudu or HBase tables, or tables that store their data on cloud services such as S3 or ADLS.

The feature is enabled by default with 20,000 file handles to be cached. To change the value, set the configuration option  max_cached_file_handles  to a non-zero value for each impalad daemon. From the initial default value of 20000, adjust upward if NameNode request load is still significant, or downward if it is more important to reduce the extra memory usage on each host. Each cache entry consumes 6 KB, meaning that caching 20,000 file handles requires up to 120 MB on each Impala executor. The exact memory usage varies depending on how many file handles have actually been cached; memory is freed as file handles are evicted from the cache.

If a manual HDFS operation moves a file to the HDFS Trashcan while the file handle is cached, Impala still accesses the contents of that file. This is a change from prior behavior. Previously, accessing a file that was in the trashcan would cause an error. This behavior only applies to non-Impala methods of removing HDFS files, not the Impala mechanisms such as TRUNCATE TABLE or DROP TABLE.
If files are removed, replaced, or appended by HDFS operations outside of Impala, the way to bring the file information up to date is to run the REFRESH statement on the table.

File handle cache entries are evicted as the cache fills up, or based on a timeout period when they have not been accessed for some time.
```
>> * 设置 cache_remote_file_handles = true 防止当集群有很多远程HDFS读时，发生过载
>> * 远程文件特性只适合于 HDFS 数据文件。 不适合于 KUDO HBASE 表，以及 S3
