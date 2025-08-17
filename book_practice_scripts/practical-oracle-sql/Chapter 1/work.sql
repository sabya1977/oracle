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