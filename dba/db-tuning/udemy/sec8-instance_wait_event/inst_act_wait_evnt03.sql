/*
In this section of the practice, you will use the session wait event views to investigate into hung or
very slowly sessions. The target is to have further understanding on using the wait events in
performance troubleshooting. 
*/
--
/* 
Open two sql sessions and login with soe user. 
*/
--
-- Run the following query in each session. The second run should hang.
--
UPDATE EMP SET SALARY=SALARY WHERE EMP_NO=104;
/*
Open another SQL session with SYS and display the SID and the current event of the hung session.
In our scenario, we expect the hung session to be in WAITING state.
*/
SELECT
    SID,
    EVENT
FROM
    GV$SESSION
WHERE
    STATE='WAITING'
    AND USERNAME ='SOE'
    AND WAIT_CLASS<>'Idle';
/*
This section is not about studying the event 'enq: TX - row lock contention'. This
event will be covered in more details later in the course
--
   SID EVENT
______ ________________________________
    52 enq: TX - row lock contention
*/        
--
/* 
Display the wait event information of the hung session from the V$SESSION and from the
V$SESSION_EVENT. Run the queries multiple times and observe the increments in waiting time.
*/
col SESSION_WAITS format a100
SELECT 'SID: '|| SID||
CHR(10)||'USERNAME: '|| USERNAME||
CHR(10)||'STATE: '|| STATE||
CHR(10)||'EVENT: '|| EVENT||
CHR(10)||'WAIT_TIME: '|| WAIT_TIME||
CHR(10)||'SECONDS_IN_WAIT: '|| SECONDS_IN_WAIT||
CHR(10)||'WAIT_CLASS: '|| WAIT_CLASS||
CHR(10)||'P1TEXT: '|| P1TEXT||
CHR(10)||'P1: '|| P1||
CHR(10)||'P2TEXT: '|| P2TEXT||
CHR(10)||'P2: '|| P2 ||
CHR(10)||'P3TEXT: '|| P3TEXT||
CHR(10)||'P3: ' || P3 AS SESSION_WAITS
FROM GV$SESSION
WHERE USERNAME='SOE' AND EVENT LIKE 'enq: TX%'
ORDER BY WAIT_TIME;
/*
SESSION_WAITS                                                                                                                                                               
___________________________________________________________________________________________________________________________________________________________________________________________________________________________________
SID: 52
USERNAME: SOE
STATE: WAITING
EVENT: enq: TX - row lock contention
WAIT_TIME: 0
SECONDS_IN_WAIT: 388
WAIT_CLASS: Application
P1TEXT: name|mode
P1: 1415053318
P2TEXT: usn<<16 | slot
P2: 327698
P3TEXT: sequence
P3: 4433
*/
--
/*
SQL> /
SECONDS_IN_WAIT has incremented.
SESSION_WAITS                                                                                                                                                               
___________________________________________________________________________________________________________________________________________________________________________________________________________________________________
SID: 52
USERNAME: SOE
STATE: WAITING
EVENT: enq: TX - row lock contention
WAIT_TIME: 0
SECONDS_IN_WAIT: 453
WAIT_CLASS: Application
P1TEXT: name|mode
P1: 1415053318
P2TEXT: usn<<16 | slot
P2: 327698
P3TEXT: sequence
P3: 4433
*/
--
/*
SECONDS_IN_WAIT has incremented.
--
SESSION_WAITS                                                                                                                                                               
___________________________________________________________________________________________________________________________________________________________________________________________________________________________________
SID: 52
USERNAME: SOE
STATE: WAITING
EVENT: enq: TX - row lock contention
WAIT_TIME: 0
SECONDS_IN_WAIT: 513
WAIT_CLASS: Application
P1TEXT: name|mode
P1: 1415053318
P2TEXT: usn<<16 | slot
P2: 327698
P3TEXT: sequence
P3: 4433
*/
--
-- You can retrive the similar information from V$SESSION_WAIT view as well.
--
SELECT 'SID: '|| SID||
CHR(10)||'STATE: '|| STATE||
CHR(10)||'EVENT: '|| EVENT||
CHR(10)||'WAIT_TIME: '|| WAIT_TIME||
CHR(10)||'SECONDS_IN_WAIT: '|| SECONDS_IN_WAIT||
CHR(10)||'WAIT_CLASS: '|| WAIT_CLASS||
CHR(10)||'P1TEXT: '|| P1TEXT||
CHR(10)||'P1: '|| P1||
CHR(10)||'P2TEXT: '|| P2TEXT||
CHR(10)||'P2: '|| P2 ||
CHR(10)||'P3TEXT: '|| P3TEXT||
CHR(10)||'P3: ' || P3 AS SESSION_WAITS
FROM GV$SESSION_WAIT
WHERE EVENT LIKE 'enq: TX%'
ORDER BY WAIT_TIME;
--
/*
SESSION_WAITS                                                                                                                                                               
________________________________________________
SID: 52
STATE: WAITING
EVENT: enq: TX - row lock contention
WAIT_TIME: 0
SECONDS_IN_WAIT: 14
WAIT_CLASS: Application
P1TEXT: name|mode
P1: 1415053318
P2TEXT: usn<<16 | slot
P2: 589825
P3TEXT: sequence
P3: 4455
*/
--
SELECT
    E.EVENT,
    TO_CHAR(ROUND(E.TIME_WAITED/100),
    '999,999,999') TIME_SECONDS
FROM
    GV$SESSION_EVENT E,
    GV$SESSION       S
WHERE
    E.SID=S.SID
    AND S.USERNAME='SOE'
    AND E.EVENT LIKE 'enq: TX%'
ORDER BY
    TIME_WAITED;
--    
/*
EVENT                            TIME_SECONDS
________________________________ _______________
enq: TX - row lock contention             619
*/    
--
-- Retrieve information about the wait event from the V$SESSION_WAIT_HISTORY.
--
-- V$SESSION_WAIT_HISTORY view retrieves into the last 10 wait events in the current sessions.
-- Observe that the wait event is not registered in this view. As you will see soon, wait events are
-- registered in this view only after they expire.
--
SELECT
    COUNT(*)
FROM
    GV$SESSION_WAIT_HISTORY
WHERE
    EVENT LIKE 'enq: TX%';
--
/*
   COUNT(*)
___________
          0    
*/              
--
-- From the blocking session, rollback the transaction.
ROLLBACK;
--
-- Display the wait events from the V$SESSION for all the soe sessions.
--
col EVENT format a40
col WAIT_CLASS format a10
SELECT
    SID,
    EVENT,
    WAIT_CLASS
FROM
    GV$SESSION
WHERE
    USERNAME='SOE';
--
-- Observe that the enqueue wait event does not appear any more in the V$SESSION view because
-- the session is not currently waiting for the event.
/*

   SID EVENT                          WAIT_CLASS
______ ______________________________ _____________
    52 SQL*Net message from client    Idle
   296 SQL*Net message from client    Idle
*/       
--
-- Retrieve information about the wait event that has just expired from the V$SESSION_WAIT_HISTORY.
-- After the wait is expired, it is reported by the view, not in V$SESSION or V$SESSION_WAIT.
--
SELECT 'SID: '|| SID||
CHR(10)||'EVENT: '|| EVENT||
CHR(10)||'WAIT_TIME: '|| WAIT_TIME||
CHR(10)||'P1TEXT: '|| P1TEXT||
CHR(10)||'P1: '|| P1||
CHR(10)||'P2TEXT: '|| P2TEXT||
CHR(10)||'P2: '|| P2 ||
CHR(10)||'P3TEXT: '|| P3TEXT||
CHR(10)||'P3: ' || P3 AS SESSION_WAITS
FROM GV$SESSION_WAIT_HISTORY
WHERE EVENT LIKE 'enq: TX%'
ORDER BY WAIT_TIME;
--
/*
SESSION_WAITS
____________________________________________________________________________________________________________________________________________________________
SID: 52
EVENT: enq: TX - row lock contention
WAIT_TIME: 6113
P1TEXT: name|mode
P1: 1415053318
P2TEXT: usn<<16 | slot
P2: 458772
P3TEXT: sequence
P3: 3779
*/
--
-- Exit from the soe sessions
--
/* Verify that the wait events cannot be reported from 
   V$SESSION_WAIT_HISTORY after the sessions are disconnected.
*/   
SELECT COUNT(*) FROM V$SESSION_WAIT_HISTORY WHERE EVENT LIKE 'enq: TX%';
/*
   COUNT(*)
___________
          0
*/          

