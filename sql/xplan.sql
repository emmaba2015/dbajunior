-- Explain plan from SQL_ID within Cursor Cache
select * from table(dbms_xplan.display_cursor('&sql_id',null,'ALLSTATS LAST +PEEKED_BINDS +PARTITION'));
