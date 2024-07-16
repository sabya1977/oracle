-- Author Steven Feuerstein

-- Introduction:
--
-- In my introduction to table functions, I showed how to build and "query" from a table function that returns 
-- a collection of scalars (number, date, string, etc.). If that's all you need to do, well, lucky you!

-- Most of the time, however, you need to pass back a row of data consisting of more than one value, just as you 
-- would with "regular" tables when, say, you needed the ID and last name of all employees in department 10, as in:

SELECT employee_id, last_name
  FROM hr.employees
 WHERE department_id = 10
/
--
-- This module explores how you can go about doing that with table functions.
--
-- Just Use %ROWTYPE?
-- You will undoubtedly be tempted, as I was tempted when first working with table functions, to use the 
-- %ROWTYPE as an attribute for the nested table type. This will not work. Let's take a quick look. Suppose 
-- I want my table function to return rows that could be inserted into this table:
--
CREATE TABLE animals
(
   name VARCHAR2 (10),
   species VARCHAR2 (20),
   date_of_birth DATE
)
/
-- The most straightforward way for a developer familiar with PL/SQL would be to do something like this:

CREATE TYPE animals_nt IS TABLE OF animals%ROWTYPE;
/

CREATE OR REPLACE FUNCTION lots_of_animals RETURN animals_nt
...
/
-- Unfortunately, when you run this code you will see the following error:

-- PLS-00329: schema-level type has illegal reference to .ANIMALS
-- That might be frustrating, but it sure makes a lot of sense. PL/SQL is a language that offers procedural 
-- "extensions" to SQL. So PL/SQL knows all bout SQL, but SQL doesn't know or recognize PL/SQL-specific constructs
-- (for the most part). "%ROWTYPE" is not a part of SQL and the CREATE TYPE statement is a SQL DDL statement, not 
-- a PL/SQL statement. So that won't work.

-- So what's a developer supposed to do? Use object types!
-- 
--
-- Object Type Mimics Table:
--
-- Your table function's collection type must be an object type whose attributes look 
-- "just like" the columns of the dataset you want returned by the table function.

-- Relatively few developers have used the object-oriented features of Oracle Database, which 
-- can make this step seem a bit intimidating. Don't worry! You will be using a very small portion 
-- of these features, and nothing actually that is object-oriented. If you'd like more information 
-- about our O-O features, though, check the Links at the bottom of this module.

-- So first I create an object type with attributes that match the table in both number and type. 
-- Then I create a nested table of those types.

CREATE TYPE animal_ot IS OBJECT
(
   name VARCHAR2 (10),
   species VARCHAR2 (20),
   date_of_birth DATE
);
/
--
CREATE TYPE animals_nt IS TABLE OF animal_ot;
/
-- With this collection type in place, I can now build my table function. In the code below, I define a function 
-- that accepts two object types (the dad and the mom) and returns a collection with the whole family: mom, dad and kids. 
-- The number of kids varies according to the species. Rabbits have more babies, on average, than kangaroos.

-- Here's an explanation of the code below (line numbers are visible after you insert the code into the editor):

-- Lines 1-2: Two object type instances come in, one collection of those types comes out.
-- 
-- Line 5: Declare the local variable I will fill up and return for processing in the SELECT. Initialize it with the 
-- mom and dad via the call to the constructor function.
-- 
-- Lines 7-12: Start the loop to fill up the collection. The CASE expression on the mother's species determines the 
-- number of elements to go in the collection.
-- 
-- Line 14: Extend the collection, adding a new element with a value of NULL.
-- 
-- Lines 15-18: Put the babies in the collection in the new LAST row. I do so by calling the constructor function 
-- for the object type and passing in a value for each attribute. Note: this logic has nothing to do per se with 
-- a table function. It's just how you work with object types.
-- 
-- Line 21: Return the collection to be used by the query.

CREATE OR REPLACE FUNCTION animal_family (dad_in IN animal_ot, mom_in IN animal_ot)
   RETURN animals_nt
   AUTHID DEFINER
IS
   l_family   animals_nt := animals_nt (dad_in, mom_in);
BEGIN
   FOR indx IN 1 ..
               CASE mom_in.species
                  WHEN 'RABBIT' THEN 12
                  WHEN 'DOG' THEN 4
                  WHEN 'KANGAROO' THEN 1
               END
   LOOP
      l_family.EXTEND;
      l_family (l_family.LAST) :=
         animal_ot ('BABY' || indx,
                 mom_in.species,
                 ADD_MONTHS (SYSDATE, -1 * DBMS_RANDOM.VALUE (1, 6)));
   END LOOP;

   RETURN l_family;
END;
/
--
--
-- Use the Table Function:
--
-- In my SELECT, I can reference the names of the attributes as the names of the columns in the dataset returned 
-- by the TABLE clause. Notice that I do not need a table alias (which is required when a column in your relational
-- table is an object type and you want to reference an attribute of the type). The SQL engine simply hides all the 
-- work it is doing to convert each attribute of the object type in the array to a column. Thanks, SQL!

SELECT name, species, date_of_birth
  FROM TABLE (
          animal_family (animal_ot ('Hoppy', 'RABBIT', SYSDATE - 500),
                         animal_ot ('Hippy', 'RABBIT', SYSDATE - 300)))
/ 
-- Here's an example of taking the result set from the function and inserted them directly into the table. 
-- This works so smoothly because the animal_ot object type attributes match the columns of the table.

INSERT INTO animals
SELECT name, species, date_of_birth
  FROM TABLE (
          animal_family (animal_ot ('Hoppy', 'RABBIT', SYSDATE - 500),
                         animal_ot ('Hippy', 'RABBIT', SYSDATE - 300)))
/ 
-- Of course, there's more to life than just rabbits, so let's make sure our function 
-- works (and works differently) for kangaroos.

SELECT name, species, date_of_birth
  FROM TABLE (
          animal_family (animal_ot ('Bob',   'KANGAROO', SYSDATE - 1000),
                         animal_ot ('Sally', 'KANGAROO', SYSDATE - 700)))
/
--
-- Summary:

-- Most of the table functions I have written needed to return more than a single value in each collection element. 
-- Fortunately, Oracle Database makes it easy for us to accomplish this. Simply:

-- Define an object type whose attributes match the name, number and type of values you want to reference in the SELECT.
-- Define a schema-level nested table or varray type of those object types.
-- Create a function that returns a collection of that type, and inside the function use the constructor functions for 
-- both types to fill the collection as needed.