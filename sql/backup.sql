alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
col TIME_TAKEN_DISPLAY format a20
select input_type, start_time, end_time, time_taken_display,
input_bytes/1024/1024/1024 INPUTGB, output_bytes/1024/1024/1024 OUTPUTGB,
status, compression_ratio, output_bytes_per_sec/1024/1024 OUTPUT_MB_PER_SEC  from v$rman_backup_job_details;
