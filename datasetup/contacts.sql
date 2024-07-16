REM   Script: Contacts Schema
REM   Simple schema to use to practice SQL

create table contacts ( 
id number generated as identity primary key, 
fname varchar2(100), 
lname varchar2(100), 
email varchar2(255), 
contact_type varchar2(30), 
age          integer 
);

create table children ( 
id number generated always as identity primary key, 
contact_id number references contacts (id), 
fname varchar2(30), 
age   integer);

create table hobbies ( 
id number generated always as identity primary key, 
contact_id number references contacts (id), 
hobby varchar2(100) 
) ;

insert into contacts (fname,lname, email, contact_type, age) values ('Dave','Smith','dsmith@icloud.com', 'friend', 46);

insert into contacts (fname,lname, email, contact_type, age) values ('Xena','Johnson','xjonson@icloud.com', 'friend', 46);

insert into contacts (fname,lname, email, contact_type, age) values ('Fred','Jackon','fjackson@icloud.com', 'co-worker', 18);

insert into contacts (fname,lname, email, contact_type, age) values 
  ('Alma','Tyler','atyler@icloud.com', 'contact', 57)


insert into contacts (fname,lname, email, contact_type, age) values 
  ('Jane','Edwards','jedwards@icloud.com', 'contact', 40)


insert into contacts (fname,lname, email, contact_type, age) values 
  ('Jill','Jackson','jjackson@icloud.com', 'friend', 24)


insert into children (contact_id, fname, age) values (5, 'Sam', 5)


select * from contacts


insert into children (contact_id, fname, age) values (1, 'Ruby', 2)


insert into children (contact_id, fname, age) values (1, 'Robert', 4);


insert into children (contact_id, fname, age) values (1, 'Roman', 6);


insert into hobbies (contact_id, hobby) values (1, 'Horseback Riding')


insert into hobbies (contact_id, hobby) values (2, 'Sailing')


insert into hobbies (contact_id, hobby) values (1, 'Guitar')


insert into hobbies (contact_id, hobby) values (3, 'Skiing')


insert into hobbies (contact_id, hobby) values (3, 'Scuba')


insert into hobbies (contact_id, hobby) values (4, 'Photography')


insert into hobbies (contact_id, hobby) values (6, 'Travel')


select fname, lname, 
   (select count(*) from children c where x.id = c.contact_id) children,
   (select count(*) from hobbies h where x.id = h.contact_id) Hobbies
from contacts x
order by 1, 2


