col capture_name format a30
select b.capture_name,min(a.sequence#), b.status
  from dba_capture b, v$archived_log a
where b.first_scn between a.first_change# and a.next_change#
group by capture_name, b.status;
