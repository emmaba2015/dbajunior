-- Change Container into PDB 3
declare
  pdb VARCHAR2(30);
begin
  select PDB_NAME into pdb from cdb_pdbs where con_id=4;
  execute immediate 'alter session set container='||pdb;
end;
/
show con_name
