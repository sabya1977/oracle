
-- this code keeps consuming from CPU till N seconds is elapsed
DECLARE
 N NUMBER := &1;
 V TIMESTAMP;
 X NUMBER ;
 SECONDS NUMBER;
BEGIN
 DBMS_APPLICATION_INFO.SET_MODULE( MODULE_NAME=> 'NEW_MODULE', ACTION_NAME=> 'CONSUME_CPU');
 V := SYSTIMESTAMP;
 SECONDS := 0 ;
 WHILE SECONDS < N  LOOP
  SECONDS := (EXTRACT( MINUTE from SYSTIMESTAMP - V )*60) + EXTRACT( SECOND from SYSTIMESTAMP - V );
  X := SQRT(DBMS_RANDOM.VALUE(1,10000));
  X := SQRT(DBMS_RANDOM.VALUE(1,10000));
 END LOOP;
END;
/

