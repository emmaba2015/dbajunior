-- Session being blocked by other sessions
select  'SID ' || l1.sid ||' is blocking  ' || l2.sid blocking
from    v$lock l1, v$lock l2
where   l1.block =1 and l2.request > 0
and     l1.id1=l2.id1
and     l1.id2=l2.id2
/
