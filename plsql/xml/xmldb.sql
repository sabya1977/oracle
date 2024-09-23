-- name: xmldb.sql
-- 
-- Oracle XML DB : Storing and Processing XML Documents
-- 
-- Oracle XML DB is a set of Oracle Database technologies related to 
-- high-performance handling of XML data: storing, generating, accessing,
-- searching, validating, transforming, evolving, and indexing. It provides
-- native XML support by encompassing both the SQL and XML data models in an
-- interoperable way.
-- 
-- In this tutorial, we will go through some basic stuffs of XML DB. 
-- 
-- Setup :: Let's first reset the tutorial by running following statement:
-- 
DECLARE
    CURSOR gettable IS
      SELECT table_name
      FROM   dba_xml_tables
      WHERE  table_name IN ( 'PURCHASEORDER' );
BEGIN
    FOR t IN gettable() LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "'|| t.table_name|| '" PURGE';
    END LOOP;
END;
/  
-- 
-- create an xmltype table and insert some xml documents.
-- 
DROP TABLE purchaseorder;
CREATE TABLE purchaseorder OF xmltype;
-- 
INSERT INTO purchaseorder
VALUES ('<?xml version="1.0"?>
<PurchaseOrder PurchaseOrderNumber="99503" OrderDate="1999-10-20">
  <Address Type="Shipping">
    <Name>Ellen Adams</Name>
    <Street>123 Maple Street</Street>
    <City>Mill Valley</City>
    <State>CA</State>
    <Zip>10999</Zip>
    <Country>USA</Country>
  </Address>
  <Address Type="Billing">
    <Name>Tai Yee</Name>
    <Street>8 Oak Avenue</Street>
    <City>Old Town</City>
    <State>PA</State>
    <Zip>95819</Zip>
    <Country>USA</Country>
  </Address>
  <DeliveryNotes>Please leave packages in shed by driveway.</DeliveryNotes>
  <Items>
    <Item PartNumber="872-AA">
      <ProductName>Lawnmower</ProductName>
      <Quantity>1</Quantity>
      <USPrice>148.95</USPrice>
      <Comment>Confirm this is electric</Comment>
    </Item>
    <Item PartNumber="926-AA">
      <ProductName>Baby Monitor</ProductName>
      <Quantity>2</Quantity>
      <USPrice>39.98</USPrice>
      <ShipDate>1999-05-21</ShipDate>
    </Item>
  </Items>
</PurchaseOrder>');
-- 
SELECT Xmlquery('/PurchaseOrder/Address/Name' passing object_value returning
       content)
FROM   purchaseorder
WHERE  ROWNUM <= 5;
-- 
SELECT Xmlquery('/PurchaseOrder/Address/Name/text()' passing object_value returning
       content)
FROM   purchaseorder
WHERE  ROWNUM <= 5;