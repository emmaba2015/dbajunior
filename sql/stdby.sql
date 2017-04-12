select process,STATUS,THREAD#,SEQUENCE# ,BLOCK#,BLOCKS*512/1024/1024,DELAY_MINS from v$managed_standby;
