VARIABLE B1 NUMBER
VARIABLE B2 NUMBER
VARIABLE B3 NUMBER
EXEC :B1 := 4384
EXEC :B2 := 15
SELECT PRODUCTS.PRODUCT_ID, PRODUCT_NAME, PRODUCT_DESCRIPTION, CATEGORY_ID, WEIGHT_CLASS, WARRANTY_PERIOD, SUPPLIER_ID, PRODUCT_STATUS, LIST_PRICE, MIN_PRICE, CATALOG_URL, QUANTITY_ON_HAND FROM PRODUCTS, INVENTORIES WHERE PRODUCTS.PRODUCT_ID = :B2 AND INVENTORIES.PRODUCT_ID = PRODUCTS.PRODUCT_ID AND ROWNUM < :B1;

EXEC :B1 := 93198
EXEC :B2 := 15
SELECT ORDER_ID, LINE_ITEM_ID, PRODUCT_ID, UNIT_PRICE, QUANTITY,DISPATCH_DATE, RETURN_DATE, GIFT_WRAP, CONDITION, SUPPLIER_ID, ESTIMATED_DELIVERY FROM ORDER_ITEMS WHERE ORDER_ID = :B2 AND ROWNUM < :B1;

EXEC :B1 := 584
EXEC :B2 := 15
SELECT TT.ORDER_TOTAL, TT.SALES_REP_ID, TT.ORDER_DATE, CUSTOMERS.CUST_FIRST_NAME, CUSTOMERS.CUST_LAST_NAME FROM (SELECT ORDERS.ORDER_TOTAL, ORDERS.SALES_REP_ID, ORDERS.ORDER_DATE, ORDERS.CUSTOMER_ID, RANK() OVER (ORDER BY ORDERS.ORDER_TOTAL DESC) SAL_RANK FROM ORDERS WHERE ORDERS.SALES_REP_ID = :B1 ) TT, CUSTOMERS WHERE TT.SAL_RANK <= 10 AND CUSTOMERS.CUSTOMER_ID = TT.CUSTOMER_ID;

EXEC :B1 := 11770
EXEC :B2 := 15
SELECT CUSTOMER_ID, CUST_FIRST_NAME, CUST_LAST_NAME, NLS_LANGUAGE, NLS_TERRITORY, CREDIT_LIMIT, CUST_EMAIL, ACCOUNT_MGR_ID, CUSTOMER_SINCE, CUSTOMER_CLASS, SUGGESTIONS, DOB, MAILSHOT, PARTNER_MAILSHOT, PREFERRED_ADDRESS, PREFERRED_CARD FROM CUSTOMERS WHERE CUSTOMER_ID = :B2 AND ROWNUM < :B1 ;

EXEC :B1 := 11770
EXEC :B2 := 15
SELECT ORDER_ID, ORDER_DATE, ORDER_MODE, CUSTOMER_ID, ORDER_STATUS, ORDER_TOTAL, SALES_REP_ID, PROMOTION_ID, WAREHOUSE_ID, DELIVERY_TYPE, COST_OF_DELIVERY, WAIT_TILL_ALL_AVAILABLE, DELIVERY_ADDRESS_ID, CUSTOMER_CLASS, CARD_ID, INVOICE_ADDRESS_ID FROM ORDERS WHERE CUSTOMER_ID = :B2 AND ROWNUM < :B1 ;

EXEC :B1 := 4384
EXEC :B2 := 15
SELECT CARD_ID, CUSTOMER_ID, CARD_TYPE, CARD_NUMBER, EXPIRY_DATE, IS_VALID, SECURITY_CODE FROM CARD_DETAILS WHERE CUSTOMER_ID = :B2 AND ROWNUM < :B1 ;

EXEC :B1 := 77
EXEC :B2 := 635
SELECT QUANTITY_ON_HAND FROM PRODUCT_INFORMATION P, INVENTORIES I WHERE I.PRODUCT_ID = :B2 AND I.PRODUCT_ID = P.PRODUCT_ID AND I.WAREHOUSE_ID = :B1 ;

EXEC :B1 := 43
EXEC :B2 := 618
EXEC :B3 := 15
SELECT PRODUCTS.PRODUCT_ID, PRODUCT_NAME, PRODUCT_DESCRIPTION, CATEGORY_ID, WEIGHT_CLASS, WARRANTY_PERIOD, SUPPLIER_ID, PRODUCT_STATUS, LIST_PRICE, MIN_PRICE, CATALOG_URL, QUANTITY_ON_HAND FROM PRODUCTS, INVENTORIES WHERE PRODUCTS.CATEGORY_ID = :B3 AND INVENTORIES.PRODUCT_ID = PRODUCTS.PRODUCT_ID AND INVENTORIES.WAREHOUSE_ID = :B2 AND ROWNUM < :B1 ;

EXEC :B1 := 16493
EXEC :B2 := 15
SELECT ADDRESS_ID, CUSTOMER_ID, DATE_CREATED, HOUSE_NO_OR_NAME, STREET_NAME, TOWN, COUNTY, COUNTRY, POST_CODE, ZIP_CODE FROM ADDRESSES WHERE CUSTOMER_ID = :B2 AND ROWNUM < :B1; 

EXEC :B1 := 754
SELECT ORDER_MODE, ORDERS.WAREHOUSE_ID, SUM(ORDER_TOTAL), COUNT(1) FROM ORDERS, WAREHOUSES WHERE ORDERS.WAREHOUSE_ID = WAREHOUSES.WAREHOUSE_ID AND WAREHOUSES.WAREHOUSE_ID = :B1 GROUP BY CUBE(ORDERS.ORDER_MODE, ORDERS.WAREHOUSE_ID);
