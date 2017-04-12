-- Explain Adaptive Plan from SQL_ID within Cursor Cache with 
select * from table(dbms_xplan.display_cursor('&sql_id',format => 'adaptive'));
