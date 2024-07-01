/* Managing AWR Snapshots */
/* In this section of the practice, you will view, create, and delete AWR snapshots. */
-- Execute the following query to display the existing AWR snapshots.
SELECT
    SNAP_ID,
    BEGIN_INTERVAL_TIME,
    END_INTERVAL_TIME,
    SNAP_LEVEL
FROM
    DBA_HIST_SNAPSHOT
ORDER BY
    SNAP_ID;
/*
 SNAP_ID BEGIN_INTERVAL_TIME               END_INTERVAL_TIME                    SNAP_LEVEL
__________ _________________________________ _________________________________ _____________
      1415 23-06-23 10:13:13.000000000 PM    23-06-23 10:24:15.001000000 PM                1
      1416 23-06-23 10:24:15.001000000 PM    23-06-23 11:30:29.342000000 PM                1
      1417 23-06-23 11:30:29.342000000 PM    24-06-23 12:30:31.617000000 AM                1
      1418 24-06-23 12:30:31.617000000 AM    24-06-23 1:30:34.146000000 AM                 1
      1419 25-06-23 10:37:29.000000000 AM    25-06-23 10:47:31.278000000 AM                1
      1420 25-06-23 10:47:31.278000000 AM    25-06-23 11:30:44.801000000 AM                1
      1421 25-06-23 11:30:44.801000000 AM    25-06-23 12:30:48.457000000 PM                1
      1422 25-06-23 12:30:48.457000000 PM    25-06-23 1:30:50.646000000 PM                 1
      1423 25-06-23 1:30:50.646000000 PM     25-06-23 2:30:53.639000000 PM                 1
      1424 25-06-23 2:30:53.639000000 PM     25-06-23 3:30:56.628000000 PM                 1
      1425 25-06-23 3:30:56.628000000 PM     25-06-23 4:30:58.882000000 PM                 1
      1426 25-06-23 4:30:58.882000000 PM     25-06-23 5:30:01.456000000 PM                 1
      1427 25-06-23 5:30:01.456000000 PM     25-06-23 6:30:03.711000000 PM                 2
*/
--
-- Manually create a heavyweight AWR snapshot.          
exec DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT(FLUSH_LEVEL=>'ALL');
--
-- Display information about the created snapshot
--
set linesize 180
col BEGIN_INTERVAL_TIME format a28
col END_INTERVAL_TIME format a28
col DBID format 9999999999
SELECT
    DBID,
    SNAP_ID,
    BEGIN_INTERVAL_TIME,
    END_INTERVAL_TIME,
    SNAP_LEVEL
FROM
    DBA_HIST_SNAPSHOT
ORDER BY
    SNAP_ID DESC FETCH FIRST 1 ROWS ONLY;
--
-- Heavyweight AWR snapshot is described as a snapshot of level 2.
--
/*
   SNAP_ID BEGIN_INTERVAL_TIME              END_INTERVAL_TIME                   SNAP_LEVEL
__________ ________________________________ ________________________________ _____________
      1427 25-06-23 5:30:01.456000000 PM    25-06-23 6:30:03.711000000 PM                2
*/
--
--Delete the manually created snapshot
--Obtain the SNAP_ID value from the output of the preceding query (1427)
--
DEFINE v_snapID = &Enter_SnapID
begin
    DBMS_WORKLOAD_REPOSITORY.DROP_SNAPSHOT_RANGE(
    LOW_SNAP_ID => &v_snapID,
    HIGH_SNAP_ID => &v_snapID);
end;
/


         