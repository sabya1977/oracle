/************************************************************/
/* Using AWR Reports                                        */
/* Using AWR Reports to Troubleshoot a Performance Issue    */
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
/* Connect to putty as root user and run the following command */
stress --cpu 20 --timeout 720s
--
/* Run the following script to create two AWR snapshots. Those snapshots represent the normal
   OLTP workload in a business day. This script creates a scheduler job that kicks off immediately.
   The job first creates an AWR snapshot. After 10 minutes, the job captures another AWR snapshot and then deletes itself
*/
-- create two AWR snapshots. First one at the time of running the script. Second one after 10 minutes.
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
--
-- display the most recent two snapshots created today
--
col BEGIN_INTERVAL_TIME format a28
col END_INTERVAL_TIME format a28
SELECT SNAP_ID, BEGIN_INTERVAL_TIME, END_INTERVAL_TIME
  FROM DBA_HIST_SNAPSHOT
WHERE TRUNC(BEGIN_INTERVAL_TIME) = TRUNC(SYSDATE -1 )
ORDER BY SNAP_ID;
--
/* 
  SNAP_ID BEGIN_INTERVAL_TIME          END_INTERVAL_TIME
---------- ---------------------------- ----------------------------
      1487 05-AUG-23 03.58.06.000 PM    05-AUG-23 04.08.14.198 PM
      1488 05-AUG-23 04.08.14.198 PM    05-AUG-23 05.30.26.293 PM
      1489 05-AUG-23 05.30.26.293 PM    05-AUG-23 06.30.28.445 PM
      1490 05-AUG-23 06.30.28.445 PM    05-AUG-23 07.30.30.740 PM
      1491 05-AUG-23 07.30.30.740 PM    05-AUG-23 08.30.33.015 PM
      1492 05-AUG-23 08.30.33.015 PM    05-AUG-23 09.30.35.511 PM
      1493 05-AUG-23 09.30.35.511 PM    05-AUG-23 10.30.37.758 PM
      1494 05-AUG-23 10.30.37.758 PM    05-AUG-23 11.30.39.970 PM
      1495 05-AUG-23 11.30.39.970 PM    06-AUG-23 12.11.28.084 AM
       1496 06-AUG-23 12.11.28.084 AM    06-AUG-23 12.21.24.855 AM
*/      

-- Produce the AWR reports for the last two snapshots
/* In Swingbench, stop the benchmark sessions */
/* login to DB server through putty and login as SYS */
/* run the following script to generate the AWR report in html format */
@?/rdbms/admin/awrrpt.sql
/* create the AWR report named issue_period.html with two SNAP ID  */


