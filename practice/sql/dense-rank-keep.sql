-- 
-- Desc: Illustrate the use of KEEP clause in analytic SQL
-- Date: 11-03-2024
-- Author: Sabyasachi Mitra
-- 
-- 
select *
  from practice.cities;
rem ******************************************************************
rem                         Example 1 with cities
rem ******************************************************************
-- Suppose we are asked to produce number of cities 
-- in a country along with maximum population.
select country,
       count(*) num_city,
       max(population) max_pop
  from cities
 group by country
having count(*) > 1000;
-- 
-- In this output while maximum population is given but city name is not given.
-- 
/*
COUNTRY              NO_CITY     MAX_POP
_________________ __________ ___________
United States           5324    18908608
Brazil                  2937    23086000
Italy                   1355     2748109
Japan                   1337    37732000
Russia                  1217    17332000
Germany                 1747     4890363
France                  1152    11060000
China                   1663    26940000
Philippines             1584    24922000
India                   7031    32226000
United Kingdom          1331    11262000
*/
-- 
-- If we add city name in the query, we will 
-- get an error that city is not part of GROUP 
-- BY clause.
-- 
select country,
       city,
       count(*) num_city,
       max(population) max_pop
  from cities
 group by country
having count(*) > 1000;
-- 
-- SQL Error: ORA-00979: not a GROUP BY expression
-- 
-- One way to get the city name is to use subquery factoring
-- 
with city_max as (
   select country,
          count(*) num_city,
          max(population) max_pop
     from cities
    group by country
   having count(*) > 1000
)
select cm.country,
       c.city,
       cm.num_city,
       cm.max_pop
  from cities c
 inner join city_max cm
on c.country = cm.country
   and c.population = cm.max_pop;
-- 
-- Another way of achieving this result is to using analytic function
-- 
-- 
with max_pop_city as (
   select country,
          city,
          population,
          count(*)
          over(partition by country) as num_city,
          max(population)
          over(partition by country) as max_pop
     from cities
)
select mc.country,
       mc.city,
       mc.population
  from max_pop_city mc
 where mc.max_pop = population
   and mc.num_city > 1000;
-- 
/*

COUNTRY           CITY            POPULATION
_________________ ____________ _____________
Brazil            Sπo Paulo         23086000
China             Guangzhou         26940000
France            Paris             11060000
Germany           Berlin             4890363
India             Delhi             32226000
Italy             Rome               2748109
Japan             Tokyo             37732000
Philippines       Manila            24922000
Russia            Moscow            17332000
United Kingdom    London            11262000
United States     New York          18908608
*/
-- 
-- But the more concise way to produce the same result is to use KEEP clause
-- 
select country,
       max(city) keep(dense_rank first order by population desc nulls last) city,
       count(*) num_city,
       max(population) max_pop
  from practice.cities
 group by country
having count(*) > 1000;
-- 
/*
COUNTRY           CITY            NUM_CITY     MAX_POP
_________________ ____________ ___________ ___________
Brazil            Sπo Paulo           2937    23086000
China             Guangzhou           1663    26940000
France            Paris               1152    11060000
Germany           Berlin              1747     4890363
India             Delhi               7031    32226000
Italy             Rome                1355     2748109
Japan             Tokyo               1337    37732000
Philippines       Manila              1584    24922000
Russia            Moscow              1217    17332000
United Kingdom    London              1331    11262000
United States     New York            5324    18908608
*/
--
drop table if exists practice.emp;
create table practice.emp (
   emp_id     number,
   emp_name   varchar2(100),
   emp_salary number,
   dept_id    number,
   job_id     number
);
--
drop table if exists practice.dept;
create table practice.dept (
   dept_id   number,
   dept_name varchar2(100)
);
--
drop table if exists practice.job;
create table practice.job (
   job_id   number,
   job_name varchar2(100)
);
--
insert into practice.job values ( 10,
                                  'Manager' );
insert into practice.job values ( 20,
                                  'Analyst' );
insert into practice.job values ( 30,
                                  'Clerk' );
insert into practice.job values ( 40,
                                  'Sales' );
insert into practice.job values ( 50,
                                  'Support' );
insert into practice.job values ( 60,
                                  'Executive' );
insert into practice.job values ( 70,
                                  'IT' );
--
insert into practice.emp values ( 1,
                                  'John',
                                  5000,
                                  10,
                                  10 );
insert into practice.emp values ( 2,
                                  'Jane',
                                  6000,
                                  20,
                                  20 );
insert into practice.emp values ( 3,
                                  'Smith',
                                  5500,
                                  10,
                                  30 );
insert into practice.emp values ( 4,
                                  'Emily',
                                  7000,
                                  20,
                                  40 );
insert into practice.emp values ( 5,
                                  'Michael',
                                  8000,
                                  30,
                                  50 );
insert into practice.emp values ( 6,
                                  'Sarah',
                                  9000,
                                  30,
                                  60 );
insert into practice.emp values ( 7,
                                  'David',
                                  10000,
                                  40,
                                  70 );
insert into practice.emp values ( 8,
                                  'Emma',
                                  11000,
                                  40,
                                  80 );
insert into practice.emp values ( 9,
                                  'Oliver',
                                  12000,
                                  50,
                                  90 );
insert into practice.emp values ( 10,
                                  'Sophia',
                                  13000,
                                  50,
                                  10 );
insert into practice.emp values ( 11,
                                  'Liam',
                                  14000,
                                  60,
                                  20 );
insert into practice.emp values ( 12,
                                  'Olivia',
                                  15000,
                                  60,
                                  30 );
insert into practice.emp values ( 13,
                                  'Noah',
                                  16000,
                                  70,
                                  40 );
insert into practice.emp values ( 14,
                                  'Emma',
                                  17000,
                                  70,
                                  50 );
insert into practice.emp values ( 15,
                                  'James',
                                  18000,
                                  80,
                                  60 );
insert into practice.emp values ( 16,
                                  'Isabella',
                                  19000,
                                  80,
                                  70 );
insert into practice.emp values ( 17,
                                  'Mia',
                                  20000,
                                  90,
                                  10 );
insert into practice.emp values ( 18,
                                  'William',
                                  21000,
                                  90,
                                  20 );
insert into practice.emp values ( 19,
                                  'Ava',
                                  22000,
                                  100,
                                  30 );
insert into practice.emp values ( 20,
                                  'Sophia',
                                  23000,
                                  100,
                                  40 );
--
insert into practice.dept values ( 10,
                                   'HR' );
insert into practice.dept values ( 20,
                                   'Finance' );
insert into practice.dept values ( 30,
                                   'IT' );
insert into practice.dept values ( 40,
                                   'Marketing' );
insert into practice.dept values ( 50,
                                   'Sales' );
insert into practice.dept values ( 60,
                                   'Operations' );
insert into practice.dept values ( 70,
                                   'Customer Support' );
insert into practice.dept values ( 80,
                                   'Legal' );
insert into practice.dept values ( 90,
                                   'R and D' );
insert into practice.dept values ( 100,
                                   'Product Management' );
commit;
--
select dept_name,
       count(*) num_emp,
       max(emp_salary) max_salary,
       max(e.emp_name) keep(dense_rank first order by e.emp_salary desc) employee_name,
       max(e.emp_id) keep(dense_rank first order by e.emp_salary desc) employee_id,
       max(j.job_name) keep(dense_rank first order by e.emp_salary desc) job_name
  from practice.emp e
 inner join practice.dept d
on e.dept_id = d.dept_id
 inner join practice.job j
on e.job_id = j.job_id
 group by dept_name;
--
select *
  from practice.dept;