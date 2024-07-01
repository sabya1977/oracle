/* Managing Automatic Workload Repository */
/* login as system into database */
show parameter STATISTICS_LEVEL
--
-- CLIENT_STATISTICS_LEVEL controls whether database clients report network statistics to the database.
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
client_statistics_level              string      TYPICAL
statistics_level                     string      TYPICAL
*/
-- This parameter must be set to TYPICAL or ALL, in order to have the AWR enabled. We will set this 
-- parameter to ALL.
ALTER SYSTEM SET STATISTICS_LEVEL=ALL SCOPE=BOTH;
--
/*
Run the following query to display the AWR settings.
By default, the INTERVAL equals to 1 hour and the RETENTION equals to 8 days.
*/
col SNAP_INTERVAL format a20
col RETENTION format a20
col TOPNSQL format a10
--
SELECT
    DBID,
    SNAP_INTERVAL,
    RETENTION,
    TOPNSQL
FROM
    DBA_HIST_WR_CONTROL;
--
/*
         DBID SNAP_INTERVAL             RETENTION              TOPNSQL
_____________ _________________________ ______________________ __________
   1620052637 +00 01:00:00.000000       +08 00:00:00.000000    DEFAULT
   3487778422 +40150 00:01:00.000000    +08 00:00:00.000000    DEFAULT
*/
--
/*
Modify the INTERVAL setting to 30 minutes.
Reducing the INTERVAL value leads to consuming more disk space by the AWR snapshots but it
allows more accurate performance analysis. In real life scenario, it is recommended to reduce the
default value of the AWR interval to 30 minutes or 15 minutes.
*/
BEGIN
    DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(INTERVAL => 30);
END;
/   
-- the new value would be
/*

DBID           SNAP_INTERVAL          RETENTION             TOPNSQL
_____________ ______________________ ______________________ __________
   3487778422 +00 00:30:00.000000    +08 00:00:00.000000    DEFAULT
*/