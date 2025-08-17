CREATE TABLE books ( 
author VARCHAR2(100)  NOT NULL 
,title VARCHAR2(250) NOT NULL 
,page_count NUMBER(5)
,CONSTRAINT pk_books 
PRIMARY KEY (author, title)    
);



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
