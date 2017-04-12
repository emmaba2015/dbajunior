-- SGA Info
select
  (select round(sum(bytes/1024/1024),0) from v$sgainfo where not REGEXP_LIKE(lower(name),'maximum|free|granule|startup')) "USED (MB)",
  (select bytes/1024/1024 from v$sgainfo where lower(name) like 'free%') "FREE (MB)",
  (select bytes/1024/1024 from v$sgainfo where lower(name) like 'maximum%') "MAX (MB)"
from dual;
