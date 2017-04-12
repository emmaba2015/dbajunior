-- Stale stats in a schema
declare
    m_objects   dbms_stats.ObjectTab;
begin
   dbms_stats.gather_schema_stats(
        ownname => '&schema_name',
        options => 'LIST STALE',
        objlist => m_objects
    );
 
    dbms_output.new_line;
    dbms_output.put_line('--------------------');
    for i in 1..m_objects.count loop
        dbms_output.put(rpad(m_objects(i).ownname,10));
        dbms_output.put(rpad(m_objects(i).objname,32));
        dbms_output.put(rpad(nvl(m_objects(i).partname,' '),32));
        dbms_output.put(rpad(nvl(m_objects(i).subpartname,' '),32));
        dbms_output.put(rpad(m_objects(i).objtype,6));
        dbms_output.new_line;
    end loop;
	dbms_output.put_line('--------------------');
    dbms_output.put_line('Stale: ' || m_objects.count);
end;
/
