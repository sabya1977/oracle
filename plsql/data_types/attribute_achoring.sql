-- Name: attribute-achoring.sql
-- Attribute anchoring lets you anchor the data type in a program to a column in a table. 
-- Table anchoring lets you anchor a composite variable, like a RECORD type, to a table or
-- cursor structure.
--
create table ora_demo.books (
	b_id   number,
	b_name varchar2(100),
	author varchar2(20),
	price  number(8,2)
);
--
insert into ora_demo.books values (
	1,
	'Classical Poetry',
	'Keats',
	33.40
);
--
insert into ora_demo.books values (
	2,
	'Classical Drama',
	'Shakespere',
	45.40
);
--
insert into ora_demo.books values (
	3,
	'Harry Poter',
	'Rowling',
	10.00
);
commit;
--
-- Field anchoring using %TYPE
--
set SERVEROUTPUT on
declare
	lv_b_name ora_demo.books.b_name%type := 'Paranoid';
	cursor c_book_cur is
	select b_name
	  from ora_demo.books;
begin
	open c_book_cur;
	loop
		fetch c_book_cur into lv_b_name;
		exit when c_book_cur%notfound;
		dbms_output.put_line('Book Name: ' || lv_b_name);
	end loop;
end;
/
--
-- Table anchoring using %ROWTYPE
--
set SERVEROUTPUT on
DECLARE
	CURSOR c_books_cur IS
	SELECT b_name,
	       author
	  FROM ora_demo.books;
	lv_books c_books_cur%ROWTYPE;
BEGIN
	OPEN c_books_cur;
	LOOP
		FETCH c_books_cur INTO lv_books;
		EXIT WHEN c_books_cur%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(lv_books.b_name
		                     || ' '
		                     || lv_books.author);
	END LOOP;
	CLOSE c_books_cur;
END;
/
--
-- visible and invisible column anchoring
--
DROP TABLE ora_demo.books;
--
CREATE TABLE ora_demo.books (
	b_id   NUMBER,
	b_name VARCHAR2(100),
	author VARCHAR2(20),
	price  NUMBER(8,2) invisible
);
--
insert into  ora_demo.books 
(b_id, b_name, author, price)
values (
	1,
	'Classical Poetry',
	'Keats',
	33.40
);
--
insert into ora_demo.books 
(b_id, b_name, author, price)
values (
	2,
	'Classical Drama',
	'Shakespere',
	45.40
);
--
insert into ora_demo.books 
(b_id, b_name, author, price)
values (
	3,
	'Harry Poter',
	'Rowling',
	10.00
);
commit;
--
-- SELECT * will display only visible columns.
-- To display invisible columns we have to explicitly mention the column names.
--
SELECT * FROM ora_demo.books;
--
DECLARE
	CURSOR c_books_cur IS
	SELECT *
	  FROM ora_demo.books;
	lv_books c_books_cur%ROWTYPE;
BEGIN
	OPEN c_books_cur;
	LOOP
		FETCH c_books_cur INTO lv_books;
		EXIT WHEN c_books_cur%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(lv_books.b_name
		                     || ' '
		                     || lv_books.price);
	END LOOP;
	CLOSE c_books_cur;
END;
/
-- Error! as price is invisible column
-- PLS-00302: component 'PRICE' must be declared
--
-- Below code specifies price column in the cursor SELECT explicitly.
--
DECLARE
	CURSOR c_books_cur IS
	SELECT b_name, price
	  FROM ora_demo.books;
	lv_books c_books_cur%ROWTYPE;
BEGIN
	OPEN c_books_cur;
	LOOP
		FETCH c_books_cur INTO lv_books;
		EXIT WHEN c_books_cur%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(lv_books.b_name
		                     || ' '
		                     || lv_books.price);
	END LOOP;
	CLOSE c_books_cur;
END;
/
