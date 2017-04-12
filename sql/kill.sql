select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate -- '
||username||'@'||machine||' ('||program||');' commands_to_verify_and_run
from gv$session
where &1
/
