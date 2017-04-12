-- Show Longop Sessions (not only RMAN)
COL OPNAME FORMAT a33
COL TARGET_DESC FORMAT a30
COL UNITS FORMAT A10
COL "% Done" FORMAT 99.99
COL SID FORMAT 99999
SELECT sid, serial#, sofar, totalwork, units, opname, target_desc, sql_id,
      round(sofar/totalwork*100,2) "% Done", time_remaining
FROM GV$SESSION_LONGOPS
WHERE totalwork != 0
   AND round(sofar/totalwork*100,2) < 100
   order by sid;
