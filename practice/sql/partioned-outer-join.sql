REM   Script: Analytics - Partitioned Outer Join
REM Author: Sabyasachi Mitra
REM Date : 08/17/2025

-- date setup
alter session set current_schema = practice;
--
drop table if exists orders;
create table orders (
   order_id     int,
   customer_id  int,
   product_id   int,
   order_date   date,
   order_amount number(10,2)
);
--
drop table if exists customers;
create table customers (
   customer_id   int,
   customer_name varchar2(50)
);
--
drop table if exists products;
create table products (
   product_id       int,
   product_name     varchar2(50),
   product_category varchar2(50)
);
--
-- products
--
insert into products values ( 1,
                              'HP Pavillion',
                              'Computers' );
--
insert into products values ( 2,
                              'Dell Inspiron',
                              'Computers' );
--
insert into products values ( 3,
                              'Apple MacBook Pro',
                              'Computers' );
--
insert into products values ( 4,
                              'Samsung Galaxy S21',
                              'Mobiles' );        
--
insert into products values ( 5,
                              'Apple iPhone 13',
                              'Mobiles' );
--
insert into products values ( 6,
                              'Pro Oracle SQL 2nd Edition',
                              'Books' );
--
insert into products values ( 7,
                              'Learning SQL',
                              'Books' );
--
insert into products values ( 8,
                              'Expert Oracle Database Architecture',
                              'Books' );                                                        
--
insert into products values ( 9,
                              'Microsoft Office 2025',
                              'Software' );
--
insert into products values ( 10,
                              'Adobe Photoshop 2025',
                              'Software' );
--
select *
  from products;                              
--  
-- customers
--
insert into customers values ( 101,
                               'Jeff Smith' );
insert into customers values ( 102,
                               'Robert Brown' );
insert into customers values ( 103,
                               'Sabyasachi Mitra' );
insert into customers values ( 104,
                               'Allen Durrand' );
insert into customers values ( 105,
                               'Xinping Zhang' );
insert into customers values ( 106,
                               'Alberto Rodriguez' );
insert into customers values ( 107,
                               'Vladimir Zelenovosky' );
--
insert into customers values ( 108,
                               'Maria Garcia' );
--
insert into customers values ( 109,
                               'Ahmed Hussein' );
--
insert into customers values ( 110,
                               'Fatima Al-Farsi' );
-- orders
insert into orders values ( 1,
                            101,
                            1,
                            to_date('2025-01-15','YYYY-MM-DD'),
                            1200.00 );           
--
insert into orders values ( 2,
                            101,
                            2,
                            to_date('2025-01-16','YYYY-MM-DD'),
                            800.00 );
--
insert into orders values ( 3,
                            102,
                            3,
                            to_date('2025-01-17','YYYY-MM-DD'),
                            1500.00 );
--
insert into orders values ( 4,
                            103,
                            4,
                            to_date('2025-01-18','YYYY-MM-DD'),
                            999.99 );
--
insert into orders values ( 8,
                            103,
                            8,
                            to_date('2025-01-22','YYYY-MM-DD'),
                            49.99 );                            
--
insert into orders values ( 5,
                            104,
                            5,
                            to_date('2025-01-19','YYYY-MM-DD'),
                            1099.99 );
--
insert into orders values ( 6,
                            105,
                            6,
                            to_date('2025-01-20','YYYY-MM-DD'),
                            59.99 );
--
insert into orders values ( 7,
                            105,
                            7,
                            to_date('2025-01-21','YYYY-MM-DD'),
                            39.99 );
--
insert into orders values ( 9,
                            106,
                            9,
                            to_date('2025-01-23','YYYY-MM-DD'),
                            199.99 );                 
--
commit;
--
--
with prod_ord as (
   select p.product_id,
          p.product_name,
          o.order_id,
          o.customer_id,
          o.order_date,
          o.order_amount
     from products p
     left outer join orders o
   on p.product_id = o.product_id
)
select c.customer_id,
       o.product_name,
       c.customer_name,
       nvl(
          o.order_amount,
          0
       ) order_amount,
       nvl(
          o.order_date,
          '01-JAN-1753'
       ) order_date
  from customers c
  left outer join prod_ord o partition by ( o.product_id,
                                            o.product_name )
on c.customer_id = o.customer_id
 order by c.customer_id,
          o.product_id;
--
drop table if exists students;
create table students (
   student_id   number(10) primary key,
   student_name varchar2(100)
);
--
drop table if exists student_attendance;
create table student_attendance (
   student_id      number(10),
   attendance_date date,
   status          varchar2(10)
);
--
-- students
--
insert into students values ( 1,
                              'John Doe' );
insert into students values ( 2,
                              'Jane Smith' );
insert into students values ( 3,
                              'Alice Johnson' );
insert into students values ( 4,
                              'Bob Brown' );
insert into students values ( 5,
                              'Charlie White' );
insert into students values ( 6,
                              'David Black' );
insert into students values ( 7,
                              'Eva Green' );
insert into students values ( 8,
                              'Frank Blue' );
insert into students values ( 9,
                              'Grace Yellow' );
insert into students values ( 10,
                              'Hannah Purple' );
--
-- attendence
--
insert into student_attendance values ( 1,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Present' );
insert into student_attendance values ( 2,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Absent' );
insert into student_attendance values ( 3,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Present' );
insert into student_attendance values ( 4,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Present' );
insert into student_attendance values ( 5,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Absent' );
insert into student_attendance values ( 6,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Present' );
insert into student_attendance values ( 7,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Absent' );
insert into student_attendance values ( 8,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Present' );
insert into student_attendance values ( 9,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Present' );
insert into student_attendance values ( 10,
                                        to_date('2025-01-01','YYYY-MM-DD'),
                                        'Absent' );