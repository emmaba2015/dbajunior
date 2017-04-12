select
to_number(substr(dbms_session.unique_session_id,1,4),'XXXX') mysid
from dual
/
