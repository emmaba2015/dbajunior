-- Explain plan from SQL_ID within Cursor Cache
select * from table(dbms_xplan.display_awr('&sql_id'));
