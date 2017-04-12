-- Trace sessions by condition (Generate statements)
select 
    'exec dbms_monitor.session_trace_enable('||sid||','||serial#||',waits=>true,binds=>true);' command_to_run
from
    v$session
where
    &condition
/
