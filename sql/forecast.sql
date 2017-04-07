-- Tablespace Forecast from AWR
COL "Size MB" FORMAT 99,999,999.99
COL "Used MB" FORMAT 99,999,999.99
COL "Used %" FORMAT 99,999,999.99
COL "Used Next 7d (MB)" FORMAT 99,999,999.99
COL "Used Next 30d (MB)" FORMAT 99,999,999.99
COL "Used Next 6m (MB)" FORMAT 99,999,999.99
COL "Used Next 1y (MB)" FORMAT 99,999,999.99
WITH rl AS (
  SELECT
    UPPER(tbsstat.TSNAME) TABLESPACE_NAME,
	BLOCK_SIZE,
    REGR_SLOPE(TABLESPACE_USEDSIZE, (TO_DATE(TO_CHAR (END_INTERVAL_TIME, 'YYYY-MON-DD HH24:MI:SS'), 'YYYY-MON-DD HH24:MI:SS') -
      TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) * 86400) SLOPE,
	REGR_INTERCEPT(TABLESPACE_USEDSIZE, (TO_DATE(TO_CHAR (END_INTERVAL_TIME, 'YYYY-MON-DD HH24:MI:SS'), 'YYYY-MON-DD HH24:MI:SS')  - 
      TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) * 86400) YINTERCEPT
  FROM
    DBA_HIST_SNAPSHOT snap,
    DBA_HIST_TBSPC_SPACE_USAGE usage,
    DBA_HIST_TABLESPACE_STAT tbsstat,
	DBA_TABLESPACES tbs
  WHERE
    snap.SNAP_ID = tbsstat.SNAP_ID
    AND tbsstat.SNAP_ID = usage.SNAP_ID
    AND tbsstat.TS# = usage.TABLESPACE_ID
	AND usage.TABLESPACE_ID = tbsstat.TS#
	AND snap.END_INTERVAL_TIME > sysdate-&history_days
  GROUP BY 
    UPPER(tbsstat.TSNAME),
	BLOCK_SIZE
  -- Discarding tablespaces with negative growth (e.g. UNDO)
  HAVING REGR_SLOPE(TABLESPACE_USEDSIZE, (TO_DATE(TO_CHAR (END_INTERVAL_TIME, 'YYYY-MON-DD HH24:MI:SS'), 'YYYY-MON-DD HH24:MI:SS') -
      TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) * 86400) >= 0
),
tbs as (
  SELECT /*+ first_rows */ d.tablespace_name "Tablespace", NVL(a.bytes / 1024 / 1024, 0) "Size MB", NVL(a.bytes - NVL(f.bytes, 0), 0) / 1024 / 1024 "Used MB", NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0) "Used %",
  a.autoext "Autoextend", NVL(f.bytes, 0) / 1024 / 1024 "Free MB", a.maxbytes / 1024 / 1024 "Max MB", d.status "STAT", a.count "# of datafiles", d.contents "TS type", d.extent_management "EXT MGMT",
  d.segment_space_management "Seg Space MGMT" FROM sys.dba_tablespaces d,(select tablespace_name, sum(bytes) bytes, count(file_id) count, decode(sum(decode(autoextensible, 'NO', 0, 1)), 0, 'NO', 'YES') autoext,
  sum(decode(autoextensible, 'YES',greatest(maxbytes,bytes),'NO', bytes)) maxbytes from dba_data_files group by tablespace_name) a, (select tablespace_name, sum(bytes) bytes from dba_free_space
  group by tablespace_name) f WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = f.tablespace_name(+) AND NOT d.contents = 'UNDO' AND NOT (d.extent_management = 'LOCAL' AND
  d.contents = 'TEMPORARY') AND d.tablespace_name like '%%' UNION ALL SELECT d.tablespace_name, NVL(a.bytes / 1024 / 1024, 0), NVL(t.bytes, 0) / 1024 / 1024, NVL(t.bytes / a.bytes * 100, 0), a.autoext,
  (NVL(a.bytes, 0) / 1024 / 1024 - NVL(t.bytes, 0) / 1024 / 1024), a.maxbytes / 1024 / 1024, d.status, a.count, d.contents, d.extent_management, d.segment_space_management FROM sys.dba_tablespaces d,
  (select tablespace_name, sum(bytes) bytes, count(file_id) count, decode(sum(decode(autoextensible, 'NO', 0, 1)), 0, 'NO', 'YES') autoext, sum(decode(autoextensible, 'YES',greatest(maxbytes,bytes),'NO', bytes)) maxbytes
  from dba_temp_files group by tablespace_name) a, (select ss.tablespace_name, sum((ss.used_blocks * ts.blocksize)) bytes from gv$sort_segment ss, sys.ts$ ts where ss.tablespace_name = ts.name
  group by ss.tablespace_name) t WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = t.tablespace_name(+) AND d.extent_management = 'LOCAL' AND d.contents = 'TEMPORARY' and
  d.tablespace_name like '%%' UNION ALL SELECT d.tablespace_name, NVL(a.bytes / 1024 / 1024, 0), NVL(u.bytes, 0) / 1024 / 1024, NVL(u.bytes / a.bytes * 100, 0), a.autoext,
  NVL(a.bytes - NVL(u.bytes, 0), 0) / 1024 / 1024, a.maxbytes / 1024 / 1024, d.status, a.count, d.contents, d.extent_management, d.segment_space_management FROM sys.dba_tablespaces d, (SELECT tablespace_name,
  SUM(bytes) bytes, COUNT(file_id) count, decode(sum(decode(autoextensible, 'NO', 0, 1)), 0, 'NO', 'YES') autoext, sum(decode(autoextensible, 'YES',greatest(maxbytes,bytes),'NO', bytes)) maxbytes
  FROM dba_data_files GROUP BY tablespace_name) a, (SELECT tablespace_name, SUM(bytes) bytes FROM (SELECT tablespace_name, sum(bytes) bytes, status from dba_undo_extents WHERE status = 'ACTIVE'
  group by tablespace_name, status UNION ALL SELECT tablespace_name, sum(bytes) bytes, status from dba_undo_extents WHERE status = 'UNEXPIRED' group by tablespace_name, status)
  group by tablespace_name) u WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = u.tablespace_name(+) AND d.contents = 'UNDO' AND d.tablespace_name LIKE '%%' ORDER BY 1)
SELECT
  tbs."Tablespace",
  tbs."Size MB",
  tbs."Used MB",
  tbs."Used %",
  ROUND(((((SYSDATE+7) - TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) *
             86400) * rl.SLOPE + rl.YINTERCEPT)*rl.BLOCK_SIZE/1024/1024, 2) "Used Next 7d (MB)",
  ROUND(((((SYSDATE+30) - TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) *
             86400) * rl.SLOPE + rl.YINTERCEPT)*rl.BLOCK_SIZE/1024/1024, 2) "Used Next 30d (MB)",
  ROUND(((((SYSDATE+182) - TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) *
             86400) * rl.SLOPE + rl.YINTERCEPT)*rl.BLOCK_SIZE/1024/1024, 2) "Used Next 6m (MB)",
  ROUND(((((SYSDATE+365) - TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) *
             86400) * rl.SLOPE + rl.YINTERCEPT)*rl.BLOCK_SIZE/1024/1024, 2) "Used Next 1y (MB)"
FROM
  tbs LEFT OUTER JOIN rl ON tbs."Tablespace" = rl.tablespace_name
/
