DECLARE
stmt_task VARCHAR2(100);
t_name    VARCHAR2(100);
s_id      VARCHAR2(100);
BEGIN
s_id   := '&sql_id';
t_name := s_id || '_' || TO_CHAR(SYSDATE,'YYYYMMDD_MISS');
stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(
      task_name => t_name
  ,   sql_id => s_id);
DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER (
      task_name => t_name
  ,   parameter => 'TIME_LIMIT'
  ,   value     => 300
);
DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name => t_name);
DBMS_OUTPUT.PUT_LINE('SET PAGES 512 LINES 140');
DBMS_OUTPUT.PUT_LINE('SET LONG 99999');
DBMS_OUTPUT.PUT_LINE('COL RECOMMENDATIONS FORMAT A140');
DBMS_OUTPUT.PUT_LINE('SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK('''||t_name||''') AS recommendations FROM dual;');
END;
/
