SELECT /* MY QUERY */
	ORDERS2.ORDER_ID,
	ORDER_DATE,
	ORDER_TOTAL, 
	LINE_ITEM_ID,
	PRODUCT_ID, 
	UNIT_PRICE
FROM 
	SOE.ORDERS2, 
	SOE.ORDER_ITEMS2
WHERE 
	ORDERS2.ORDER_ID = ORDER_ITEMS2.ORDER_ID AND TO_CHAR(ORDER_DATE,'YYYY')=2010;