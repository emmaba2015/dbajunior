BEGIN
  DBMS_APPLICATION_INFO.SET_MODULE ('&module_name','&action_name');
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO ('&client_info');
END;
/
