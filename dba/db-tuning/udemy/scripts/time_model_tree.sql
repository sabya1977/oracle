col STAT_NAME format a60
SELECT LPAD(' ', 2*level-1)||STAT_NAME STAT_NAME, 
       TRUNC(VALUE/1000000,2) SECONDS 
  FROM (
SELECT 0 id, 9 pid, null STAT_NAME, null value FROM dual union
SELECT DECODE(STAT_NAME,'DB time',10) ID,
       DECODE(STAT_NAME,'DB time',0) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'DB time' union
SELECT DECODE(STAT_NAME,'DB CPU',20) ID,
       DECODE(STAT_NAME,'DB CPU',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'DB CPU' union
SELECT DECODE(STAT_NAME,'connection management call elapsed time',21) ID,
       DECODE(STAT_NAME,'connection management call elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'connection management call elapsed time' union
SELECT DECODE(STAT_NAME,'sequence load elapsed time',22) ID,
       DECODE(STAT_NAME,'sequence load elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'sequence load elapsed time' union
SELECT DECODE(STAT_NAME,'sql execute elapsed time',23) ID,
       DECODE(STAT_NAME,'sql execute elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'sql execute elapsed time' union
SELECT DECODE(STAT_NAME,'parse time elapsed',24) ID,
       DECODE(STAT_NAME,'parse time elapsed',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'parse time elapsed' union
SELECT DECODE(STAT_NAME,'hard parse elapsed time',30) ID,
       DECODE(STAT_NAME,'hard parse elapsed time',24) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'hard parse elapsed time' union
SELECT DECODE(STAT_NAME,'hard parse (sharing criteria) elapsed time',40) ID,
       DECODE(STAT_NAME,'hard parse (sharing criteria) elapsed time',30) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'hard parse (sharing criteria) elapsed time' union
SELECT DECODE(STAT_NAME,'hard parse (bind mismatch) elapsed time',50) ID,
       DECODE(STAT_NAME,'hard parse (bind mismatch) elapsed time',40) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'hard parse (bind mismatch) elapsed time' union
SELECT DECODE(STAT_NAME,'failed parse elapsed time',31) ID,
       DECODE(STAT_NAME,'failed parse elapsed time',24) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'failed parse elapsed time' union
SELECT DECODE(STAT_NAME,'failed parse (out of shared memory) elapsed time',41) ID,
       DECODE(STAT_NAME,'failed parse (out of shared memory) elapsed time',31) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'failed parse (out of shared memory) elapsed time' union
SELECT DECODE(STAT_NAME,'PL/SQL execution elapsed time',25) ID,
       DECODE(STAT_NAME,'PL/SQL execution elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'PL/SQL execution elapsed time' union
SELECT DECODE(STAT_NAME,'inbound PL/SQL rpc elapsed time',26) ID,
       DECODE(STAT_NAME,'inbound PL/SQL rpc elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'inbound PL/SQL rpc elapsed time' union
SELECT DECODE(STAT_NAME,'PL/SQL compilation elapsed time',27) ID,
       DECODE(STAT_NAME,'PL/SQL compilation elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'PL/SQL compilation elapsed time' union
SELECT DECODE(STAT_NAME,'Java execution elapsed time',28) ID,
       DECODE(STAT_NAME,'Java execution elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'Java execution elapsed time' union
SELECT DECODE(STAT_NAME,'repeated bind elapsed time',29) ID,
       DECODE(STAT_NAME,'repeated bind elapsed time',10) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'repeated bind elapsed time' union
SELECT DECODE(STAT_NAME,'background elapsed time',60) ID,
       DECODE(STAT_NAME,'background elapsed time',0) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'background elapsed time' union
SELECT DECODE(STAT_NAME,'background cpu time',61) ID,
       DECODE(STAT_NAME,'background cpu time',60) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'background cpu time' union
SELECT DECODE(STAT_NAME,'RMAN cpu time (backup/restore)',62) ID,
       DECODE(STAT_NAME,'RMAN cpu time (backup/restore)',61) PID , STAT_NAME, VALUE
  FROM gv$sys_time_model
 WHERE STAT_NAME = 'RMAN cpu time (backup/restore)')
CONNECT BY PRIOR id = pid START WITH id = 0;