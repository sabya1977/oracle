alter session set current_schema = practical;
select *
  from practical.yearly_sales ys
 inner join practical.brewery_products bp
on bp.product_id = ys.product_id
 order by ys.yr,
          bp.brewery_id,
          bp.product_id;
-
select *
  from practical.yearly_sales ys
 inner join practical.brewery_products bp
on bp.product_id = ys.product_id
 order by
          bp.product_id;
--
select * from practical.brewery_products;
--
select dbms_metadata.get_ddl(
   'VIEW',
   'BREWERY_PRODUCTS',
   'PRACTICAL'
)
  from dual;       
--
select substr('2017;582',1, instr(
   '2017;582',
   ';') -1
) as yr,
    substr('2017;582', instr(
       '2017;582',
       ';') + 1
) as yr_qty
  from dual;
--
select instr(
   'Hello World', -- string to search 
   'o', -- string/character to find
   1, -- start position
   2 -- occurrence
);
--
select instr(
   'Hello World', -- string to search 
   'o', -- string/character to find
   1, -- start position
   1 -- occurrence
);
--
select instr(
   'Hello World', -- string to search 
   'o', -- string/character to find
   -1, -- backward start position
   1 -- occurrence from the start position
);
--
select ys.yr,
       ys.yr_qty
  from yearly_sales ys
   --  where ys.product_id = bp.product_id
 order by ys.yr_qty desc
 fetch first row only;
 --
 select ys.yr,
       ys.yr_qty
  from yearly_sales ys
 where ys.product_id in (5310, 5430, 6520)
  --  and ys.yr_qty < 400
 order by ys.yr_qty desc;
 fetch first row only;
 --
 select * from practical.brewery_products where brewery_id = 518;