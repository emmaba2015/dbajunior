col ksppinm format a50
col ksppstvl format a15
col KSPPDESC format a60
select 
  ksppinm,
  ksppstvl,
  ksppdesc
from 
  x$ksppi a, 
  x$ksppsv b 
where 
  a.indx=b.indx and 
  lower(ksppinm) like lower ('%&param%') and
  substr(ksppinm,1,1) = '_'
order by 1;
