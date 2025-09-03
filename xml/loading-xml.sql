rem loading-xml.sql
rem Author: Sabyasachi Mitra
rem Date: 08/23/2025
rem courtsey: Tim Hall (oracale-base)
rem Description: Various methods to load XML documents into Oracle Database.
rem
rem create a directory object and grant read,write on it to the oradev23
--
drop directory if exists tmp_dir;
create or replace directory tmp_dir as '/tmp/';
grant read,write on directory tmp_dir to oradev23;
--
rem create an external table to load the XML documents as single tag XML
rem XMLTAG will indicate we want to return XML fragments with employee as a tag name.
rem
drop table if exists practice.xml_ext;

create table practice.xml_ext (
  doc1 clob
)
organization external (
  type oracle_loader
  default directory tmp_dir
  access parameters (
    records
    xmltag ("employee")
    fields notrim
    missing field values are null (
      doc1 char(1000000)
    )
  )
  location ('emp_multi_tag.xml')
)
reject limit unlimited;
--
rem display data
select doc1
  from practice.xml_ext;
rem
rem create an external table to load the XML documents as multi tag XML
rem
drop table if exists practice.xml_ext;
rem
create table practice.xml_ext (
  doc1 varchar2(4000)
)
organization external (
  type oracle_loader
  default directory tmp_dir
  access parameters (
    records
    xmltag ("employee_number", "employee_name", "job")
    fields notrim
    missing field values are null
  )
  location ('emp_multi_tag.xml')
)
reject limit unlimited;
rem display data
select doc1
  from practice.xml_ext;
rem 
drop table if exists practice.purchase_order_xml;
--
create table practice.purchase_order_xml of xmltype;
rem insert data
begin
   for i in 1..100 loop
      insert into practice.purchase_order_xml values ('<PurchaseOrder><Reference>ACABRIO-'
                                         || i
                                         || 'PDT</Reference><Actions><Action><User>ACABRIO-'
                                         || i
                                         || '</User></Action></Actions><Rejection/><Requestor>A. Cabrio '
                                         || i
                                         || '</Requestor><User>ACABRIO-'
                                         || i
                                         || '</User><CostCenter>A'
                                         || i
                                         || '</CostCenter><ShippingInstructions><name>A. Cabrio '
                                         || i
                                         || '</name><Address><street>'
                                         || i
                                         || ' Sporting Green Centre, Science Club, building '
                                         || i
                                         || ', Magdalen</street><city>SFO-'
                                         || i
                                         || '</city><state>CA</state><zipCode>99236</zipCode><country>United States of America</country></Address><telephone>269-'
                                         || i
                                         || '-4036</telephone></ShippingInstructions><SpecialInstructions>Priority Overnight</SpecialInstructions><LineItems><LineItem ItemNumber="1"><Part Description="Face to Face: First Seven Years" UnitPrice="19.95">'
                                         || i
                                         || '</Part><Quantity>'
                                         || i
                                         || '</Quantity></LineItem><LineItem ItemNumber="2"><Part Description="Runaway" UnitPrice="27.95">'
                                         || i
                                         || '</Part><Quantity>'
                                         || i
                                         || '</Quantity></LineItem><LineItem ItemNumber="3"><Part Description="Founding Fathers: Men Who Shaped" UnitPrice="19.95">'
                                         || i
                                         || '</Part><Quantity>'
                                         || i
                                         || '</Quantity></LineItem></LineItems></PurchaseOrder>' );
   end loop;
end;
/
commit;
--
select * from practice.purchase_order_xml;
--
