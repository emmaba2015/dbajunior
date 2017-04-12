col sid_serial format a12
col username format a30
SELECT S.sid || ',' || S.serial# sid_serial, S.username, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
COUNT(1) statements
FROM v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
WHERE T.session_addr = S.saddr
AND S.paddr = P.addr
AND T.tablespace = TBS.tablespace_name
GROUP BY S.sid, S.serial#, S.username, TBS.block_size, T.tablespace
ORDER BY mb_used;
