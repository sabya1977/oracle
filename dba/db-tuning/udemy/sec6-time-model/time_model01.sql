/*
--Run the following script to display the top 7 “time model statistics” operations at the system level.
-- The output of this script helps you on knowing on which operation type the database time was mostly spent on.
-- When analyzing this view figures, keep in mind that its figures are cumulative.
*/
COL STAT_NAME FORMAT A43
SELECT
    STAT_NAME,
    TO_CHAR(VALUE, '999,999,999,999') TIME_MICRO_S
FROM
    GV$SYS_TIME_MODEL
WHERE
    VALUE <>0
    AND STAT_NAME NOT IN ('background elapsed time', 'background cpu time')
ORDER BY
    VALUE DESC FETCH FIRST 7 ROWS ONLY;
/*
STAT_NAME                                     TIME_MICRO_S
_____________________________________________ ___________________
DB time                                              2,235,815
DB CPU                                               1,872,391
sql execute elapsed time                             1,631,251
parse time elapsed                                   1,033,194
hard parse elapsed time                              1,018,534
connection management call elapsed time                112,470
hard parse (sharing criteria) elapsed time              22,738
*/
--
/*
-- Run the following query script to display the percentage of each operation type from the 
-- total DB time. This query makes it easy to know which operation type is mostly spent by the database.
*/
COL STAT_NAME FORMAT A43
SELECT
    STAT_NAME,
    TO_CHAR(VALUE,
    '999,999,999,999') TIME_MICRO_S,
    ROUND(VALUE/(
    SELECT
        VALUE
    FROM
        GV$SYS_TIME_MODEL
    WHERE
        STAT_NAME='DB time')*100,
        2) PCT
    FROM
        GV$SYS_TIME_MODEL
    WHERE
        VALUE <>0
        AND STAT_NAME NOT IN ('background elapsed time', 'background cpu time')
    ORDER BY
        VALUE DESC FETCH FIRST 7 ROWS ONLY;
-- The total of the percentage figures in the children rows is not 100. That is normal.        
/*
STAT_NAME                                     TIME_MICRO_SEC           PCT
_____________________________________________ ___________________ ________
DB time                                              5,975,454         100
DB CPU                                               4,744,148       79.39
sql execute elapsed time                             4,457,624        74.6
parse time elapsed                                   2,851,867       47.73
hard parse elapsed time                              2,793,014       46.74
hard parse (sharing criteria) elapsed time             745,693       12.48
connection management call elapsed time                202,038        3.38
*/
--
/*
-- Run the following query script to display the time model statistics in a hierarchy structure.
-- Displaying time model in tree structure allows you to understand the relationship between the operation types. 
*/
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
--
/*
STAT_NAME                                                 SECONDS
______________________________________________________ __________

   DB time                                                  98.26
     DB CPU                                                 96.88
     connection management call elapsed time                 0.23
     sql execute elapsed time                                4.83
     parse time elapsed                                      2.94
       hard parse elapsed time                               2.86
         hard parse (sharing criteria) elapsed time          0.74
       failed parse elapsed time                                0
     PL/SQL execution elapsed time                           0.01
     PL/SQL compilation elapsed time                         0.07
     repeated bind elapsed time                                 0
   background elapsed time                                   6.04
     background cpu time                                     1.45
*/     
