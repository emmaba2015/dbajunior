column ind_table_name1 heading TABLE_NAME format a30
column ind_index_name1 heading INDEX_NAME format a30
column ind_table_owner1 heading TABLE_OWNER format a20
column ind_column_name1 heading COLUMN_NAME format a30
column ind_dsc1 heading DSC format a4
column ind_column_position1 heading POS# format 999

break on ind_table_owner1 skip 1 on ind_table_name1 on ind_index_name1

undefine index_name

select 
    c.table_owner ind_table_owner1,
    c.table_name ind_table_name1, 
    c.index_name ind_index_name1, 
    c.column_position ind_column_position1, 
    c.column_name ind_column_name1, 
    decode(c.descend,'DESC','DESC',null) ind_dsc1
from 
    dba_ind_columns c
where (
    UPPER(table_name) LIKE 
                UPPER(CASE 
                    WHEN INSTR('&&index_name','.') > 0 THEN 
                        SUBSTR('&&index_name',INSTR('&&index_name','.')+1)
                    ELSE
                        '&index_name'
                    END
                     )
)
OR (
    UPPER(index_name) LIKE 
                UPPER(CASE 
                    WHEN INSTR('&&index_name','.') > 0 THEN 
                        SUBSTR('&&index_name',INSTR('&&index_name','.')+1)
                    ELSE
                        '&&index_name'
                    END
                     )
)
order by
    c.table_owner,
    c.table_name,
    c.index_name,
    c.column_position
;
