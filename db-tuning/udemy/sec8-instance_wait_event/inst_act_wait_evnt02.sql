/*
2) View system and session wait event statistics
In this section of the practice, you will run queries to display the wait events at various levels.
*/
--
--
/* 
Usually wait events at the instance level are useful when comparing them to previously taken
baseline statistics. However, some specific wait events should not take large percentage of the
total wait time in all cases. You will learn about those events as you progress with the course.
--
Display all the non-idle wait event statistics at the instance level.
*/
col EVENT format a40
col WAIT_CLASS format a11
SELECT
    EVENT,
    AVERAGE_WAIT,
    TO_CHAR(ROUND(TIME_WAITED/100),
    '999,999,999') TIME_SECONDS,
    WAIT_CLASS
FROM
   GV$SYSTEM_EVENT
WHERE
    TIME_WAITED>0
    AND WAIT_CLASS<>'Idle'
ORDER BY
    TIME_WAITED;
/*
EVENT                                AVERAGE_WAIT TIME_SECONDS    WAIT_CLASS
_________________________________ _______________ _______________ ______________
library cache lock                           0.62            0    Concurrency
db file single write                         0.15            0    User I/O
resmgr:plan change                           0.89            0    Other
SQL*Net break/reset to client                0.14            0    Application
CSS operation: query                         0.05            0    Other
latch: call allocation                       0.29            0    Other
transaction                                     0            0    Other
enq: PS - contention                         0.05            0    Other
row cache lock                               0.06            0    Concurrency
ASM IO for non-blocking poll                    0            0    User I/O
CSS operation: action                         0.2            0    Other
PX qref latch                                   0            0    Other
latch: session allocation                    0.11            0    Other
latch: cache buffers lru chain               0.08            0    Other

EVENT                                AVERAGE_WAIT TIME_SECONDS    WAIT_CLASS
_________________________________ _______________ _______________ ______________
latch: messages                               0.2            0    Other
cursor: mutex S                              0.24            0    Concurrency
enq: US - contention                         1.11            0    Other
cursor: mutex X                               0.1            0    Concurrency
latch: undo global data                      0.11            0    Other
CSS initialization                           1.19            0    Other
enq: XL - fault extent map                   5.02            0    Other
DLM cross inst call completion               1.49            0    Other
kksfbc child completion                      4.96            0    Other
latch: cache buffers chains                  0.11            0    Concurrency
latch: redo allocation                       0.11            0    Other
PGA memory operation                            0            0    Other
library cache: bucket mutex X                0.56            0    Concurrency
Disk file operations I/O                     0.05            0    User I/O
*/    
/*
Display total wait time by wait event class.
*/
col WAIT_CLASS format a25
col TIME_SECONDS format a25
SELECT
    WAIT_CLASS,
    TO_CHAR(ROUND(TIME_WAITED/100),
    '999,999,999') TIME_SECONDS
FROM
    GV$SYSTEM_WAIT_CLASS
WHERE
    TIME_WAITED>0
    AND WAIT_CLASS<>'Idle'
ORDER BY
    TIME_WAITED;
--    
/*
WAIT_CLASS       TIME_SECONDS
________________ _______________
Application                 0
Scheduler                   1
System I/O                  4
Network                     4
Configuration               6
Other                      10
Concurrency                23
User I/O                   59
Commit                  1,736
*/    
--
/* to display the percentage for each wait class */
col PCT format a5
SELECT
    WAIT_CLASS,
    TO_CHAR(ROUND(TIME_WAITED/100),
    '999,999,999')                                         TIME_SECONDS,
    '%' || ROUND(RATIO_TO_REPORT(TIME_WAITED) OVER ()*100) PCT
FROM
    GV$SYSTEM_WAIT_CLASS
WHERE
    TIME_WAITED>0
    AND WAIT_CLASS<>'Idle'
ORDER BY
    TIME_SECONDS;
--
/*
WAIT_CLASS       TIME_SECONDS    PCT
________________ _______________ ______
Application                 0    %0
Scheduler                   1    %0
Network                     4    %0
System I/O                  4    %0
Configuration               6    %0
Other                      10    %1
Concurrency                23    %1
User I/O                   59    %3
Commit                  1,784    %94    
*/
--
/*
V$SESSION_EVENT is used to retrieve the accumulated wait time for each session since the
session logon time. The query below is a model example that can be tailored as per the
investigation direction.
--
Display the current sessions with the total wait time of the wait event 'log file sync' in each
session. Repeat running the same query for a few times and notice the wait time is incremented.
*/
set linesize 180
col EVENT format a25
SELECT
    E.SID,
    S.USERNAME,
    E.EVENT,
    TO_CHAR(ROUND(E.TIME_WAITED/100),
    '999,999,999') TIME_SECONDS,
    E.WAIT_CLASS
FROM
    GV$SESSION_EVENT E,
    GV$SESSION       S
WHERE
    E.SID=S.SID
    AND ROUND(E.TIME_WAITED/100)>0
    AND S.USERNAME='SOE'
    AND E.EVENT='log file sync'
ORDER BY
    TIME_WAITED;
--
/*

   SID USERNAME    EVENT            TIME_SECONDS    WAIT_CLASS
______ ___________ ________________ _______________ _____________
    70 SOE         log file sync             187    Commit
    57 SOE         log file sync             188    Commit
   298 SOE         log file sync             188    Commit
   265 SOE         log file sync             188    Commit
    61 SOE         log file sync             188    Commit
    26 SOE         log file sync             188    Commit
   289 SOE         log file sync             188    Commit
   288 SOE         log file sync             189    Commit
   299 SOE         log file sync             189    Commit
    42 SOE         log file sync             189    Commit
*/
--
/* Run the query again and observe the change: the wait time has incremented */
--
SELECT
    E.SID,
    S.USERNAME,
    E.EVENT,
    TO_CHAR(ROUND(E.TIME_WAITED/100),
    '999,999,999') TIME_SECONDS,
    E.WAIT_CLASS
FROM
    GV$SESSION_EVENT E,
    GV$SESSION       S
WHERE
    E.SID=S.SID
    AND ROUND(E.TIME_WAITED/100)>0
    AND S.USERNAME='SOE'
    AND E.EVENT='log file sync'
ORDER BY
    TIME_WAITED;
/*
   SID USERNAME    EVENT            TIME_SECONDS    WAIT_CLASS
______ ___________ ________________ _______________ _____________
    57 SOE         log file sync             194    Commit
    70 SOE         log file sync             194    Commit
   298 SOE         log file sync             195    Commit
   265 SOE         log file sync             195    Commit
    61 SOE         log file sync             195    Commit
    26 SOE         log file sync             195    Commit
   289 SOE         log file sync             195    Commit
   288 SOE         log file sync             196    Commit
    42 SOE         log file sync             196    Commit
   299 SOE         log file sync             196    Commit
*/       
--
/*
Current wait events can be retrieved from V$SESSION. Observe that the query below sometimes
retrieves some rows and sometimes it retrieves no row. It depends on the status of the sessions
at the time of running the query.
--
Note: You can query the view V$SESSION_WAIT for the same purpose.
--
Display the current sessions which are currently waiting for the event 'log file sync'.
*/
col USERNAME format a4
col WAIT_CLASS format a10
SELECT
    SID,
    USERNAME,
    EVENT,
    WAIT_TIME,
    WAIT_CLASS
FROM
    GV$SESSION
WHERE
    USERNAME='SOE'
    AND EVENT='log file sync'
ORDER BY
    WAIT_TIME;
--
/*

   SID USERNAME    EVENT               WAIT_TIME WAIT_CLASS
______ ___________ ________________ ____________ _____________
   288 SOE         log file sync               0 Commit
    57 SOE         log file sync               0 Commit

SQL> /

   SID USERNAME    EVENT               WAIT_TIME WAIT_CLASS
______ ___________ ________________ ____________ _____________
    70 SOE         log file sync               0 Commit

SQL> /

no rows selected
SQL> /

   SID USERNAME    EVENT               WAIT_TIME WAIT_CLASS
______ ___________ ________________ ____________ _____________
   299 SOE         log file sync               0 Commit
*/   