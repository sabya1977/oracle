select count(*)
  from practice.purchase_order_xml p,
       xmltable ( 'for $r in /PurchaseOrder return $r'
          passing object_value
       ) t;
--
select xt.*
  from practice.purchase_order_xml p,
       xmltable ( '/PurchaseOrder'
          passing object_value
          columns
             "Reference" varchar2(20) path 'Reference',
             "Requestor" varchar2(30) path 'Requestor',
             "User" varchar2(20) path 'User',
             "CostCenter" varchar2(10) path 'CostCenter'
       ) xt
 order by 1;
 --
 select t.object_value.getclobval ()
  from practice.purchase_order_xml t;
--
select t.object_value.getclobval()
  from practice.purchase_order_xml p,
       xmltable ( 'for $r in /PurchaseOrder[Reference/text()=$REFERENCE] return $r'
          passing object_value,
          'ACABRIO-1PDT' as "REFERENCE"
       ) t;  
--
select t.object_value.getclobval()
  from practice.purchase_order_xml p,
       xmltable ( 'for $r in /PurchaseOrder[CostCenter=$CC or Requestor=$REQUESTOR or count(LineItems/LineItem) > $QUANTITY]/Reference return $r'
          passing object_value,
          'A1' as "CC",
          'A. Cabrio 10' as "REQUESTOR",
          0 as "QUANTITY"
       ) t
 where rownum <= 5 ;      
 --
select xmlquery('<POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/LineItem)}">{
            $XML/PurchaseOrder/User,
            $XML/PurchaseOrder/Requestor,
            $XML/PurchaseOrder/LineItems/LineItem[2]
          }
          </POSummary>'
   passing object_value as "XML"
returning content).getclobval() initial_state
  from practice.purchase_order_xml
 where xmlexists ( '$XML/PurchaseOrder[Reference=$REF]'
   passing object_value as "XML",
   'ACABRIO-100PDT' as "REF"
);
--
select m.*
  from practice.purchase_order_xml p,
       xmltable ( '$p/PurchaseOrder'
             passing p.object_value as "p"
          columns
             reference path 'Reference/text()',
             requestor path 'Requestor/text()',
             userid path 'User/text()',
             costcenter path 'CostCenter/text()',
             ship_to_name path 'ShippingInstructions/name/text()',
             ship_to_street path 'ShippingInstructions/Address/street/text()',
             ship_to_city path 'ShippingInstructions/Address/city/text()',
             ship_to_county path 'ShippingInstructions/Address/county/text()',
             ship_to_postcode path 'ShippingInstructions/Address/postcode/text()',
             ship_to_state path 'ShippingInstructions/Address/state/text()',
             ship_to_province path 'ShippingInstructions/Address/province/text()',
             ship_to_zip path 'ShippingInstructions/Address/zipCode/text()',
             ship_to_country path 'ShippingInstructions/Address/country/text()',
             ship_to_phone path 'ShippingInstructions/telephone/text()',
             instructions path 'SpecialInstructions/text()'
       ) m
--
select m.reference,
       l.*
  from practice.purchase_order_xml p,
       xmltable ( '$p/PurchaseOrder'
             passing p.object_value as "p"
          columns
             reference path 'Reference/text()',
             lineitems xmltype path 'LineItems/LineItem'
       ) m,
       xmltable ( '$l/LineItem'
             passing m.lineitems as "l"
          columns
             itemno path '@ItemNumber',
             description path 'Part/@Description',
             partno path 'Part/text()',
             quantity path 'Quantity',
             unitprice path 'Part/@UnitPrice'
       ) l
 where xmlexists ( '$XML/PurchaseOrder[Reference=$REF]'
   passing object_value as "XML",
   'ACABRIO-100PDT' as "REF"
);
--
select reference, item_number, requestor, action_user, userid, costcenter, description, partno, quantity, unitprice
  from practice.purchase_order_xml p,
       xmltable ( 'for $r in /PurchaseOrder
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
       );