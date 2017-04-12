col sid format 99999
col serial format 99999
col machine format a15
col event format a27
col wait_class format a12
col logon format a14
col client_identifier format a10
col hora_ini format a10
col sql_text format a31
col ET format A5
col program format a20
col ospid format a5
col procc format a5
col I format 9
col username format a8
col schemaname format a9
select ses.sid,
       ses.serial# serial,
       ses.inst_id I,
       ses.username,
	   ses.schemaname,
       ses.program,
       DECODE(ses.state,'WAITING',ses.event,'WORKING On CPU') event,
       ses.status,
       case 
	     when last_call_et>86400 then to_char(round(last_call_et/86400,1))||'d'
         when last_call_et>3600  then to_char(round(last_call_et/3600,1)) ||'h'
		 when last_call_et>60    then to_char(round(last_call_et/60,1)) ||'m'
       else to_char(last_call_et) END ET,
       --substr((select sql_text from gv$sql vsql where vsql.sql_id=ses.sql_id and rownum = 1),0,150) sql_text
       substr(REPLACE(sq.sql_text, CHR(13), ''),0,150) sql_text,
       ses.sql_id
-- Optional
--     ,sq.plan_hash_value
--     ,logon_time
--     ,ses.wait_class
--     ,ses.client_identifier
--     ,ses.osuser
--     ,p.spid ospid
--     ,ses.process procc
  from gv$session ses 
  left outer join gv$sql sq on (ses.sql_id = sq.sql_id and sq.inst_id = ses.inst_id and sq.child_number = ses.sql_child_number) 
  ,gv$process p
  where p.addr = ses.paddr
  and p.inst_id = ses.inst_id
  and ses.type <> 'BACKGROUND'
  -- and ses.program like '%PMON%'
  and ses.username <> 'DBSNMP'
  and ses.status <> 'INACTIVE'
  and event not like 'LogMiner %'
 order by last_call_et;
