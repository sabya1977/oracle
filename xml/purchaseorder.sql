rem create oracle directory and load purchaseorder.xml file
rem
drop directory if exists xml_dir;
create or replace directory xml_dir as '/xmldir';
grant read,write on directory xml_dir to oradev23;
rem
drop table if exists practice.purchaseorder_xml;
create table practice.purchaseorder_xml of xmltype;
rem
insert into practice.purchaseorder_xml
   select xmltype(
      bfilename(
         'XML_DIR',
         'purchaseorder.xml'
      ),
      nls_charset_id('AL32UTF8')
   )
     from dual;
--
commit;  
--
--
rem how many xml documents are there?
select count(*)
  from practice.purchaseorder_xml p,
       xmltable ( 'for $r in /PurchaseOrders/PurchaseOrder return $r'
          passing object_value
       ) t;
rem
select reference,
       item_number,
       requestor,
       action_user,
       userid,
       costcenter,
       description,
       partno,
       quantity,
       unitprice
  from practice.purchaseorder_xml p,
       xmltable ( 'for $r in /PurchaseOrders/PurchaseOrder
          for $l in $r/LineItems/LineItem
          return 
            <Result ItemNumber="{fn:data($l/@ItemNumber)}"> 
                <Reference>{$r/Reference/text()}</Reference>
                <Requestor>{$r/Requestor/text()}</Requestor>
                <Actions><Action><User>{$r/Actions/Action/User/text()}</User></Action></Actions>
                <User>{$r/User/text()}</User>
                <CostCenter>{$r/CostCenter/text()}</CostCenter>
                <Quantity>{$l/Quantity/text()}</Quantity>
                <Description>{fn:data($l/Part/@Description)}</Description>
                <UnitPrice>{fn:data($l/Part/@UnitPrice)}</UnitPrice>
                <PartNumber>{$l/Part/text()}</PartNumber>
             </Result>'
             passing object_value
          columns
             sequence for ordinality,
             item_number number(3) path '@ItemNumber',
             reference varchar2(30) path 'Reference',
             requestor varchar2(128) path 'Requestor',
             action_user varchar2(128) path 'Actions/Action/User',
             userid varchar2(10) path 'User',
             costcenter varchar2(4) path 'CostCenter',
             description varchar2(256) path 'Description',
             partno varchar2(14) path 'PartNumber',
             quantity number(12,4) path 'Quantity',
             unitprice number(14,2) path 'UnitPrice'
       )
 order by 1,
          2;
rem 
rem create external table and load multiple XML files
rem
--
drop table if exists practice.po_xml;
create table practice.po_xml (
  doc1 clob
)
organization external (
  type oracle_loader
  default directory xml_dir
  access parameters (
    records
    xmltag ("PurchaseOrders")
    fields notrim
    missing field values are null (
      doc1 char(1000000)
    )
  )
  location ('po*.xml')
)
reject limit unlimited;
rem
select *
  from practice.po_xml;
--
rem
rem create stage table to convert clob data into xmltype and load into stage table
rem
drop table if exists practice.po_tab;
create table practice.po_tab 
(
    id int generated always as identity,
    xmldoc XMLType
);
--
rem load into stage table
rem
insert into practice.po_tab (xmldoc)
  select xmltype(doc1)
    from practice.po_xml;
--
commit;       
rem
select * from practice.po_tab;
rem
select count(*)
  from practice.po_tab p,
       xmltable ( 'for $r in /PurchaseOrders/PurchaseOrder return $r'
          passing p.xmldoc
       ) t;
rem
rem
select reference,
       item_number,
       requestor,
       action_user,
       userid,
       costcenter,
       description,
       partno,
       quantity,
       unitprice
  from practice.po_tab p,
       xmltable ( 'for $r in /PurchaseOrders/PurchaseOrder
          for $l in $r/LineItems/LineItem
          return 
            <Result ItemNumber="{fn:data($l/@ItemNumber)}"> 
                <Reference>{$r/Reference/text()}</Reference>
                <Requestor>{$r/Requestor/text()}</Requestor>
                <Actions><Action><User>{$r/Actions/Action/User/text()}</User></Action></Actions>
                <User>{$r/User/text()}</User>
                <CostCenter>{$r/CostCenter/text()}</CostCenter>
                <Quantity>{$l/Quantity/text()}</Quantity>
                <Description>{fn:data($l/Part/@Description)}</Description>
                <UnitPrice>{fn:data($l/Part/@UnitPrice)}</UnitPrice>
                <PartNumber>{$l/Part/text()}</PartNumber>
             </Result>'
             passing p.xmldoc
          columns
             sequence for ordinality,
             item_number number(3) path '@ItemNumber',
             reference varchar2(30) path 'Reference',
             requestor varchar2(128) path 'Requestor',
             action_user varchar2(128) path 'Actions/Action/User',
             userid varchar2(10) path 'User',
             costcenter varchar2(4) path 'CostCenter',
             description varchar2(256) path 'Description',
             partno varchar2(14) path 'PartNumber',
             quantity number(12,4) path 'Quantity',
             unitprice number(14,2) path 'UnitPrice'
       )
 order by 1,
          2;
--          