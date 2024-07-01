DROP TABLE SOE.ORDER_ITEMS2;
DROP TABLE SOE.ORDERS2;
--
CREATE TABLE SOE.ORDERS2
( 
	ORDER_ID NUMBER(12),
	ORDER_DATE TIMESTAMP(6) WITH LOCAL TIME ZONE,
	ORDER_MODE VARCHAR2(8),
	CUSTOMER_ID NUMBER(12),
	ORDER_STATUS NUMBER(2),
	ORDER_TOTAL NUMBER(8,2),
	SALES_REP_ID NUMBER(6),
	PROMOTION_ID NUMBER(6),
	WAREHOUSE_ID NUMBER(6),
	DELIVERY_TYPE VARCHAR2(15),
	COST_OF_DELIVERY NUMBER(6),
	WAIT_TILL_ALL_AVAILABLE VARCHAR2(15),
	DELIVERY_ADDRESS_ID NUMBER(12),
	CUSTOMER_CLASS VARCHAR2(30),
	CARD_ID NUMBER(12),
	INVOICE_ADDRESS_ID NUMBER(12)
);
--
INSERT INTO SOE.ORDERS2 SELECT * FROM SOE.ORDERS WHERE ORDER_ID BETWEEN 10001 AND 10010;
--
COMMIT;
--
ALTER TABLE SOE.ORDERS2 ADD CONSTRAINT ORDERS2_PK PRIMARY KEY(ORDER_ID);
--
CREATE TABLE SOE.ORDER_ITEMS2
( 
	ORDER_ID NUMBER(12),
	LINE_ITEM_ID NUMBER(3),
	PRODUCT_ID NUMBER(6),
	UNIT_PRICE NUMBER(8,2),
	QUANTITY NUMBER(8),
	DISPATCH_DATE DATE,
	RETURN_DATE DATE,
	GIFT_WRAP VARCHAR2(20),
	CONDITION VARCHAR2(20),
	SUPPLIER_ID NUMBER(6),
	ESTIMATED_DELIVERY DATE
);
--
ALTER TABLE SOE.ORDER_ITEMS2 ADD ( CONSTRAINT ORDER_ITEMS2_FK_ORDERS2 FOREIGN KEY (ORDER_ID) REFERENCES SOE.ORDERS2(ORDER_ID));
--
INSERT INTO SOE.ORDER_ITEMS2 SELECT * FROM SOE.ORDER_ITEMS WHERE ORDER_ID BETWEEN 10001 AND 10010;
--
COMMIT;
--
CREATE INDEX SOE.ORDER_ITEMS2_IX ON SOE.ORDER_ITEMS2 (ORDER_ID);
--
exec DBMS_STATS.gather_table_stats('SOE', 'ORDERS2');
exec DBMS_STATS.gather_table_stats('SOE', 'ORDER_ITEMS2');