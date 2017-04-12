col sid format a17
col "USER (SCHEMA)" format a20
col schemaname format a20
col osuser format a15
col program format a35
col machine format a20
col type format a10
col "MODULE|ACTION|CLIENT_INFO" format a40
col client format a15
select
  sid||','||serial#||',@'||inst_id "SID", 
  decode (username, schemaname, username, username||' ('||schemaname||')') "USER (SCHEMA)",
  osuser,
  program,
  machine,
  type,
  module||'|'||action||'|'||client_info "MODULE|ACTION|CLIENT_INFO",
  client_identifier "CLIENT"
from
  gv$session
where
  &cond
order by
  inst_id, username, schemaname, osuser, program, machine, sid||','||serial#||',@'||inst_id
/
