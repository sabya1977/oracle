--
drop table contracts purge;
create table contracts (
   id     number,
   dur_yy interval year(4) to month,
   dur_mm interval year to month,
   dur_dd interval day to second
); 
--
insert into contracts values ( 1,
                               interval '2-6' year to month,
                               interval '3 12:45:30.500' day to second );
--
insert into contracts values ( 2,
                               interval '2025' year ( 4 ),
                               interval '5' day );   
--

--