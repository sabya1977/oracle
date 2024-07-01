/* Managing Space Consumed by AWR Snapshots */
/* In this section of the practice, you will view the space consumed by the AWR snapshots. 
   Space consumed by AWR snapshots depend on the INTERVAL and RETENTION setting values of the AWR.
*/
-- login as system into root database
-- Submit the following query to display the space consumed by AWR snapshots.
col OCCUPANT_NAME format a20
col MOVE_PROCEDURE format a20
SELECT
    OCCUPANT_NAME,
    SPACE_USAGE_KBYTES/1024 MB,
    MOVE_PROCEDURE
FROM
    V$SYSAUX_OCCUPANTS
WHERE
    OCCUPANT_NAME = 'SM/AWR';
/*
-- Unfortunately, there is no standard procedure to move the AWR snapshots out of the SYSAUX tablespace.
--
OCCUPANT_NAME                MB MOVE_PROCEDURE
-------------------- ---------- --------------------
SM/AWR                 156.9375
*/    
--
/* login as sys and run @ ?/rdbms/admin/awrinfo.sql statement to generate the report */
--
/* The first section of the report shows the SYSAUX tablespace usage */
/*
(1a) SYSAUX usage - Schema breakdown (dba_segments)
*****************************************************
|                                                                                                                            
| Total SYSAUX size                        756.6 MB ( 2% of 32,768.0 MB MAX with AUTOEXTEND ON )                             
|                                                                                                                            
| Schema  SYS          occupies            455.8 MB (  60.2% )                                                               
| Schema  MDSYS        occupies            201.1 MB (  26.6% )                                                               
| Schema  XDB          occupies             68.4 MB (   9.0% )                                                               
| Schema  SYSTEM       occupies             12.6 MB (   1.7% ) 
*/
--
/* The second section shows the space consumed by various occupants of the SYSAUX table space such as
   AWR, Optimizer statistics, Job Scheduler and so on. In the below report, SM/AWR occupant occupies 
   155.2 MB space while SM/OPTSTAT - Optimizer statistics occupies 84.2 MB space
*/
/*
(1b) SYSAUX occupants space usage (v$sysaux_occupants)                                                                       
********************************************************                                                                     
|                                                                                                                            
| Occupant Name        Schema Name               Space Usage                                                                 
| -------------------- -------------------- ----------------                                                                 
| SDO                  MDSYS                        201.1 MB                                                                 
| SM/AWR               SYS                          155.2 MB                                                                 
| SM/OPTSTAT           SYS                           84.2 MB 
*/
--
/* Section 2 estimates for AWR snapshots - These estimates helps predicting the growth of AWR space in future */
--
/*
*************************************                                                                                        
(2) Size estimates for AWR snapshots                                                                                         
*************************************                                                                                        
|                                                                                                                            
| Estimates based on 60 mins snapshot INTERVAL:                                                                              
|    AWR size/day                          266.0 MB (11,351 K/snap * 24 snaps/day)                                           
|    AWR size/wk                         1,862.2 MB (size_per_day * 7) per instance                                          
|                                                                                                                            
| Estimates based on 10 snaps in past 24 hours:                                                                              
|    AWR size/day                          110.8 MB (11,351 K/snap and 10 snaps in past 24 hours)                            
|    AWR size/wk                           775.9 MB (size_per_day * 7) per instance 
*/
--
-- login as system into root database
/* Submit the following query to display the space consumed by the Optimizer backup statistics. */
--
SELECT
    OCCUPANT_NAME,
    SPACE_USAGE_KBYTES/1024 MB,
    MOVE_PROCEDURE
FROM
    GV$SYSAUX_OCCUPANTS
WHERE
    OCCUPANT_NAME = 'SM/OPTSTAT';
--
/*
OCCUPANT_NAME                MB MOVE_PROCEDURE
-------------------- ---------- --------------------
SM/OPTSTAT               84.375
*/    
--
/* Display the optimizer statistics retention period. */
/* By default, it is set to 31 days. There is no practical need to keep the optimizer statistics for this
   long period. We will change it to 7 days so that the space used by the remaining days are purged.
*/   
SELECT DBMS_STATS.GET_STATS_HISTORY_RETENTION FROM DUAL;
--
/*
GET_STATS_HISTORY_RETENTION
---------------------------
                         31
*/
-- Decrease the retention period of the optimizer statistics history to 7 days.
-- This value is container specific.
exec DBMS_STATS.ALTER_STATS_HISTORY_RETENTION(7);                         
--
-- Purge the optimizer statistics that do not comply with the new retention period
-- When you pass NULL to the PURGE_STATS procedure, the statistics that are older than the current
-- retention period will be deleted.
exec DBMS_STATS.PURGE_STATS(NULL);