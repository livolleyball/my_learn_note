SHOW ENGINE INNODB STATUS;  -- 查看当前锁请求的信息
SELECT @@tx_isolation;      -- 查看事务隔离级别


SELECT * FROM information_schema.`INNODB_TRX`;                  -- 事务信息表
SELECT * FROM information_schema.innodb_locks;                  -- 锁信息表
SELECT * FROM information_schema.innodb_lock_waits;             -- 锁等待表

-- 三张表的关联关系 
SELECT 
  r.trx_id AS waiting_trx_id,
  r.`trx_mysql_thread_id` AS waiting_thread,
  r.`trx_query` AS waiting_query,
  b.trx_id AS blocking_trx_id,
  b.`trx_mysql_thread_id` AS blocking_thread,
  b.`trx_query` AS blocking_query 
FROM
  information_schema.innodb_lock_waits w 
  INNER JOIN information_schema.`INNODB_TRX` b 
    ON w.`blocking_trx_id` = B.`trx_id` 
  INNER JOIN information_schema.`INNODB_TRX` r 
    ON w.`requesting_trx_id` = r.trx_id 
