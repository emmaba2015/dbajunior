-- Ocultar las operaciones completadas
SELECT sid, serial#, context, sofar, totalwork,
      round(sofar/totalwork*100,2) "% Complete", time_remaining
FROM GV$SESSION_LONGOPS
WHERE opname LIKE 'RMAN:%'
      AND opname NOT LIKE 'RMAN: aggregate%'
      AND totalwork != 0
   AND sofar!=totalwork;
