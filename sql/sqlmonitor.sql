set long 9999999
SET LINESIZE 400
COLUMN sql_text FORMAT A80
SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET TRIM ON
SET TRIMSPOOL ON
SELECT DBMS_SQLTUNE.report_sql_monitor(
  sql_id       => '&sql_id',
  type         => 'TEXT',
  report_level => 'ALL') AS report
FROM dual;
