-- Get PID from specific SID
select a.username, a.osuser, b.spid
from v$session a, v$process b
where a.paddr = b.addr
and a.username is not null and a.sid=&sid;
