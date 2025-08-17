/************************************************************/
/* Using AWR Reports                                        */
/* Producing and Reading an AWR Report on an OLTP Workload  */
/************************************************************/
/* Start Swingbench */
cd %SWINGBENCH%
--
swingbench.bat
--
/* select swinchbench_oltp_benchmark.xml */
/* Wait for 2 minutes so that the statistics change rate gets saturated. */
/* login as SYS into root database */
--
/* Run the following script to create two AWR snapshots. Those snapshots represent the normal
   OLTP workload in a business day. This script creates a scheduler job that kicks off immediately.
   The job first creates an AWR snapshot. After 10 minutes, the job captures another AWR snapshot and then deletes itself
*/
SELECT TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI:SS')  C_TIME FROM DUAL;
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
 JOB_NAME => 'CREATE_2_AWR_SNAPSHOTS',
 JOB_TYPE => 'PLSQL_BLOCK',
 JOB_ACTION => 'BEGIN DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT(); END;',
 START_DATE => SYSDATE,
 REPEAT_INTERVAL => 'FREQ=MINUTELY;INTERVAL=10', /* every 10 minutes */
 END_DATE => SYSDATE + (1/24/60*12), /* drop after 12  minutes of creating the job */ 
 AUTO_DROP => TRUE,
 ENABLED => TRUE,
 COMMENTS => 'create an AWR snapshots: now and after 10 minutes');
END;
/
/* Wait for 10 minutes */
/* Display the most recent AWR snapshots to make sure two snapshots were created in the past 10 mins */
--
col BEGIN_INTERVAL_TIME format a28
col END_INTERVAL_TIME format a28

SELECT SNAP_ID, BEGIN_INTERVAL_TIME, END_INTERVAL_TIME
  FROM DBA_HIST_SNAPSHOT
WHERE TRUNC(BEGIN_INTERVAL_TIME) = TRUNC(SYSDATE)
ORDER BY SNAP_ID;
--
/*
   SNAP_ID BEGIN_INTERVAL_TIME          END_INTERVAL_TIME
---------- ---------------------------- ----------------------------
      1440 16-JUL-23 01.20.40.000 PM    16-JUL-23 01.31.38.664 PM
      1441 16-JUL-23 01.31.38.664 PM    16-JUL-23 02.30.49.816 PM
      1442 16-JUL-23 02.30.49.816 PM    16-JUL-23 03.30.52.448 PM
      1443 16-JUL-23 03.30.52.448 PM    16-JUL-23 04.30.54.713 PM
      1444 16-JUL-23 04.30.54.713 PM    16-JUL-23 05.30.57.451 PM
      1445 16-JUL-23 05.30.57.451 PM    16-JUL-23 06.30.59.761 PM
      1446 16-JUL-23 06.30.59.761 PM    16-JUL-23 07.30.03.635 PM
      1447 16-JUL-23 07.30.03.635 PM    16-JUL-23 08.30.06.729 PM
      1448 16-JUL-23 08.55.05.000 PM    16-JUL-23 09.10.24.194 PM
      1449 16-JUL-23 09.10.24.194 PM    16-JUL-23 09.20.23.172 PM
*/      
-- note the last two SNAP IDs
/* In Swingbench, stop the benchmark sessions */
/* login to DB server through putty and login as SYS */
/* run the following script to generate the AWR report in html format */
@ ?/rdbms/admin/awrrpt.sql
/* create the AWR report named normal_oltp.html with two SNAP ID 1448 and 1449 */


