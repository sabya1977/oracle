/* 
In the following steps, you will gradually increase the workload on the database and measure the
change impact on the time model statistics:
1) You will create a table to save snapshots of the DB time, DB CPU, and total waits in it.
2) You will apply different workload levels against the database and save the time model figures at each level into the
table. You will then analyze the table contents.
--
We do not perform those steps in real life scenario. The target of these steps is to understand the time
model statistics.
*/
--
/* Run the following SQL to create a table to save history of the basic time model statistics in it.*/
--
DROP TABLE TM_HISTORY;
DROP SEQUENCE S;
CREATE SEQUENCE S;
CREATE TABLE TM_HISTORY AS
    SELECT
        S.NEXTVAL                          AS SNAP_ID,
        DBTIME.VALUE/1000000               DBTIME,
        DBCPU.VALUE/1000000                DBCPU,
        (DBTIME.VALUE-DBCPU.VALUE)/1000000 WAIT_TIME, -- DB Time = DB CPU + Total DB Waits
        (
        SELECT
            COUNT(*)
        FROM
            GV$SESSION
        WHERE
            USERNAME IS NOT NULL) USERS_CNT
        FROM
            GV$SYS_TIME_MODEL DBTIME,
            GV$SYS_TIME_MODEL DBCPU
        WHERE
            DBTIME.STAT_NAME = 'DB time'
            AND DBCPU.STAT_NAME = 'DB CPU';
--
/*
Display the contents of the table.
*/
set linesize 180
SELECT
    TO_CHAR(DBTIME, '999,999,999')  DBTIME,
    TO_CHAR(DBCPU, '999,999,999')    DBCPU,
    ROUND(DBCPU - LAG(DBCPU, 1, 0) OVER (ORDER BY DBCPU)) AS DBCPU_DIFF, -- diff. between two DBCPU of two snaps. 
    TO_CHAR(WAIT_TIME,'999,999,999,999')  WAIT_TIME,
    ROUND(WAIT_TIME - LAG(WAIT_TIME,1,0) OVER (ORDER BY WAIT_TIME)) AS WAIT_TIME_DIFF, -- diff. between two wait time of two snaps. 
    TO_CHAR((DBTIME-DBCPU)/DBTIME*100, '99.99') || '%' WAIT_PCT,
    USERS_CNT,
    ROUND((DBTIME-DBCPU)/USERS_CNT) WAIT_USER_SHARE
FROM
    TM_HISTORY
ORDER BY
    SNAP_ID;
--
-- this is not a true workload picture of a DB becuase the database was started up a short while ago.
--
/*
DBTIME          DBCPU              DBCPU_DIFF WAIT_TIME              WAIT_TIME_DIFF WAIT_PCT       USERS_CNT    WAIT_USER_SHARE
_______________ _______________ _____________ ___________________ _________________ ___________ ____________ __________________
         100              98               98                2                    2   1.66%                7                  0
*/             
--
-- Run Swingbech for 1 minute for 10 users
--
/*
 Take Time Model snapshot 
*/
INSERT INTO TM_HISTORY
SELECT
    S.NEXTVAL                          AS SNAP_ID,
    DBTIME.VALUE/1000000               DBTIME,
    DBCPU.VALUE/1000000                DBCPU,
    (DBTIME.VALUE-DBCPU.VALUE)/1000000 WAIT_TIME,
    (
    SELECT
        COUNT(*)
    FROM
        GV$SESSION
    WHERE
        USERNAME IS NOT NULL
    ) USERS_CNT
    FROM
        GV$SYS_TIME_MODEL DBTIME,
        GV$SYS_TIME_MODEL DBCPU
    WHERE
        DBTIME.STAT_NAME = 'DB time'
        AND DBCPU.STAT_NAME = 'DB CPU';
COMMIT;
--
/* 
 Display TM history
*/
set linesize 180
SELECT
    TO_CHAR(DBTIME, '999,999,999')  DBTIME,
    TO_CHAR(DBCPU, '999,999,999')    DBCPU,
    ROUND(DBCPU - LAG(DBCPU, 1, 0) OVER (ORDER BY DBCPU)) AS DBCPU_DIFF,
    TO_CHAR(WAIT_TIME,'999,999,999,999')  WAIT_TIME,
    ROUND(WAIT_TIME - LAG(WAIT_TIME,1,0) OVER (ORDER BY WAIT_TIME)) AS WAIT_TIME_DIFF,
    TO_CHAR((DBTIME-DBCPU)/DBTIME*100, '99.99') || '%' WAIT_PCT,
    USERS_CNT,
    ROUND((DBTIME-DBCPU)/USERS_CNT) WAIT_USER_SHARE
FROM
    TM_HISTORY
ORDER BY
    SNAP_ID; 
--
/*
DBTIME          DBCPU              DBCPU_DIFF WAIT_TIME              WAIT_TIME_DIFF WAIT_PCT       USERS_CNT    WAIT_USER_SHARE
_______________ _______________ _____________ ___________________ _________________ ___________ ____________ __________________
         100              98                4                2                    2   1.66%                7                  0
         628              94               94              534                  532  85.02%                3                178
*/             
-- Run Swingbech for 1 minute for 10 users
--
INSERT INTO TM_HISTORY
SELECT
    S.NEXTVAL                          AS SNAP_ID,
    DBTIME.VALUE/1000000               DBTIME,
    DBCPU.VALUE/1000000                DBCPU,
    (DBTIME.VALUE-DBCPU.VALUE)/1000000 WAIT_TIME,
    (
    SELECT
        COUNT(*)
    FROM
        GV$SESSION
    WHERE
        USERNAME IS NOT NULL
    ) USERS_CNT
    FROM
        GV$SYS_TIME_MODEL DBTIME,
        GV$SYS_TIME_MODEL DBCPU
    WHERE
        DBTIME.STAT_NAME = 'DB time'
        AND DBCPU.STAT_NAME = 'DB CPU';
COMMIT;
/* 
 Display TM history
*/
set linesize 180
SELECT
    TO_CHAR(DBTIME, '999,999,999')  DBTIME,
    TO_CHAR(DBCPU, '999,999,999')    DBCPU,
    ROUND(DBCPU - LAG(DBCPU, 1, 0) OVER (ORDER BY DBCPU)) AS DBCPU_DIFF,
    TO_CHAR(WAIT_TIME,'999,999,999,999')  WAIT_TIME,
    ROUND(WAIT_TIME - LAG(WAIT_TIME,1,0) OVER (ORDER BY WAIT_TIME)) AS WAIT_TIME_DIFF,
    TO_CHAR((DBTIME-DBCPU)/DBTIME*100, '99.99') || '%' WAIT_PCT,
    USERS_CNT,
    ROUND((DBTIME-DBCPU)/USERS_CNT) WAIT_USER_SHARE
FROM
    TM_HISTORY
ORDER BY
    SNAP_ID;
--
-- Run Swingbech for 1 minute for 30 users
--    
INSERT INTO TM_HISTORY
SELECT
    S.NEXTVAL                          AS SNAP_ID,
    DBTIME.VALUE/1000000               DBTIME,
    DBCPU.VALUE/1000000                DBCPU,
    (DBTIME.VALUE-DBCPU.VALUE)/1000000 WAIT_TIME,
    (
    SELECT
        COUNT(*)
    FROM
        GV$SESSION
    WHERE
        USERNAME IS NOT NULL
    ) USERS_CNT
    FROM
        GV$SYS_TIME_MODEL DBTIME,
        GV$SYS_TIME_MODEL DBCPU
    WHERE
        DBTIME.STAT_NAME = 'DB time'
        AND DBCPU.STAT_NAME = 'DB CPU';
COMMIT;
--
/* 
 Display TM history
*/
set linesize 180
SELECT
    TO_CHAR(DBTIME, '999,999,999')  DBTIME,
    TO_CHAR(DBCPU, '999,999,999')    DBCPU,
    ROUND(DBCPU - LAG(DBCPU, 1, 0) OVER (ORDER BY DBCPU)) AS DBCPU_DIFF,
    TO_CHAR(WAIT_TIME,'999,999,999,999')  WAIT_TIME,
    ROUND(WAIT_TIME - LAG(WAIT_TIME,1,0) OVER (ORDER BY WAIT_TIME)) AS WAIT_TIME_DIFF,
    TO_CHAR((DBTIME-DBCPU)/DBTIME*100, '99.99') || '%' WAIT_PCT,
    USERS_CNT,
    ROUND((DBTIME-DBCPU)/USERS_CNT) WAIT_USER_SHARE
FROM
    TM_HISTORY
ORDER BY
    SNAP_ID;
--
/*
DBTIME          DBCPU              DBCPU_DIFF WAIT_TIME              WAIT_TIME_DIFF WAIT_PCT       USERS_CNT    WAIT_USER_SHARE
_______________ _______________ _____________ ___________________ _________________ ___________ ____________ __________________
         100              98                4                2                    2   1.66%                7                  0
         628              94               94              534                  532  85.02%                3                178
         628              94                0              534                    0  85.02%                3                178
       1,227             196               98            1,031                  497  84.02%                3                344
*/     
--
--
-- Run Swingbech for 1 minute for 60 users
--    
INSERT INTO TM_HISTORY
SELECT
    S.NEXTVAL                          AS SNAP_ID,
    DBTIME.VALUE/1000000               DBTIME,
    DBCPU.VALUE/1000000                DBCPU,
    (DBTIME.VALUE-DBCPU.VALUE)/1000000 WAIT_TIME,
    (
    SELECT
        COUNT(*)
    FROM
        GV$SESSION
    WHERE
        USERNAME IS NOT NULL
    ) USERS_CNT
    FROM
        GV$SYS_TIME_MODEL DBTIME,
        GV$SYS_TIME_MODEL DBCPU
    WHERE
        DBTIME.STAT_NAME = 'DB time'
        AND DBCPU.STAT_NAME = 'DB CPU';
COMMIT;      
--
/* 
 Display TM history
*/
set linesize 180
SELECT
    TO_CHAR(DBTIME, '999,999,999')  DBTIME,
    TO_CHAR(DBCPU, '999,999,999')    DBCPU,
    ROUND(DBCPU - LAG(DBCPU, 1, 0) OVER (ORDER BY DBCPU)) AS DBCPU_DIFF,
    TO_CHAR(WAIT_TIME,'999,999,999,999')  WAIT_TIME,
    ROUND(WAIT_TIME - LAG(WAIT_TIME,1,0) OVER (ORDER BY WAIT_TIME)) AS WAIT_TIME_DIFF,
    TO_CHAR((DBTIME-DBCPU)/DBTIME*100, '99.99') || '%' WAIT_PCT,
    USERS_CNT,
    ROUND((DBTIME-DBCPU)/USERS_CNT) WAIT_USER_SHARE
FROM
    TM_HISTORY
ORDER BY
    SNAP_ID;
--
/*
DBTIME          DBCPU              DBCPU_DIFF WAIT_TIME              WAIT_TIME_DIFF WAIT_PCT       USERS_CNT    WAIT_USER_SHARE
_______________ _______________ _____________ ___________________ _________________ ___________ ____________ __________________
         100              98                4                2                    2   1.66%                7                  0
         628              94               94              534                  532  85.02%                3                178
         628              94                0              534                    0  85.02%                3                178
       1,227             196               98            1,031                  497  84.02%                3                344
       3,074             324              127            2,750                 1719  89.47%                3                917
*/           
/*
Using Time Model to obtain list of the top sessions 
*/
-- Run swingbench for 20 users for a minute. 
/*
*/
col SID format 999999
col USERNAME format a10
col DBTIME format 9999999999999
col WAITTIME format 9999999999999
col WAITPCT format 99999.99
col ONCPUPCT format 99999.99
SELECT M.SID, S.USERNAME
           ,VALUE DBTIME
           ,WAITTIME WAITTIME
           ,ROUND((WAITTIME/VALUE)*100,2) WAITPCT
           ,ROUND(((VALUE-WAITTIME)/VALUE)*100,2) ONCPU_PCT
      FROM(SELECT SID, STAT_ID, STAT_NAME ,VALUE
            ,VALUE - (LEAD(VALUE,1) OVER(PARTITION BY SID ORDER BY SID,STAT_NAME DESC)) WAITTIME
           FROM GV$SESS_TIME_MODEL
           WHERE STAT_NAME IN ('DB time','DB CPU')) M,
		   GV$SESSION S
WHERE M.SID = S.SID
      AND STAT_NAME='DB time' AND WAITTIME>0
ORDER BY WAITPCT DESC;
--
-- Top sessions
--
/*
  SID USERNAME         DBTIME    WAITTIME    WAITPCT    ONCPU_PCT
______ ___________ ___________ ___________ __________ ____________
   243                    6834        6115      89.48        10.52
     5                    6825        5834      85.48        14.52
   284 TKYTE            199607      148527      74.41        25.59
   285 SOE            10851307     7270554         67           33
    60 SOE            11066290     7368999      66.59        33.41
   286 SOE            10772695     7172998      66.58        33.42
    47 SOE            10732277     7128952      66.43        33.57
    67 SOE            10644254     7069302      66.41        33.59
   270 SOE            10782134     7157064      66.38        33.62
    56 SOE            11173587     7411142      66.33        33.67
    50 SOE            11292840     7481141      66.25        33.75
   271 SOE            10812817     7098287      65.65        34.35
    58 SOE            10600742     6953197      65.59        34.41
   293 SOE            10730630     7038016      65.59        34.41

   SID USERNAME         DBTIME    WAITTIME    WAITPCT    ONCPU_PCT
______ ___________ ___________ ___________ __________ ____________
   277 SOE            11396363     7472221      65.57        34.43
    59 SOE            10644893     6963672      65.42        34.58
   281 SOE            10792233     7052149      65.34        34.66
    57 SOE            11314436     7386888      65.29        34.71
    63 SOE            11108476     7250369      65.27        34.73
   274 SOE            11088757     7229478       65.2         34.8
   276 SOE            11008736     7144992       64.9         35.1
   280 SOE            10836068     7011043       64.7         35.3
    53 SOE            10593285     6783009      64.03        35.97
   275 TKYTE             71618       14271      19.93        80.07
*/
--
-- clean up
--
-- stop Swingbench benchmark and close Swingbench
--
DROP TABLE TM_HISTORY;
DROP SEQUENCE S;