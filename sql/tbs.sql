-- Script to Monitor Tablespace Usage and Information (Doc ID 1902106.1)
COL "Size MB"  FORMAT 99,999,999.99
COL "Used MB"  FORMAT 99,999,999.99
COL "Max MB"  FORMAT 99,999,999.99
COL "Used %"  FORMAT 999.99
COL "Free MB"  FORMAT 99,999,999.99
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
group by tablespace_name) u WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = u.tablespace_name(+) AND d.contents = 'UNDO' AND d.tablespace_name LIKE '%%' ORDER BY 1;
