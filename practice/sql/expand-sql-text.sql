   set serveroutput on
declare
   input_1  clob;
   output_1 clob;
begin
   input_1 := q'!select *
  from practical.brewery_products!';
   dbms_utility.expand_sql_text(
      input_1,
      output_1
   );
   dbms_output.put_line('The result is: ');
   dbms_output.put_line(output_1);
end;
/
rem
select "A1"."BREWERY_ID" "BREWERY_ID",
       "A1"."BREWERY_NAME" "BREWERY_NAME",
       "A1"."PRODUCT_ID" "PRODUCT_ID",
       "A1"."PRODUCT_NAME" "PRODUCT_NAME"
  from (
   select "A2"."QCSJ_C000000000400000_0" "BREWERY_ID",
          "A2"."QCSJ_C000000000400002_1" "BREWERY_NAME",
          "A2"."QCSJ_C000000000400001_2" "PRODUCT_ID",
          "A2"."QCSJ_C000000000400003_3" "PRODUCT_NAME"
     from (
      select "A4"."ID" "QCSJ_C000000000400000_0",
             "A4"."NAME" "QCSJ_C000000000400002_1",
             "A3"."ID" "QCSJ_C000000000400001_2",
             "A3"."NAME" "QCSJ_C000000000400003_3"
        from "PRACTICAL"."BREWERIES" "A4",
             "PRACTICAL"."PRODUCTS" "A3"
   ) "A2"
    where exists (
      select null "NULL"
        from "PRACTICAL"."PURCHASES" "A5"
       where "A5"."BREWERY_ID" = "A2"."QCSJ_C000000000400000_0"
         and "A5"."PRODUCT_ID" = "A2"."QCSJ_C000000000400001_2"
   )
) "A1";
rem
select *
  from dba_views
 where view_name = 'BREWERY_PRODUCTS';