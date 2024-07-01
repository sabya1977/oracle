--
/*
1) View system and session instance activity statistics 
2) View system and session wait event statistics
3) Use session waiting events to investigate into hung or very slow sessions
4) This practice is not to learn about specific activity statistics or wait events. This practice is about
   retrieving them in various ways. Learning about handling wait events is covered in future lectures.
*/
--
/* 1) View system and session instance activity statistics */
--
/* 
Start Swingbench, set number of users as 10 and start swingbench benchmark test.
in Command prompt:
cd C:\u01\app\oracle\product\swingbench\winbin
swingbench.bat
*/
--
--
/*
Run the following query to display the instance activity statistics at the instance level.
--
In most cases, displaying all the time-based instance activity statistics at the system level is
meaningless. Those statistics provide more useful indications when they are taken in two
different known times and compared to each other. As you will learn later in the course, this
approach is best done using AWR and Statspack.
--
There are non-time-based instance activity statistics. We refer to those statistics based on our
direction of investigation.
*/
col NAME format A50
col CLASS format A10
SELECT
    NAME,
    DECODE(TO_CHAR(CLASS),
    '1',
    'User',
    '2',
    'Redo',
    '4',
    'Enqueue',
    '8',
    'Cache',
    '16',
    'OS',
    '32',
    'RAC',
    '33',
    'RAC-User',
    '40',
    'RAC-Cache',
    '64',
    'SQL',
    '72',
    'SQL-Cache',
    '128',
    'Debug',
    '192',
    'Debug-SQL',
    TO_CHAR(CLASS) ) CLASS,
    VALUE
FROM
    GV$SYSSTAT;
--
/*
NAME                         CLASS       VALUE
____________________________ ________ ________
OS CPU Qt wait time          User            0
Requests to/from client      User         7390
logons cumulative            User          228
logons current               User           13
opened cursors cumulative    User        36418
opened cursors current       User           35
user commits                 User         2095
user rollbacks               User         1114
user calls                   User        11990
recursive calls              User        88817
recursive cpu usage          User         1415
pinned cursors current       User           16
user logons cumulative       User           35
user logouts cumulative      User           23

NAME                                          CLASS        VALUE
_____________________________________________ ________ _________
session logical reads                         User        432494
session logical reads in local numa group     User             0
session logical reads in remote numa group    User             0
session stored procedure space                User             0
CPU used when call started                    Debug         1839
CPU used by this session                      User          1969
DB time                                       User         22918
CPU used by LWTs for this session             User             0
DB time of LWTs for this session              User             0
cluster wait time                             User             0
concurrency wait time                         User           273
application wait time                         User             0
user I/O wait time                            User          2057
scheduler wait time                           User             0

NAME                                CLASS            VALUE
___________________________________ ________ _____________
non-idle wait time                  User              3613
non-idle wait count                 User             36826
in call idle wait time              User             41632
session connect time                User        1686251442
process last non-idle time          Debug       1686251921
session uga memory                  User          94143400
session uga memory max              User         763251584
messages sent                       Debug             3210
messages received                   Debug                0
background timeouts                 Debug                0
remote Oradebug requests            Debug                0
session pga memory                  User          53045616
session pga memory max              User          70674800
recursive system API invocations    Debug                0

NAME                                        CLASS         VALUE
___________________________________________ __________ ________
enqueue timeouts                            Enqueue           0
enqueue waits                               Enqueue          22
enqueue deadlocks                           Enqueue           0
enqueue requests                            Enqueue       13738
enqueue conversions                         Enqueue         768
enqueue releases                            Enqueue       13677
*/
--
--
/* 
Run the following query to retrieve the statistics of full table scans and index scans in the
database.
This is just an example how to retrieve statistics of specific interests.
*/ 
SELECT
    NAME,
    VALUE
FROM
    GV$SYSSTAT
WHERE
    (NAME LIKE 'table%'
    OR NAME LIKE 'index%')
    AND VALUE<>0
ORDER BY
    NAME;
--    
/*
NAME                                        VALUE
______________________________________ __________
index fast full scans (full)                   11
index fetch by key                         646491
index range scans                         1204442
index split cancel wait noclean                 1
table fetch by rowid                      3386788
table fetch continued row                     189
table scan blocks gotten                    54641
table scan disk non-IMC rows gotten       3540038
table scan rows gotten                    3540038
table scans (short tables)                    798
*/    
--
--
/* 
Run the following queries to display the sessions with the top parse CPU time. Run the same
query multiple times and observe whether the statistics get incremented.
--
The same queries can be used to retrieve top sessions based on any specific statistic. As you go
on with the course, you will learn about most common statistics to look at in your investigation.
--
Note: observe that you need to link the V$SESSTAT with the V$STATNAME to obtain the statistic
names
*/
/* to list the top sessions of specific statistics: */
COL USERNAME FORMAT A5
COL NAME FORMAT A20
SELECT
    S.SID,
    H.USERNAME,
    T.NAME,
    S.VALUE
FROM
    GV$SESSTAT  S,
    GV$STATNAME T,
    GV$SESSION  H
WHERE
    S.STATISTIC# = T.STATISTIC#
    AND S.SID = H.SID
    AND T.NAME = 'parse time cpu'
    AND H.USERNAME IS NOT NULL
ORDER BY
    S.VALUE DESC;
--
/*
  SID USERNAME    NAME                 VALUE
______ ___________ _________________ ________
   265 SOE         parse time cpu          47
    61 SOE         parse time cpu          41
   298 SOE         parse time cpu          40
   299 SOE         parse time cpu          40
    57 SOE         parse time cpu          38
    70 SOE         parse time cpu          36
   289 SOE         parse time cpu          27
    26 SOE         parse time cpu          26
    42 SOE         parse time cpu          25
   288 SOE         parse time cpu          23
    71 SYS         parse time cpu          12
     6 SYS         parse time cpu           2
    39 TKYTE       parse time cpu           0    
*/
--
--
/* to include the statement text in the output: */
SELECT
    S.SID,
    H.USERNAME,
    T.NAME,
    S.VALUE,
    SUBSTR(Q.SQL_TEXT, 1, 25) AS
    SQL_TEXT
FROM
    GV$SESSTAT  S,
    GV$STATNAME T,
    GV$SESSION  H,
    GV$SQL      Q
WHERE
    S.STATISTIC# = T.STATISTIC#
    AND S.SID = H.SID
    AND H.SQL_ID=Q.SQL_ID(+)
    AND T.NAME = 'parse time cpu'
    AND H.USERNAME IS NOT NULL
ORDER BY
    S.VALUE DESC;
--    
/*
   SID USERNAME    NAME                 VALUE SQL_TEXT
______ ___________ _________________ ________ ____________________________
   265 SOE         parse time cpu          57 BEGIN :1 := orderentry.br
    61 SOE         parse time cpu          52 BEGIN :1 := orderentry.ne
   298 SOE         parse time cpu          46 BEGIN :1 := orderentry.up
   299 SOE         parse time cpu          45 BEGIN :1 := orderentry.br
    57 SOE         parse time cpu          45 BEGIN :1 := orderentry.ne
    70 SOE         parse time cpu          41 BEGIN :1 := orderentry.ne
    26 SOE         parse time cpu          35 BEGIN :1 := orderentry.br
   289 SOE         parse time cpu          33 BEGIN :1 := orderentry.ne
    42 SOE         parse time cpu          33 BEGIN :1 := orderentry.ne
   288 SOE         parse time cpu          30 BEGIN :1 := orderentry.br
    71 SYS         parse time cpu          16 SELECT     S.SID,     H.U
     6 SYS         parse time cpu           2
    39 TKYTE       parse time cpu           0 DECLARE
*/        
--
--
/* 
Run the following query to display the same activity statistics of the current session.
--
The query code is the same as the query code of the preceding example, except the V$SESSTAT is
replaced with V$MYSTAT.
--
V$MYSTAT is used when troubleshooting a current client session that we have control on it.
*/
SELECT
    S.SID,
    H.USERNAME,
    T.NAME,
    S.VALUE
FROM
    GV$MYSTAT   S,
    GV$STATNAME T,
    GV$SESSION  H
WHERE
    S.STATISTIC# = T.STATISTIC#
    AND S.SID = H.SID
    AND T.NAME = 'parse time cpu'
    AND H.USERNAME IS NOT NULL
ORDER BY
    S.VALUE DESC;
--    
-- parse time cpu: Total CPU time used for parsing (hard and soft) in 10s of milliseconds.
--
/*
   SID USERNAME    NAME                 VALUE
______ ___________ _________________ ________
    71 SYS         parse time cpu           4
*/        