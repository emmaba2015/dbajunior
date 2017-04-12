-- Get SID from specific SPID
select s.sid, s.username, s.machine, s.sql_hash_value, p.spid
from v$session s, v$process p
where s.paddr = p.addr
and s.username is not null and p.spid=&spid
/
