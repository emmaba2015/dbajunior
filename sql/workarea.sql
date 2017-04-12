-- Workarea Size Information
-- http://docs.oracle.com/cd/E16655_01/server.121/e15857/tune_pga.htm#TGDBA483
SELECT TO_NUMBER(DECODE(sid, 65535, null, sid)) sid,
       operation_type operation,
       TRUNC(expected_size/1024/1024) esize,
       TRUNC(actual_mem_used/1024/1024) mem,
       TRUNC(max_mem_used/1024/1024) "max mem",
       number_passes pass,
       TRUNC(TEMPSEG_SIZE/1024/1024) tsize
  FROM V$SQL_WORKAREA_ACTIVE
 ORDER BY 1,2;
