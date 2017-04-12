SELECT
extractvalue(value(a), '.') sqlprofile_hints
FROM sqlobj$ o
,sqlobj$data d
,table(xmlsequence(extract(xmltype(d.comp_data),'/outline_data/hint'))) a
WHERE o.name = '&sql_profile'
AND o. plan_id = d.plan_id
AND o.signature = d.signature
AND o.category = d.category
AND o.obj_type = d.obj_type;
