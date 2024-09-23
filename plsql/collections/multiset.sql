-- name:multiset.sql
-- MULTISET operator joins collections togather and perform set operations on them.
-- 
-- MULTISET UNION
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_tab1 t_tab := t_tab(1,2,3,4,5,6);
  l_tab2 t_tab := t_tab(5,6,7,8,9,10);
BEGIN
  l_tab1 := l_tab1 MULTISET UNION l_tab2;
  
  DBMS_OUTPUT.put_line ('MULTISET UNION');
  DBMS_OUTPUT.put_line ('______________');
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;
END;
/
-- 
/*
MULTISET UNION
______________
1
2
3
4
5
6
5
6
7
8
9
10
*/
-- 
-- MULTISET UNION DISTINCT
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_tab1 t_tab := t_tab(1,2,3,4,5,6);
  l_tab2 t_tab := t_tab(5,6,7,8,9,10);
BEGIN
  l_tab1 := l_tab1 MULTISET UNION DISTINCT l_tab2;
  
  DBMS_OUTPUT.put_line ('MULTISET UNION DISTINCT');
  DBMS_OUTPUT.put_line ('_______________________');
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;
END;
/
-- 
/*
MULTISET UNION DISTINCT
_______________________
1
2
3
4
5
6
7
8
9
10
*/
-- 
-- MULTISET EXCEPT {DISTINCT}
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_tab1 t_tab := t_tab(1,2,3,4,5,5,6,7,8,9,10);
  l_tab2 t_tab := t_tab(6,7,8,9,10);
BEGIN
  l_tab1 := l_tab1 MULTISET EXCEPT DISTINCT l_tab2;
  
  DBMS_OUTPUT.put_line ('MULTISET EXCEPT');
  DBMS_OUTPUT.put_line ('_______________________');
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;
END;
/
-- 
/*
MULTISET EXCEPT
_______________________
1
2
3
4
5
*/
-- 
-- MULTISET INTERSECT {DISTINCT} Operator
-- 
-- The MULTISET INTERSECT operator returns the elements that are present 
-- in both sets, doing the equivalent of the INTERSECT set operator. 
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_tab1 t_tab := t_tab(1,2,3,4,5,6,6,7,8,9,10);
  l_tab2 t_tab := t_tab(6,6,7,8,9,10);
BEGIN
  l_tab1 := l_tab1 MULTISET INTERSECT DISTINCT l_tab2;
  DBMS_OUTPUT.put_line ('MULTISET INTERSECT');
  DBMS_OUTPUT.put_line ('__________________');
  FOR i IN l_tab1.first .. l_tab1.last LOOP
    DBMS_OUTPUT.put_line(l_tab1(i));
  END LOOP;
END;
/
-- 
/*
MULTISET INTERSECT
__________________
6
7
8
9
10
*/
-- 
-- MULTISET :: IS {NOT} A SET Condition
-- 
-- The IS {NOT} A SET condition is used to test if 
-- a collection is populated by unique elements, or not.
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF NUMBER;
  l_null_tab      t_tab := NULL;
  l_empty_tab     t_tab := t_tab();
  l_set_tab       t_tab := t_tab(1,2,3,4);
  l_not_set_tab   t_tab := t_tab(1,2,3,4,4,4);

  FUNCTION display (p_in BOOLEAN) RETURN VARCHAR2 AS
  BEGIN
    IF p_in IS NULL THEN
      RETURN 'NULL';
    ELSIF p_in THEN
      RETURN 'TRUE';
    ELSE
      RETURN 'FALSE';
    END IF;
  END;
BEGIN
  DBMS_OUTPUT.put_line('l_null_tab IS A SET          = ' || display(l_null_tab IS A SET));
  DBMS_OUTPUT.put_line('l_null_tab IS NOT A SET      = ' || display(l_null_tab IS NOT A SET));
  DBMS_OUTPUT.put_line('l_empty_tab IS A SET         = ' || display(l_empty_tab IS A SET));
  DBMS_OUTPUT.put_line('l_empty_tab IS NOT A SET     = ' || display(l_empty_tab IS NOT A SET));
  DBMS_OUTPUT.put_line('l_set_tab IS A SET           = ' || display(l_set_tab IS A SET));
  DBMS_OUTPUT.put_line('l_set_tab IS NOT A SET       = ' || display(l_set_tab IS NOT A SET));
  DBMS_OUTPUT.put_line('l_not_set_tab IS A SET       = ' || display(l_not_set_tab IS A SET));
  DBMS_OUTPUT.put_line('l_not_set_tab IS NOT A SET   = ' || display(l_not_set_tab IS NOT A SET));
END;
/
-- 
/*
l_null_tab IS A SET          = NULL
l_null_tab IS NOT A SET      = NULL
l_empty_tab IS A SET         = TRUE
l_empty_tab IS NOT A SET     = FALSE
l_set_tab IS A SET           = TRUE
l_set_tab IS NOT A SET       = FALSE
l_not_set_tab IS A SET       = FALSE
l_not_set_tab IS NOT A SET   = TRUE
*/



































































