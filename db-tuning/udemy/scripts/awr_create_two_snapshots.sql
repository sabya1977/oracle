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
