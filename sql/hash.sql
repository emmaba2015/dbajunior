Show the hash value, SQL_ID and child number of previously

select 
    prev_hash_value                         hash_value
  , prev_sql_id                             sql_id
  , prev_child_number                       child_number
--  , to_char(prev_hash_value, 'XXXXXXXX')    hash_hex
from 
    v$session 
where 
    sid = (select sid from v$mystat where rownum = 1)
/
