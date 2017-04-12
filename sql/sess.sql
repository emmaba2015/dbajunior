-- Sessions connected other than BACKGROUND
col program format a50;
col machine format a30;
col username format a25;
select program ,machine, username, status, count (1)
from gv$session where type<>'BACKGROUND'
--and status='ACTIVE'
group by program ,machine, username, status
order by 1
/
