-- Show which latch occupies a given memory address and its stats

column la_name heading NAME format a40
column la_chld heading CHLD format 99999

select 
    addr, latch#, 0 la_chld, name la_name, gets, immediate_gets igets, 
    misses, immediate_misses imisses, spin_gets spingets, sleeps, wait_time
from v$latch_parent
where addr = hextoraw(lpad('&addr', (select vsize(addr)*2 from v$latch_parent where rownum = 1) ,0))
union all
select 
    addr, latch#, child#, name la_name, gets, immediate_gets igets, 
    misses, immediate_misses imisses, spin_gets spingets, sleeps, wait_time 
from v$latch_children
where addr = hextoraw(lpad('&addr', (select vsize(addr)*2 from v$latch_children where rownum = 1) ,0))
/
