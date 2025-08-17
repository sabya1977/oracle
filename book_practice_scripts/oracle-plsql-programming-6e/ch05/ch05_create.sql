CREATE OR REPLACE PROCEDURE set_rank(ranking_level_in IN NUMBER)
IS
BEGIN
  dbms_output.put_line('Ranking level is: '||ranking_level_in);
END set_rank;
/

CREATE OR REPLACE PROCEDURE set_all_ranks (max_rank_in IN INTEGER)
IS
   ranking_level   NUMBER (3) := 1;
BEGIN
   LOOP
      EXIT WHEN ranking_level > max_rank_in;
      set_rank (ranking_level);
      ranking_level :=   ranking_level + 1;
   END LOOP;
END set_all_ranks;
/

CREATE OR REPLACE PROCEDURE set_all_ranks2 (max_rank_in IN INTEGER)
IS
BEGIN
   FOR ranking_level IN 1 .. max_rank_in
   LOOP
      set_rank (ranking_level);
   END LOOP;
END set_all_ranks2;
/

CREATE OR REPLACE PROCEDURE set_all_ranks3 (max_rank_in IN INTEGER)
IS
   ranking_level NUMBER(3) := 1;
BEGIN
   WHILE ranking_level <= max_rank_in
   LOOP
      set_rank (ranking_level);
      ranking_level := ranking_level + 1;
   END LOOP;
END set_all_ranks3;
/

DROP TABLE accounts;

CREATE TABLE accounts(
  account_id  NUMBER  NOT NULL  PRIMARY KEY,
  balance  NUMBER );

INSERT INTO accounts(
  account_id,
  balance )
VALUES(
  1,
  1000 );

INSERT INTO accounts(
  account_id,
  balance )
VALUES(
  2,
  800 );
  
COMMIT;

CREATE OR REPLACE FUNCTION account_balance(
  account_id_in IN accounts.account_id%TYPE)
RETURN accounts.balance%TYPE
IS
  l_balance  accounts.balance%TYPE;
BEGIN

  SELECT balance
    INTO l_balance
    FROM accounts
   WHERE account_id = account_id_in;

  RETURN l_balance;

END account_balance;
/

CREATE OR REPLACE PROCEDURE apply_balance(
  account_id_in IN accounts.balance%TYPE,
  balance_in IN accounts.balance%TYPE)
IS
BEGIN
  UPDATE accounts
     SET balance = balance - balance_in
   WHERE account_id = account_id_in;
END apply_balance;
/

CREATE OR REPLACE PROCEDURE calc_values(value_in IN NUMBER) IS
BEGIN
  dbms_output.PUT_LINE('calc_value: '||value_in);
END;
/

DROP TABLE occupancy;

CREATE TABLE occupancy (
  pet_id  NUMBER  NOT NULL  PRIMARY KEY,
  name  VARCHAR2(30)  NOT NULL,
  room_number  VARCHAR2(30)  NOT NULL,
  occupied_dt  DATE,
  checkout_date  DATE );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt, checkout_date )
VALUES( 1, 'Bingo', '10A', TRUNC(SYSDATE), TRUNC(SYSDATE) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 2, 'Chloe', '12A', TRUNC(SYSDATE) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt, checkout_date )
VALUES( 3, 'Kitty', '12B', TRUNC(SYSDATE), TRUNC(SYSDATE) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 4, 'Blaze', '10A', TRUNC(SYSDATE+1) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 5, 'Sugar', '12A', TRUNC(SYSDATE+1) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 6, 'Itchy', '12B', TRUNC(SYSDATE+1) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 7, 'Scratchy', '10A', TRUNC(SYSDATE+2) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 8, 'Felix', '12A', TRUNC(SYSDATE+2) );

INSERT INTO occupancy( pet_id, name, room_number, occupied_dt )
VALUES( 9, 'Bob', '12B', TRUNC(SYSDATE+2) );

COMMIT;

DROP TABLE occupancy_history;

CREATE TABLE occupancy_history AS
SELECT pet_id,
       name,
       checkout_date
  FROM occupancy
 WHERE 1 = 2;

CREATE OR REPLACE PROCEDURE update_bill(
  pet_id_in  occupancy.pet_id%TYPE,
  room_number_in  occupancy.room_number%TYPE )
IS
BEGIN
  dbms_output.put_line('bill updated for pet_id = '||pet_id_in||', room_number = '||room_number_in);
END update_bill;
/

CREATE OR REPLACE PROCEDURE build_schedule(
  i_in  IN  PLS_INTEGER,
  j_in  IN  PLS_INTEGER,
  k_in  IN  PLS_INTEGER )
IS
BEGIN
  dbms_output.put_line('building ('||i_in||', '||j_in||', '||k_in||') !');
END build_schedule;
/

DROP TABLE books;

CREATE TABLE books(
  book_id  NUMBER  NOT NULL  PRIMARY KEY,
  title  VARCHAR2(200),
  author  VARCHAR2(200) );

INSERT INTO books VALUES(1, 'Oracle SQL*Plus', 'GENNICK,JONATHAN');

INSERT INTO books VALUES(2, 'Oracle PL/SQL Programming', 'FEUERSTEIN,STEVEN');

INSERT INTO books VALUES(3, 'Oracle Built-in Packages', 'FEUERSTEIN,STEVEN');

COMMIT;

CREATE OR REPLACE PACKAGE ch05_globals AS

  CURSOR checked_out_cur IS 
  SELECT pet_id, name, checkout_date 
    FROM occupancy 
   WHERE  checkout_date IS NOT NULL;
   
  SUBTYPE checked_out_typ IS checked_out_cur%ROWTYPE;

END ch05_globals;
/

CREATE OR REPLACE PROCEDURE log_checkout_error (
  checked_out_rec_in IN ch05_globals.checked_out_typ )
IS
BEGIN
  dbms_output.put_line('!!! Checkout error for');
  dbms_output.put_line('...   pet:           '||checked_out_rec_in.pet_id);
  dbms_output.put_line('...   name:          '||checked_out_rec_in.name);
  dbms_output.put_line('...   checkout_date: '||checked_out_rec_in.checkout_date);
END log_checkout_error;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
