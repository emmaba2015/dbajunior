column file_name format a65
column tablespace_name format a20 
set lines 500
set pages 500
select
            tablespace_name, 
            file_id, 
            file_name, 
            dfsizeMB, 
            hwmMB, 
            dffreeMB, 
            trunc((dffreeMB/dfsizeMB)*100,2) "% Free", 
            trunc(dfsizeMB-hwmMB,2) "Resizeble"
   from
   ( 
      select
           df.tablespace_name tablespace_name, 
           df.file_id file_id, 
           df.file_name file_name, 
           df.bytes/1024/1024 dfsizeMB, 
           trunc((ex.hwm*(ts.block_size))/1024/1024,2) hwmMB, 
           dffreeMB 
      from
           dba_data_files df, 
           dba_tablespaces ts, 
      ( 
           select file_id, sum(bytes/1024/1024) dffreeMB 
           from dba_free_space 
           group by file_id 
      ) free, 
      ( 
           select file_id, max(block_id+blocks) hwm 
           from dba_extents 
           group by file_id 
      ) ex 
      where df.file_id = ex.file_id 
      and df.tablespace_name = ts.tablespace_name 
      and df.file_id = free.file_id (+) 
      order by df.tablespace_name, df.file_id 
    )  
/
