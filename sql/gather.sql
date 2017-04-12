-- Quick schema stats collection for STALE objects only
exec dbms_stats.gather_schema_stats('&schema', degree=>8, method_opt=>'FOR ALL COLUMNS SIZE AUTO', no_invalidate=>FALSE, options=>'GATHER STALE');
