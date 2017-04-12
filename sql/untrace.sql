-- Untrace sessions by condition (Generate statements)
select
    'exec dbms_monitor.session_trace_disable('||sid||','||serial#||');' command_to_run
from
    v$session
where
    &condition
/
