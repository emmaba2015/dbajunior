-- See UNDO being used by all session
col sid format 99999
col oracle_username format a15
col owner format a16
col object_name format a30
col object_type format a10
col rbs_segment format a25
col tablespace format a20
SELECT gvs.SID,
       -- glo.oracle_username,
       dbo.owner       owner,
       dbo.object_name object_name,
       -- dbo.object_type object_type,
       drs.segment_name rbs_segment,
       -- 2nd byte 8 means Rollback / 0 means normal transaction
       -- i.e. 00000E83 -> Rollback
       -- to_char( 3715, '0000000X' ) "FLAG",
       drs.tablespace_name "Tablespace",
       gvt.used_urec "# of Records",
       gvt.used_ublk "# of Blocks",
       round(gvt.used_ublk * p.value / 1024 / 1024) "Undo MB"
  FROM gv$locked_object  glo,
       dba_objects       dbo,
       dba_rollback_segs drs,
       gv$transaction    gvt,
       gv$session        gvs,
       v$parameter       p
 WHERE glo.object_id = dbo.object_id
   AND glo.xidusn = drs.segment_id
   AND glo.xidusn = gvt.xidusn
   AND glo.xidslot = gvt.xidslot
   AND gvt.addr = gvs.taddr
   AND p.name = 'db_block_size'
 ORDER BY gvt.used_ublk
/
